cmake_minimum_required(VERSION 2.8)

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/stage)

project(zmq)

add_subdirectory(libzmq)
add_subdirectory(czmq)

