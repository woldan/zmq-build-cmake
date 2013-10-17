cmake_minimum_required(VERSION 2.8)
include(GenerateExportHeader)

project(majordomo)

# .. define some variables ..
set(MAJORDOMO_REPOSITORY "${CMAKE_CURRENT_SOURCE_DIR}/repo"        CACHE PATH   "Path where the majordomo sources are to be downloaded")
set(MAJORDOMO_URL        "https://github.com/zeromq/majordomo.git" CACHE STRING "The URL the majordomo sources are to be downloaded from")
set(MAJORDOMO_TARGET     "mdp"                                     CACHE STRING "The target name to use for building the library")

# .. ensure we have the majordomo sources ..
if (NOT IS_DIRECTORY ${MAJORDOMO_REPOSITORY})
  execute_process(COMMAND git clone ${MAJORDOMO_URL} ${MAJORDOMO_REPOSITORY})
elseif (NOT IS_DIRECTORY ${MAJORDOMO_REPOSITORY})
  execute_process(COMMAND git pull --git-dir ${MAJORDOMO_REPOSITORY} origin master)
endif (NOT IS_DIRECTORY ${MAJORDOMO_REPOSITORY})

add_compiler_export_flags()

# .. build the library ..
file(
  GLOB_RECURSE MAJORDOMO_PUBLIC_HEADERS
  ${MAJORDOMO_REPOSITORY}/libmdp/include/*.h
)
file(
  GLOB_RECURSE MAJORDOMO_SOURCES_HEADERS
  ${MAJORDOMO_REPOSITORY}/libmdp/src/mdp_*.h
)
file(
  GLOB_RECURSE MAJORDOMO_SOURCES_C_FILES
  ${MAJORDOMO_REPOSITORY}/libmdp/src/mdp_*.c
)
if (MSVC)
  # .. prevent MS cl to enforce pre-C99 parsing by forcing to C++ ..
  set_source_files_properties(
    ${MAJORDOMO_SOURCES_C_FILES}
    PROPERTIES
    LANGUAGE CXX
  )
endif (MSVC)

# .. declare library to be built ..
add_library(
  ${MAJORDOMO_TARGET}
  STATIC
  ${MAJORDOMO_PUBLIC_HEADERS}
  ${MAJORDOMO_SOURCES}
)
generate_export_header(${MAJORDOMO_TARGET})
target_include_directories(
  ${MAJORDOMO_TARGET}
  PUBLIC ${LIBZMQ_INCLUDE_DIRS} ${CZMQ_INCLUDE_DIRS} ${MAJORDOMO_REPOSITORY}/libmdp/include
  INTERFACE ${LIBZMQ_INCLUDE_DIRS} ${CZMQ_INCLUDE_DIRS} ${MAJORDOMO_REPOSITORY}/libmdp/include
)
target_link_libraries(
  ${MAJORDOMO_TARGET}
  ${LIBZMQ_LIBRARIES}
  ${CZMQ_LIBRARIES}
)

install(
  TARGETS ${MAJORDOMO_TARGET}
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)
install(
  FILES ${MAJORDOMO_PUBLIC_HEADERS}  ${PROJECT_BINARY_DIR}/${MAJORDOMO_TARGET}_export.h
  DESTINATION include
)


# .. propagate variables ..
set(MAJORDOMO_INCLUDE_DIRS ${MAJORDOMO_REPOSITORY}/libmdp/include PARENT_SCOPE)
set(MAJORDOMO_LIBRARY_DIRS ${CMAKE_CURRENT_BINARY_DIR}            PARENT_SCOPE)
set(MAJORDOMO_LIBRARIES    ${MAJORDOMO_TARGET}                    PARENT_SCOPE)

