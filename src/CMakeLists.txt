add_subdirectory(libghttp)
include_directories (${LIBGHTTP_SOURCE_DIR}/libghttp)  
link_directories (${LIBGHTTP_BINARY_DIR}/libghttp) 

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
  liblwqq/info.c
  liblwqq/async.c
  #liblwqq/http.c
  liblwqq/http_curl.c
  )
add_library(liblwqq
	${LWQQ_LIST}
	)

include_directories(
	liblwqq
	libghttp
	${GLIB_INCLUDE_DIRS}
	${CURL_INCLUDE_DIRS}
	)

add_executable (webqqdicebot webqqdicebot.c)

target_link_libraries(
	webqqdicebot
	liblwqq
	libghttp
	ev
	${CURL_LIBRARIES}
	${GLIB_LIBRARIES}
	)
