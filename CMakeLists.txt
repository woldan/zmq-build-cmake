cmake_minimum_required(VERSION 2.8)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# .. load configurable options (edit `options.cmake` to change them) ..
include(options)

project(zmq)

add_subdirectory(libzmq)
add_subdirectory(czmq)
add_subdirectory(majordomo)

