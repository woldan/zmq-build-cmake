set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/stage CACHE PATH "Installation prefix.")

option(ENABLE_TESTS        "Enable the tests in the source packages to be added to CTest" ON )
option(ENABLE_IDE_FOLDERS  "Enable folder-style sorting of projects for IDEs"             ON )
option(BUILD_OSX_FRAMEWORK "Enable building frameworks on Mac OS X"                       OFF)


# .. apply top-level options ..
if (APPLE AND BUILD_OSX_FRAMEWORK)
  set(ZMQ_BUILD_FRAMEWORK OFF)
endif (APPLE AND BUILD_OSX_FRAMEWORK)

if (ENABLE_TESTS)
  enable_testing()
endif (ENABLE_TESTS)

if (ENABLE_IDE_FOLDERS)
  set(GLOBAL PROPERTY USE_FOLDERS TRUE)
endif (ENABLE_IDE_FOLDERS)
