cmake_minimum_required(VERSION 2.8)

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/stage)
if (APPLE)
  set(ZMQ_BUILD_FRAMEWORK OFF)
endif (APPLE)

project(zmq)

add_subdirectory(libzmq)
add_subdirectory(czmq)
add_subdirectory(majordomo)

