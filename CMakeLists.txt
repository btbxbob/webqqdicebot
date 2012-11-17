cmake_minimum_required (VERSION 2.6)
project (webqqdicebot)

find_package(PkgConfig REQUIRED)
pkg_check_modules(PURPLE REQUIRED  purple>=2.8.0)

add_subdirectory(src)
