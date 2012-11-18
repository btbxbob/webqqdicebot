cmake_minimum_required (VERSION 2.6)
project (webqqdicebot)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GLIB REQUIRED  glib-2.0)
pkg_check_modules(CURL REQUIRED libcurl)

add_subdirectory(src)
