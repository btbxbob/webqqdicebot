#include <QCoreApplication>
#include <QDebug>
extern "C" {
#include "lwqq.h"
}

int main(int argc, char *argv[])
{
  qDebug()<< "Start";
  QCoreApplication a(argc, argv);

  LwqqClient* lc = lwqq_client_new("btbxbob@gmail.com", "irobot");

  lwqq_log_set_level(4);
  /*
  0.  不输出额外的信息
  1.  输出poll轮循的响应
  2.  输出所有请求的响应
  3.  输出所有http请求的url和post
  4.  输出图像传输时候的详细信息
  5.  预留
  */
  LwqqErrorCode err = LWQQ_EC_OK;
  lwqq_login(lc, LWQQ_STATUS_ONLINE, &err);

  char vcode[5] = {0};
  switch(err){
      case LWQQ_EC_LOGIN_NEED_VC:
          lwqq_util_save_img(lc->vc->data, lc->vc->size, "verify.jpg", NULL);
          printf("Input Verify:");
          scanf("%s",vcode);
          lc->vc->str = s_strdup(vcode);
          break;
      case LWQQ_EC_OK:
          printf("login successful\n");
          break;
      default:
          printf("login failed\n");
          break;
  }

  if(lwqq_client_logined(lc)) lwqq_logout(lc, NULL);
  lwqq_client_free(lc);
  return a.exec();

}
