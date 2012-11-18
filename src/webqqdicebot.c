#include <stdio.h>
#include <string.h>

//liblwqq
#include <type.h>
#include <async.h>
#include <msg.h>
#include <info.h>
#include <http.h>
#include <login.h>
#include <logger.h>

//i hate unistd.h
#define F_OK 0 

//lc:lwqq client
static LwqqClient *lc = NULL;
//static LWQQ_STATUS status;

//verify files
static char vc_image[128];
static char vc_file[128];

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
    return strdup(vc);
}

//hanle login verify
static LwqqErrorCode cli_login()
{
    LwqqErrorCode err;

    lwqq_login(lc, &err);
    if (err == LWQQ_EC_LOGIN_NEED_VC) {
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
            goto failed;
        }
        lwqq_log(LOG_NOTICE, "Get verify code: %s\n", lc->vc->str);
        lwqq_login(lc, &err);
    } else if (err != LWQQ_EC_OK) {
        goto failed;
    }

    return err;

failed:
    return LWQQ_EC_ERROR;
}

int main(int argc, char **argv)
{
	LwqqErrorCode err;
	//1.Create lc with password and qq_num
	lc = lwqq_client_new("btbxbob@gmail.com", "irobot");
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

	return 0;
}
