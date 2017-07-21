CMAKE_MINIMUM_REQUIRED(VERSION 2.6.0)
PROJECT(polyclipping)

SET(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/../bin)

# The header name clipper.hpp is too generic, so install in a subdirectory
# SET(CMAKE_INSTALL_INCDIR "${CMAKE_INSTALL_PREFIX}/include/polyclipping")
# SET(CMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}")
# SET(CMAKE_INSTALL_PKGCONFIGDIR "${CMAKE_INSTALL_PREFIX}/share/pkgconfig")
# SET(PCFILE "${CMAKE_CURRENT_BINARY_DIR}/polyclipping.pc")

if (BUILD_LINUX)

elseif (BUILD_OSX)

elseif (BUILD_WIN32)
  SET(CMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_PREFIX}/win")
endif ()

SET(BUILD_SHARED_LIBS ON CACHE BOOL
    "Build shared libraries (.dll/.so) instead of static ones (.lib/.a)")
ADD_LIBRARY(polyclipping clipper.cpp clipper_wrap.cpp)

CONFIGURE_FILE (polyclipping.pc.cmakein "${PCFILE}" @ONLY)

# INSTALL (FILES clipper.hpp DESTINATION "${CMAKE_INSTALL_INCDIR}")
# CMake treats shared libraries as runtime objects on Windows platforms
INSTALL (TARGETS polyclipping 
  RUNTIME DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}")
# INSTALL (FILES "${PCFILE}" DESTINATION "${CMAKE_INSTALL_PKGCONFIGDIR}")

SET_TARGET_PROPERTIES(polyclipping PROPERTIES VERSION 22.0.0 SOVERSION 22 )
