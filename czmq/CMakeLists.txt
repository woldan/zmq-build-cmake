cmake_minimum_required(VERSION 2.8)

project(czmq CXX)

# .. define some variables ..
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
include(header_configuration)
include(GenerateExportHeader)

set(CZMQ_REPOSITORY          "${CMAKE_CURRENT_SOURCE_DIR}/repo"   CACHE PATH   "Path where the czmq sources are to be downloaded")
set(CZMQ_URL                 "https://github.com/zeromq/czmq.git" CACHE STRING "The URL the czmq sources are to be downloaded from")
set(CZMQ_TARGET              "czmq"                               CACHE STRING "The target name to use for building the library")
set(CZMQ_SELFTEST_TARGET     "czmqtests"                          CACHE STRING "The target name to use for building the self tesu")

# .. ensure we have the libzmq sources ..
if (NOT IS_DIRECTORY ${CZMQ_REPOSITORY})
  execute_process(COMMAND git clone ${CZMQ_URL} ${CZMQ_REPOSITORY})
elseif (NOT IS_DIRECTORY ${CZMQ_REPOSITORY})
  execute_process(COMMAND git pull --git-dir ${CZMQ_REPOSITORY} origin master)
endif (NOT IS_DIRECTORY ${CZMQ_REPOSITORY})

add_compiler_export_flags()

# .. collect source files ..
file(
  GLOB_RECURSE CZMQ_PUBLIC_HEADERS
  ${CZMQ_REPOSITORY}/include/*.h
)
file(
  GLOB_RECURSE CZMQ_SOURCES_HEADERS
  ${CZMQ_REPOSITORY}/src/*.h
)
file(
  GLOB_RECURSE CZMQ_SOURCES_C_FILES
  ${CZMQ_REPOSITORY}/src/*.c
)
if (MSVC)
  # .. prevent MS cl to enforce pre-C99 parsing by forcing to C++ ..
  set_source_files_properties(
    ${CZMQ_SOURCES_C_FILES}
    PROPERTIES
    LANGUAGE CXX
  )
endif (MSVC)
file(
  GLOB CZMQ_SELFTEST_SOURCES
  ${CZMQ_REPOSITORY}/src/czmq_selftest.c
)
list(REMOVE_ITEM CZMQ_SOURCES_C_FILES ${CZMQ_SELFTEST_SOURCES})

# .. build the library ..
configure_platform_header(
  ${CMAKE_CURRENT_LIST_DIR}/platform.h.in
  ${CZMQ_REPOSITORY}/src/platform.h
)

# .. declare library to be built ..
add_library(
  ${CZMQ_TARGET}
  STATIC
  ${CZMQ_PUBLIC_HEADERS}
  ${CZMQ_SOURCES_HEADERS}
  ${CZMQ_SOURCES_C_FILES}
)
generate_export_header(${CZMQ_TARGET})
target_include_directories(
  ${CZMQ_TARGET}
  PUBLIC ${LIBZMQ_INCLUDE_DIRS}
  INTERFACE ${LIBZMQ_INCLUDE_DIRS}
)
target_link_libraries(${CZMQ_TARGET} ${LIBZMQ_LIBRARIES})

# .. declare tests to be built ..
add_executable(
  ${CZMQ_SELFTEST_TARGET}
  ${CZMQ_SELFTEST_SOURCES}
)
target_link_libraries(${CZMQ_SELFTEST_TARGET} ${LIBZMQ_LIBRARIES} ${CZMQ_TARGET})

install(
  TARGETS ${CZMQ_TARGET}
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)
install(
  FILES ${CZMQ_PUBLIC_HEADERS} ${PROJECT_BINARY_DIR}/${CZMQ_TARGET}_export.h
  DESTINATION include
)


# .. propagate variables ..
set(CZMQ_INCLUDE_DIRS ${CZMQ_REPOSITORY}/include  CACHE PATH   "Include paths to use cmzq library.")
set(CZMQ_LIBRARY_DIRS ${CMAKE_CURRENT_BINARY_DIR} CACHE PATH   "Library paths to use cmzq library.")
set(CZMQ_LIBRARIES    ${CZMQ_TARGET}              CACHE STRING "Library modules to use cmzq library.")
