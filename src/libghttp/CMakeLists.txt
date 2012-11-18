set (GHTTP_LIST
  ghttp.c
  http_base64.c
  http_date.c
  http_hdrs.c
  http_req.c
  http_resp.c
  http_trans.c
  http_uri.c
  )
include_directories(
  .
  )
add_library(libghttp ${GHTTP_LIST})
