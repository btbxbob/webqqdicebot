
/**
 * @file   async.c
 * @author xiehuc<xiehuc@gmail.com>
 * @date   Sun May 20 02:21:43 2012
 *
 * @brief  Linux WebQQ Async API
 * use libev
 *
 */

#include <stdlib.h>
#include <string.h>
//#include <plugin.h>
#include "async.h"
#include "smemory.h"
#include "http.h"
typedef struct async_dispatch_data {
    ListenerType type;
    LwqqClient* client;
    LwqqAsyncTimer handle;
    void* data;
} async_dispatch_data;
typedef struct _LwqqAsyncEvset{
    int result;///<it must put first
    pthread_mutex_t lock;
    pthread_cond_t cond;
    int cond_waiting;
    int ref_count;
    EVSET_CALLBACK callback;
    void* data;
}_LwqqAsyncEvset;
typedef struct _LwqqAsyncEvent {
    int result;///<it must put first
    LwqqAsyncEvset* host_lock;
    EVENT_CALLBACK callback;
    void* data;
    LwqqHttpRequest* req;
}_LwqqAsyncEvent;

int LWQQ_ASYNC_GLOBAL_SYNC_ENABLED = 0;

static int timeout_come(void* p)
{
    async_dispatch_data* data = (async_dispatch_data*)p;
    LwqqClient* lc = data->client;
    ListenerType type = data->type;
    if(lwqq_client_valid(lc)&&lwqq_async_enabled(lc)){
        if(lc->async->listener[type]!=NULL)
            lc->async->listener[type](lc,data->data);
    }
    free(data);
    //remote handle;
    return 0;
}

void lwqq_async_dispatch(LwqqClient* lc,ListenerType type,void* param)
{
    if(!lwqq_client_valid(lc)||!lwqq_async_has_listener(lc,type))
        return;
    async_dispatch_data* data = malloc(sizeof(async_dispatch_data));
    data->type = type;
    data->client = lc;
    data->data = param;
    lwqq_async_timer_watch(&data->handle, 50, timeout_come, data);
}



void lwqq_async_set(LwqqClient* client,int enabled)
{
    if(enabled&&client->async==NULL) {
        client->async = s_malloc0(sizeof(LwqqAsync));
        client->async->_enabled=1;
    } else if(!enabled&&lwqq_async_enabled(client)) {
        client->async->_enabled=0;
        /*free(client->async);
        client->async=NULL;*/
    }

}
LwqqAsyncEvent* lwqq_async_event_new(void* req)
{
    LwqqAsyncEvent* event = s_malloc0(sizeof(LwqqAsyncEvent));
    event->req = req;
    return event;
}
LwqqAsyncEvset* lwqq_async_evset_new()
{
    LwqqAsyncEvset* l = s_malloc0(sizeof(*l));
    pthread_mutex_init(&l->lock,NULL);
    pthread_cond_init(&l->cond,NULL);
    return l;
}
void lwqq_async_event_finish(LwqqAsyncEvent* event)
{
    if(event->callback){
        event->callback(event,event->data);
    }
    LwqqAsyncEvset* evset = event->host_lock;
    if(evset !=NULL){
        pthread_mutex_lock(&evset->lock);
        evset->ref_count--;
        //this store evset result.
        //it can only store one error number.
        if(event->result != 0)
            evset->result = event->result;
        if(event->host_lock->ref_count==0){
            if(evset->callback)
                evset->callback(evset,evset->data);
            if(evset->cond_waiting)
                pthread_cond_signal(&evset->cond);
            else{
                pthread_mutex_unlock(&evset->lock);
                s_free(evset);
                s_free(event);
                return;
            }
        }
        pthread_mutex_unlock(&evset->lock);
    }
    s_free(event);
}
void lwqq_async_evset_add_event(LwqqAsyncEvset* host,LwqqAsyncEvent *handle)
{
    if(!host || !handle) return;
    pthread_mutex_lock(&host->lock);
    handle->host_lock = host;
    host->ref_count++;
    pthread_mutex_unlock(&host->lock);
}

void lwqq_async_add_event_listener(LwqqAsyncEvent* event,EVENT_CALLBACK callback,void* data)
{
    if(event == NULL){
        callback(NULL,data);
        return ;
    }
    event->callback = callback;
    event->data = data;
}
static void async_call_on_chain(LwqqAsyncEvent* ev,void* data)
{
    lwqq_async_event_finish((LwqqAsyncEvent*)data);
}
void lwqq_async_add_event_chain(LwqqAsyncEvent* caller,LwqqAsyncEvent* called)
{
    lwqq_async_add_event_listener(caller,async_call_on_chain,called);
}
void lwqq_async_add_evset_listener(LwqqAsyncEvset* evset,EVSET_CALLBACK callback,void* data)
{
    if(!evset) return;
    evset->callback = callback;
    evset->data = data;
}

void lwqq_async_event_set_progress(LwqqAsyncEvent* event,LWQQ_PROGRESS callback,void* data)
{
    lwqq_http_on_progress(event->req,callback,data);
}
typedef struct {
    LwqqAsyncIoCallback callback;
    void* data;
}LwqqAsyncIoWrap;
typedef struct {
    LwqqAsyncTimerCallback callback;
    void* data;
}LwqqAsyncTimerWrap;
#ifdef USE_LIBEV
static enum{
    THREAD_NOT_CREATED,
    THREAD_NOW_WAITING,
    THREAD_NOW_RUNNING,
} ev_thread_status;
pthread_cond_t ev_thread_cond = PTHREAD_COND_INITIALIZER;
static void *ev_run_thread(void* data)
{
    printf("the ev_thread created\n");
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    while(1){
        ev_thread_status = THREAD_NOW_RUNNING;
        ev_run(EV_DEFAULT,0);
        if(ev_thread_status == THREAD_NOT_CREATED) return NULL;
        ev_thread_status = THREAD_NOW_WAITING;
        pthread_mutex_lock(&mutex);
        pthread_cond_wait(&ev_thread_cond,&mutex);
        pthread_mutex_unlock(&mutex);
        if(ev_thread_status == THREAD_NOT_CREATED) return NULL;
    }
    return NULL;
}
static void start_ev_thread()
{
    if(ev_thread_status == THREAD_NOW_WAITING){
        pthread_cond_signal(&ev_thread_cond);
    }else if(ev_thread_status == THREAD_NOT_CREATED){
        ev_thread_status = THREAD_NOW_RUNNING;
        pthread_t pid;
        pthread_create(&pid,NULL,ev_run_thread,NULL);
    }
}
static void event_cb_wrap(EV_P_ ev_io *w,int action)
{
    LwqqAsyncIoWrap* wrap = w->data;
    if(wrap->callback)
        wrap->callback(wrap->data,w->fd,action);
}
void lwqq_async_io_watch(LwqqAsyncIoHandle io,int fd,int action,LwqqAsyncIoCallback fun,void* data)
{
    ev_io_init(io,event_cb_wrap,fd,action);
    LwqqAsyncIoWrap* wrap = s_malloc0(sizeof(*wrap));
    wrap->callback = fun;
    wrap->data = data;
    io->data = wrap;
    ev_io_start(EV_DEFAULT,io);
    if(ev_thread_status!=THREAD_NOW_RUNNING) 
        start_ev_thread();
}
void lwqq_async_io_stop(LwqqAsyncIoHandle io)
{
    ev_io_stop(EV_DEFAULT,io);
    s_free(io->data);
}
static void timer_cb_wrap(EV_P_ ev_timer* w,int revents)
{
    LwqqAsyncTimerWrap* wrap = w->data;
    int stop=1;
    if(wrap->callback)
        stop = ! wrap->callback(wrap->data);
    if(stop)
        lwqq_async_timer_stop(w);
}
void lwqq_async_timer_watch(LwqqAsyncTimerHandle timer,unsigned int timeout_ms,LwqqAsyncTimerCallback fun,void* data)
{
    double second = (timeout_ms) / 1000.0;
    ev_timer_init(timer,timer_cb_wrap,second,second);
    LwqqAsyncTimerWrap* wrap = s_malloc(sizeof(*wrap));
    wrap->callback = fun;
    wrap->data = data;
    timer->data = wrap;
    ev_timer_start(EV_DEFAULT,timer);
    if(ev_thread_status!=THREAD_NOW_RUNNING) 
        start_ev_thread();
}
void lwqq_async_timer_stop(LwqqAsyncTimerHandle timer)
{
    ev_timer_stop(EV_DEFAULT,timer);
    s_free(timer->data);
}
void lwqq_async_global_quit()
{
    if(ev_thread_status == THREAD_NOW_WAITING){
        ev_thread_status = THREAD_NOT_CREATED;
        pthread_cond_signal(&ev_thread_cond);
    }else if(ev_thread_status == THREAD_NOW_RUNNING){
        ev_break(EV_DEFAULT,0);
    }
}
#endif
#ifdef USE_LIBPURPLE
static void event_cb_wrap(void* data,int fd,PurpleInputCondition action)
{
    LwqqAsyncIoWrap* wrap = data;
    if(wrap->callback)
        wrap->callback(wrap->data,fd,action);
}
void lwqq_async_io_watch(LwqqAsyncIoHandle io,int fd,int action,LwqqAsyncIoCallback fun,void* data)
{
    LwqqAsyncIoWrap* wrap = s_malloc0(sizeof(*wrap));
    wrap->callback = fun;
    wrap->data = data;
    io->ev = purple_input_add(fd,action,event_cb_wrap,wrap);
    io->wrap = wrap;
}
void lwqq_async_io_stop(LwqqAsyncIoHandle io)
{
    purple_input_remove(io->ev);
    io->ev = 0;
    s_free(io->wrap);
}
void lwqq_async_timer_watch(LwqqAsyncTimerHandle timer,unsigned int timeout_ms,LwqqAsyncTimerCallback fun,void* data)
{
    *timer = purple_timeout_add(timeout_ms,fun,data);
}
void lwqq_async_timer_stop(LwqqAsyncTimerHandle timer)
{
    purple_timeout_remove(*timer);
    *timer = 0;
}
void lwqq_async_global_quit() {}
#endif
