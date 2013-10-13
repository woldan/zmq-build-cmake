cmake_minimum_required(VERSION 2.8)

project(czmq)

# .. define some variables ..
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
include(header_configuration)

set(CZMQ_REPOSITORY "${CMAKE_CURRENT_SOURCE_DIR}/repo"   CACHE PATH   "Path where the czmq sources are to be downloaded")
set(CZMQ_URL        "https://github.com/zeromq/czmq.git" CACHE STRING "The URL the czmq sources are to be downloaded from")
set(CZMQ_TARGET     "czmq"                               CACHE STRING "The target name to use for building the library")

# .. ensure we have the libzmq sources ..
if (NOT IS_DIRECTORY ${CZMQ_REPOSITORY})
  execute_process(COMMAND git clone ${CZMQ_URL} ${CZMQ_REPOSITORY})
elseif (NOT IS_DIRECTORY ${CZMQ_REPOSITORY})
  execute_process(COMMAND git pull --git-dir ${CZMQ_REPOSITORY} origin master)
endif (NOT IS_DIRECTORY ${CZMQ_REPOSITORY})

# .. build the library ..
file(
  GLOB_RECURSE CZMQ_PUBLIC_HEADERS
  ${CZMQ_REPOSITORY}/include/*.h
)
file(
  GLOB_RECURSE CZMQ_SOURCES
  ${CZMQ_REPOSITORY}/src/*.c
  ${CZMQ_REPOSITORY}/src/*.h
)

include_directories(${LIBZMQ_INCLUDE_DIRS})

configure_platform_header(
  ${CMAKE_CURRENT_LIST_DIR}/platform.h.in
  ${CZMQ_REPOSITORY}/src/platform.h
)

# .. declare library to be built ..
add_library(
  ${CZMQ_TARGET}
  SHARED
  ${CZMQ_PUBLIC_HEADERS}
  ${CZMQ_SOURCES}
)
target_link_libraries(${CZMQ_TARGET} ${LIBZMQ_LIBRARIES})

install(
  TARGETS ${CZMQ_TARGET}
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)
install(
  FILES ${CZMQ_PUBLIC_HEADERS}
  DESTINATION include
)


# .. propagate variables ..
set(CZMQ_INCLUDE_DIRS ${CZMQ_REPOSITORY}/include  PARENT_SCOPE)
set(CZMQ_LIBRARY_DIRS ${CMAKE_CURRENT_BINARY_DIR} PARENT_SCOPE)
set(CZMQ_LIBRARIES    ${CZMQ_TARGET}              PARENT_SCOPE)

