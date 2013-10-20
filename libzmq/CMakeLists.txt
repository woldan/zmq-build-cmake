cmake_minimum_required(VERSION 2.8)

project(libzmq)

# .. define some variables ..
set(LIBZMQ_REPOSITORY "${CMAKE_CURRENT_SOURCE_DIR}/repo"     CACHE PATH   "Path where the libzmq sources are to be downloaded")
set(LIBZMQ_URL        "https://github.com/zeromq/libzmq.git" CACHE STRING "The URL the libzmq sources are to be downloaded from")

# .. ensure we have the libzmq sources ..
if (NOT IS_DIRECTORY ${LIBZMQ_REPOSITORY})
  execute_process(COMMAND git clone ${LIBZMQ_URL} ${LIBZMQ_REPOSITORY})
elseif (NOT IS_DIRECTORY ${LIBZMQ_REPOSITORY})
  execute_process(COMMAND git pull --git-dir ${LIBZMQ_REPOSITORY} origin master)
endif (NOT IS_DIRECTORY ${LIBZMQ_REPOSITORY})

file(
  GLOB_RECURSE LIBZMQ_PUBLIC_HEADERS
  ${LIBZMQ_REPOSITORY}/include/*.h
)

# .. recurse into working copy as it provides its own CMakeLists.txt ..
add_subdirectory(${LIBZMQ_REPOSITORY})

set_property(TARGET ${ZEROMQ_LIBRARY} PROPERTY FOLDER libzmq)

# .. export variables for other projects ..
set(LIBZMQ_INCLUDE_DIRS "${LIBZMQ_REPOSITORY}/include"     CACHE PATH   "Include paths to use libzmq library.")
set(LIBZMQ_LIBRARY_DIRS "${CMAKE_CURRENT_BINARY_DIR}/repo" CACHE PATH   "Library paths to use libzmq library.")
set(LIBZMQ_LIBRARIES    ${ZEROMQ_LIBRARY}                  CACHE STRING "Library modules to use libzmq library.")
