
set(LWQQ_LIST
  liblwqq/url.c
  liblwqq/md5.c
  liblwqq/unicode.c
  liblwqq/logger.c
  liblwqq/login.c
  liblwqq/json.c
  liblwqq/msg.c
  liblwqq/type.c
  liblwqq/smemory.c
  liblwqq/info.c)
add_library(webqq MODULE
	${LWQQ_LIST}
	)
target_link_libraries(
	webqq
	${CURL_LIBRARIES}
	)
include_directories(
	liblwqq
	)

add_executable (webqqdicebot webqqdicebot.c)


