#include "gllib/stdio.h"
#include <stdlib.h>
#include "gllib/string.h"
#include <pthread.h>
#include <malloc.h>
#include <unistd.h>

//liblwqq
#include <type.h>
#include <async.h>
#include <msg.h>
#include <info.h>
#include <http.h>
#include <login.h>
#include <logger.h>
#include <smemory.h>

//luajit
#if (_WIN32)
	#include <luajit-2.0\luajit.h>
	#include <luajit-2.0\lualib.h>
	#include <luajit-2.0\lauxlib.h>
#else
	#include <luajit.h>
	#include <lualib.h>
	#include <lauxlib.h>
#endif
//the luajit state
lua_State *L;

//for windows
#if defined(_WIN32) || defined(_WIN64)
    #include "strtok_r.h"
    #include <windows.h>
    #include <iconv.h>
    #include "utf82gbk.h"
    #define sleep(n) Sleep(1000 * n)
    #define _TEXT utf82gbk
#else
    #define _TEXT
#endif

//i hate unistd.h
#define F_OK 0 

static char *progname="dicebot";

//lc:lwqq client
static LwqqClient *lc = NULL;
//static LWQQ_STATUS status;

//verify files
static char vc_image[128];
static char vc_file[128];

//commands
typedef int (*cfunc_t)(int argc, char **argv);
static int help_f(int argc, char **argv);
static int quit_f(int argc, char **argv);
static int list_f(int argc, char **argv);
static int send_f(int argc, char **argv);
typedef struct CmdInfo {
	const char	*name;
	const char	*altname;
	cfunc_t		cfunc;
} CmdInfo;
static CmdInfo cmdtab[] = {
    {"help", "h", help_f},
    {"quit", "q", quit_f},
    {"list", "l", list_f},
    {"send", "s", send_f},
    {NULL, NULL, NULL},
};

//-----------------------
const CmdInfo *find_command(const char *cmd)
{
	CmdInfo	*ct;

	for (ct = cmdtab; ct->name; ct++) {
		if (!strcmp(ct->name, cmd) || !strcmp(ct->altname, cmd)) {
			return (const CmdInfo *)ct;
        }
	}
	return NULL;
}
static char *get_prompt(void)
{
	static char	prompt[256];

	if (!prompt[0])
		snprintf(prompt, sizeof(prompt), "%s> ", progname);
	return prompt;
}
static char **breakline(char *input, int *count)
{
    int c = 0;
    char **rval = calloc(sizeof(char *), 1);
    char **tmp;
    char *token, *save_ptr;

    token = strtok_r(input, " ", &save_ptr);
	while (token) {
        c++;
        tmp = realloc(rval, sizeof(*rval) * (c + 1));
        rval = tmp;
        rval[c - 1] = token;
        rval[c] = NULL;
        token = strtok_r(NULL, " ", &save_ptr);
	}
    
    *count = c;

    if (c == 0) {
        free(rval);
        return NULL;
    }
    
    return rval;
}
static int help_f(int argc, char **argv)
{
    printf(
        "\n"
        " Excute a command\n"
        "\n"
        " help/h, -- Output help\n"
        " list/l, -- List buddies\n"
        "            You can use \"list all\" to list all buddies\n"
        "            or use \"list uin\" to list certain buddy\n"
        " send/s, -- Send message to buddy\n"
        "            You can use \"send uin message\" to send message\n"
        "            to buddy"
        "\n");
    
    return 0;
}
static int quit_f(int argc, char **argv)
{
    return 1;
}
static int list_f(int argc, char **argv)
{
    char buf[1024] = {0};

    /** argv may like:
     * 1. {"list", "all"}
     * 2. {"list", "244569070"}
     */
    if (argc != 2) {
        return 0;
    }

    if (!strcmp(argv[1], "all")) {
        /* List all buddies */
        LwqqBuddy *buddy;
        LIST_FOREACH(buddy, &lc->friends, entries) {
            if (!buddy->uin) {
                /* BUG */
                return 0;
            }
            snprintf(buf, sizeof(buf), "uin:%s, ", buddy->uin);
            if (buddy->nick) {
                strcat(buf, "nick:");
                strcat(buf, buddy->nick);
                strcat(buf, ", ");
            }
            printf("Buddy info: %s\n", buf);
        }
    } else {
        /* Show buddies whose uin is argv[1] */
        LwqqBuddy *buddy;
        LIST_FOREACH(buddy, &lc->friends, entries) {
            if (buddy->uin && !strcmp(buddy->uin, argv[1])) {
                snprintf(buf, sizeof(buf), "uin:%s, ", argv[1]);
                if (buddy->nick) {
                    strcat(buf, "nick:");
                    strcat(buf, buddy->nick);
                    strcat(buf, ", ");
                }
                if (buddy->markname) {
                    strcat(buf, "markname:");
                    strcat(buf, buddy->markname);
                }
                printf("Buddy info: %s\n", buf);
                break;
            }
        }
    }

    return 0;
}
static int send_f(int argc, char **argv)
{
    /* argv look like: {"send", "74357485" "hello"} */
    if (argc != 3) {
        return 0;
    }
    lwqq_msg_send2(lc, argv[1], argv[2]);
    return 0;
}
//-----------------------

//
static char *get_vc()
{
    char vc[128] = {0};
    int vc_len;
    FILE *f;

    if ((f = fopen(vc_file, "r")) == NULL) {
        return NULL;
    }

    if (!fgets(vc, sizeof(vc), f)) {
        fclose(f);
        return NULL;
    }
    
    //TODO:what's this...
    vc_len = strlen(vc);
    if (vc[vc_len - 1] == '\n') {
        vc[vc_len - 1] = '\0';
    }
    return s_strdup(vc);
}

//hanle login verify
static LwqqErrorCode cli_login()
{
    LwqqErrorCode err;

    lwqq_login(lc, &err);
    if (err == LWQQ_EC_LOGIN_NEED_VC) 
    {
        snprintf(vc_image, sizeof(vc_image), "/tmp/lwqq_%s.jpeg", lc->username);
        snprintf(vc_file, sizeof(vc_file), "/tmp/lwqq_%s.txt", lc->username);
        /* Delete old verify image */
        unlink(vc_file);

        lwqq_log(LOG_NOTICE, "Need verify code to login, please check "
                 "image file %s, and input what you see to file %s\n",
                 vc_image, vc_file);
        while (1) {
            if (!access(vc_file, F_OK)) {
                sleep(1);
                break;
            }
            sleep(1);
        }
        lc->vc->str = get_vc();
        if (!lc->vc->str) {
            return LWQQ_EC_ERROR;
        }
        lwqq_log(LOG_NOTICE, "Get verify code: %s\n", lc->vc->str);
        lwqq_login(lc, &err);
    } else if (err != LWQQ_EC_OK) {
        return LWQQ_EC_ERROR;
    }

    return err;
}

static void cli_logout(LwqqClient *lc)
{
    LwqqErrorCode err;
    
    lwqq_logout(lc, &err);
    if (err != LWQQ_EC_OK) {
        lwqq_log(LOG_DEBUG, "Logout failed\n");        
    } else {
        lwqq_log(LOG_DEBUG, "Logout sucessfully\n");
    }
}

static void handle_new_msg(LwqqRecvMsg *recvmsg)
{
    LwqqMsg *msg = recvmsg->msg;

    printf("Receive message type: %d\n", msg->type);
    //buddy msg
    if (msg->type == LWQQ_MT_BUDDY_MSG) {
        char buf[1024] = {0};
        LwqqMsgContent *c;
        LwqqMsgMessage *mmsg = msg->opaque;
        TAILQ_FOREACH(c, &mmsg->content, entries) {
            if (c->type == LWQQ_CONTENT_STRING) {
                strcat(buf, c->data.str);
            } else {
                printf ("Receive face msg: %d\n", c->data.face);
            }
        }
        printf("BUDDY[%s]:%s\n", _TEXT(mmsg->from), _TEXT(buf));
    } else if (msg->type == LWQQ_MT_GROUP_MSG) {
        LwqqMsgMessage *mmsg = msg->opaque;
        char buf[1024] = {0};
        LwqqMsgContent *c;
        char sender[128];
        //sender=mmsg->from;
        TAILQ_FOREACH(c, &mmsg->content, entries) 
        {
            if (c->type == LWQQ_CONTENT_STRING) {
                strcat(buf, c->data.str);
            } else {
                printf ("Receive face msg: %d\n", c->data.face);
            }
        }
        printf("GROUP[%s]:%s\n", _TEXT(mmsg->from), _TEXT(buf));
    } else if (msg->type == LWQQ_MT_STATUS_CHANGE) {
        LwqqMsgStatusChange *status = msg->opaque;
        printf("Receive status change: %s - > %s\n", 
               status->who,
               status->status);
    } else {
        printf("unknow message\n");
    }
    
    lwqq_msg_free(recvmsg->msg);
    s_free(recvmsg);
}

//command loop: we should have a command to reload luascripts here
static void command_loop()
{
    static char command[1024];
    int done = 0;

    while (!done) {
        char **v;
        char *p;
        int c = 0;
        const CmdInfo *ct;
        fprintf(stdout, "%s", get_prompt());
        fflush(stdout);
        memset(&command, 0, sizeof(command));
        if (!fgets(command, sizeof(command), stdin)) {
            /* Avoid gcc warning */
            continue;
        }
        p = command + strlen(command);
        if (p != command && p[-1] == '\n') {
            p[-1] = '\0';
        }
        
        v = breakline(command, &c);
        if (v) {
            ct = find_command(v[0]);
            if (ct) {
                done = ct->cfunc(c, v);
            } else {
                fprintf(stderr, "command \"%s\" not found\n", v[0]);
            }
            free(v);
        }
    }
}

//thread that handle msg.
static void *recvmsg_thread(void *list)
{
    LwqqRecvMsgList *l = (LwqqRecvMsgList *)list;

    /* Poll to receive message */
    l->poll_msg(l);

    /* Need to wrap those code so look like more nice */
    while (1) {
        LwqqRecvMsg *recvmsg;
        pthread_mutex_lock(&l->mutex);
        if (SIMPLEQ_EMPTY(&l->head)) {
            /* No message now, wait 100ms */
            pthread_mutex_unlock(&l->mutex);
            sleep(1);
            continue;
        }
        recvmsg = SIMPLEQ_FIRST(&l->head);
        SIMPLEQ_REMOVE_HEAD(&l->head, entries);
        pthread_mutex_unlock(&l->mutex);
        handle_new_msg(recvmsg);
    }

    pthread_exit(NULL);
}

//thread that handle friends info(maybe)
static void *info_thread(void *lc)
{
    LwqqErrorCode err;
    lwqq_info_get_friends_info(lc, &err);
    //lwqq_info_get_all_friend_qqnumbers(lc, &err);
    pthread_exit(NULL);
}

//maybe just for windows
static int lua_to_gb(lua_State *L)
{
    const char *input=luaL_checkstring(L,1);
    printf("%s\n",_TEXT((char *)input));
    return 0;
}

int main(int argc, char **argv)
{

	//0. i think i should init luajit here
	//TODO: luajit init
    L=luaL_newstate();
    luaL_openlibs(L);
    //HACK:
    //if is windows, over write lua's print
    #if(_WIN32)
        lua_pushcfunction(L, lua_to_gb);
        lua_setglobal(L, "print");
    #endif
    //load bot's pass via lua
    char uid[128];
    char password[32];
    luaL_dofile(L,"settings.lua");
    lua_getglobal(L,"uid");
    strcpy(uid,lua_tostring(L,-1));
    lua_getglobal(L,"password");
    strcpy(password,lua_tostring(L,-1));

	LwqqErrorCode err;
	pthread_t tid[2];
    pthread_attr_t attr[2];
	//1.Create lc with password and qq_num
	lc = lwqq_client_new(uid, password);
    if (!lc) {
        lwqq_log(LOG_NOTICE, "Create lwqq client failed\n");
        return -1;
    }
    //2.using the login verify hanle
    err = cli_login();
    //login fail
    if (err != LWQQ_EC_OK) {
        lwqq_log(LOG_ERROR, "Login error, exit\n");
        lwqq_client_free(lc);
        return -1;
    }
    //login success
    lwqq_log(LOG_NOTICE, "Login successfully\n");
    
    //3. into multi thread part, to receive & process msg.
    /* Initialize thread */
    for (int i = 0; i < 2; ++i) {
        pthread_attr_init(&attr[i]);
        pthread_attr_setdetachstate(&attr[i], PTHREAD_CREATE_DETACHED);
    }

    /* Create a thread to receive message */
    pthread_create(&tid[0], &attr[0], recvmsg_thread, lc->msg_list);

    /* Create a thread to update friend info */
    pthread_create(&tid[1], &attr[1], info_thread, lc);

	//commandline loop
    /* Enter command loop  */
    command_loop();
    
    /* Logout */
    cli_logout(lc);
    lwqq_client_free(lc);
    lua_close(L);

	return 0;
}
