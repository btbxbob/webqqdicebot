#add_subdirectory(libghttp)
#include_directories (${LIBGHTTP_SOURCE_DIR}/libghttp)  
#link_directories (${LIBGHTTP_BINARY_DIR}/libghttp)
#include_directories (${GLLIB_SOURCE_DIR}/gllib)

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
  gllib/vasprintf.c
  gllib/strndup.c
  gllib/vasnprintf.c
  gllib/printf-parse.c
  gllib/printf-args.c
  gllib/xsize.c
  )
add_library(lwqq
	${LWQQ_LIST}
	)

if(WIN32)
add_library(strtok_r
	strtok_r.c
	gllib/strnlen.c
	)
add_library(utf82gbk
	utf82gbk.c
	)
endif(WIN32)

include_directories(
	liblwqq
	gllib
	${CURL_INCLUDE_DIRS}
	${LUAJIT_INCLUDE_DIRS}
	)

if(WIN32)
add_executable (webqqdicebot webqqdicebot.c)
#add_library (gnu gllib/vasprintf.c gllib/strndup.c)
else(WIN32)
add_executable (webqqdicebot webqqdicebot.c)
endif(WIN32)

if(WIN32)
target_link_libraries(
	webqqdicebot
	${LUAJIT_LIBRARIES}
#	gnu
	lwqq
	ev
	strtok_r
	utf82gbk
	iconv
	pthread
	curl.dll
#	curl
	z.dll
	ws2_32.lib
	)
else(WIN32)
target_link_libraries(
	webqqdicebot
	lwqq
#	libghttp
	ev
	pthread
	${CURL_LIBRARIES}
#	${GLIB_LIBRARIES}
	${LUAJIT_LIBRARIES}
	)
endif(WIN32)