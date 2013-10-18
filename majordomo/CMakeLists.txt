cmake_minimum_required(VERSION 2.8)
include(GenerateExportHeader)

project(majordomo)

# .. define some variables ..
set(MAJORDOMO_REPOSITORY    "${CMAKE_CURRENT_SOURCE_DIR}/repo"        CACHE PATH   "Path where the majordomo sources are to be downloaded")
set(MAJORDOMO_URL           "https://github.com/zeromq/majordomo.git" CACHE STRING "The URL the majordomo sources are to be downloaded from")

set(MAJORDOMO_TARGET                "mdp"            CACHE STRING "The target name to use for building the library")
set(MAJORDOMO_BROKER_TARGET         "mdp_broker"     CACHE STRING "The target name to use for building the broker")
set(MAJORDOMO_TEST_CLIENT_TARGET    "test_client"    CACHE STRING "The target name to use for building the test client")
set(MAJORDOMO_TEST_WORKER_TARGET    "test_worker"    CACHE STRING "The target name to use for building the test worker")
set(MAJORDOMO_EXAMPLE_ENGINE_TARGET "example_engine" CACHE STRING "The target name to use for building the example engine")
set(MAJORDOMO_EXAMPLE_TRADER_TARGET "example_trader" CACHE STRING "The target name to use for building the example trader")

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
  ${MAJORDOMO_REPOSITORY}/libmdp/src/*.h
)
file(
  GLOB_RECURSE MAJORDOMO_SOURCES_C_FILES
  ${MAJORDOMO_REPOSITORY}/libmdp/src/mdp_client.c
  ${MAJORDOMO_REPOSITORY}/libmdp/src/mdp_worker.c
)
file(
  GLOB MAJORDOMO_SOURCES_BROKER
  ${MAJORDOMO_REPOSITORY}/libmdp/src/mdp_broker.c
)
file(
  GLOB MAJORDOMO_SOURCES_TEST_CLIENT
  ${MAJORDOMO_REPOSITORY}/libmdp/src/test_client.c
)
file(
  GLOB MAJORDOMO_SOURCES_TEST_WORKER
  ${MAJORDOMO_REPOSITORY}/libmdp/src/test_worker.c
)
file(
  GLOB MAJORDOMO_SOURCES_EXAMPLE_ENGINE
  ${MAJORDOMO_REPOSITORY}/libmdp/src/engine.c
)
file(
  GLOB MAJORDOMO_SOURCES_EXAMPLE_TRADER
  ${MAJORDOMO_REPOSITORY}/libmdp/src/trader.c
)

# .. build generator dependent tweaking of source file handling ..
if (MSVC)
  # .. prevent MS cl to enforce pre-C99 parsing by forcing to C++ ..
  set_source_files_properties(
    ${MAJORDOMO_SOURCES_C_FILES}
    ${MAJORDOMO_SOURCES_BROKER}
    ${MAJORDOMO_SOURCES_TEST_CLIENT}
    ${MAJORDOMO_SOURCES_TEST_WORKER}
    ${MAJORDOMO_SOURCES_EXAMPLE_ENGINE}
    ${MAJORDOMO_SOURCES_EXAMPLE_TRADER}
    PROPERTIES
    LANGUAGE CXX
  )
endif (MSVC)

# .. declare library to be built ..
add_library(
  ${MAJORDOMO_TARGET}
  STATIC
  ${MAJORDOMO_PUBLIC_HEADERS}
  ${MAJORDOMO_SOURCES_HEADERS}
  ${MAJORDOMO_SOURCES_C_FILES}
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

# .. propagate variables ..
set(MAJORDOMO_INCLUDE_DIRS ${MAJORDOMO_REPOSITORY}/libmdp/include  CACHE PATH   "Include paths to use majordomo library.")
set(MAJORDOMO_LIBRARY_DIRS ${CMAKE_CURRENT_BINARY_DIR}             CACHE PATH   "Library paths to use majordomo library.")
set(MAJORDOMO_LIBRARIES    ${MAJORDOMO_TARGET}                     CACHE STRING "Library modules to use majordomo library.")


# .. declare broker executable to be built ..
add_executable(
  ${MAJORDOMO_BROKER_TARGET}
  ${MAJORDOMO_PUBLIC_HEADERS}
  ${MAJORDOMO_SOURCES_BROKER}
)
target_include_directories(
  ${MAJORDOMO_BROKER_TARGET}
  PUBLIC ${LIBZMQ_INCLUDE_DIRS} ${CZMQ_INCLUDE_DIRS} ${MAJORDOMO_REPOSITORY}/libmdp/include
)
target_link_libraries(
  ${MAJORDOMO_BROKER_TARGET}
  ${LIBZMQ_LIBRARIES} ${CZMQ_LIBRARIES} ${MAJORDOMO_LIBRARIES}
)

# .. declare test client executable to be built ..
add_executable(
  ${MAJORDOMO_TEST_CLIENT_TARGET}
  ${MAJORDOMO_PUBLIC_HEADERS}
  ${MAJORDOMO_SOURCES_TEST_CLIENT}
)
target_include_directories(
  ${MAJORDOMO_TEST_CLIENT_TARGET}
  PUBLIC ${LIBZMQ_INCLUDE_DIRS} ${CZMQ_INCLUDE_DIRS} ${MAJORDOMO_REPOSITORY}/libmdp/include
)
target_link_libraries(
  ${MAJORDOMO_TEST_CLIENT_TARGET}
  ${LIBZMQ_LIBRARIES} ${CZMQ_LIBRARIES} ${MAJORDOMO_LIBRARIES}
)

# .. declare test worker executable to be built ..
add_executable(
  ${MAJORDOMO_TEST_WORKER_TARGET}
  ${MAJORDOMO_PUBLIC_HEADERS}
  ${MAJORDOMO_SOURCES_TEST_WORKER}
)
target_include_directories(
  ${MAJORDOMO_TEST_WORKER_TARGET}
  PUBLIC ${LIBZMQ_INCLUDE_DIRS} ${CZMQ_INCLUDE_DIRS} ${MAJORDOMO_REPOSITORY}/libmdp/include
)
target_link_libraries(
  ${MAJORDOMO_TEST_WORKER_TARGET}
  ${LIBZMQ_LIBRARIES} ${CZMQ_LIBRARIES} ${MAJORDOMO_LIBRARIES}
)

# .. declare example engine executable to be built ..
add_executable(
  ${MAJORDOMO_EXAMPLE_ENGINE_TARGET}
  ${MAJORDOMO_PUBLIC_HEADERS}
  ${MAJORDOMO_SOURCES_EXAMPLE_ENGINE}
)
target_include_directories(
  ${MAJORDOMO_EXAMPLE_ENGINE_TARGET}
  PUBLIC ${LIBZMQ_INCLUDE_DIRS} ${CZMQ_INCLUDE_DIRS} ${MAJORDOMO_REPOSITORY}/libmdp/include
)
target_link_libraries(
  ${MAJORDOMO_EXAMPLE_ENGINE_TARGET}
  ${LIBZMQ_LIBRARIES} ${CZMQ_LIBRARIES} ${MAJORDOMO_LIBRARIES}
)

# .. declare example trader executable to be built ..
add_executable(
  ${MAJORDOMO_EXAMPLE_TRADER_TARGET}
  ${MAJORDOMO_PUBLIC_HEADERS}
  ${MAJORDOMO_SOURCES_EXAMPLE_TRADER}
)
target_include_directories(
  ${MAJORDOMO_EXAMPLE_TRADER_TARGET}
  PUBLIC ${LIBZMQ_INCLUDE_DIRS} ${CZMQ_INCLUDE_DIRS} ${MAJORDOMO_REPOSITORY}/libmdp/include
)
target_link_libraries(
  ${MAJORDOMO_EXAMPLE_TRADER_TARGET}
  ${LIBZMQ_LIBRARIES} ${CZMQ_LIBRARIES} ${MAJORDOMO_LIBRARIES}
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


