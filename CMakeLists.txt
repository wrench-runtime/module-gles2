cmake_minimum_required(VERSION 3.6)
set(wrench_module wren_gles2)
project(module_${wrench_module})

# Add SDL
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
if(WIN32)
  set(CMAKE_PREFIX_PATH ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/angle/win32/x86)
  set(EGL_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/angle/win32/x86/bin/libEGL.dll)
  set(OPENGLES2_LIBRARY ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/angle/win32/x86/bin/libGLESv2.dll)
endif()

find_package(EGL REQUIRED)
find_package(OpenGLES2 REQUIRED)

# On windows copy dll to bin dir
if(WIN32)
  configure_file(${EGL_INCLUDE_DIR}/../bin/libEGL.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../libEGL.dll COPYONLY)
  configure_file(${EGL_INCLUDE_DIR}/../bin/libGLESv2.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../libGLESv2.dll COPYONLY)
endif()

# This is the plugin to be loaded with dlopen
add_library(module_${wrench_module} SHARED ${CMAKE_CURRENT_SOURCE_DIR}/src/${wrench_module}.c)
set_target_properties(module_${wrench_module} PROPERTIES PREFIX "")
set_target_properties(module_${wrench_module} PROPERTIES OUTPUT_NAME "${wrench_module}")
target_link_libraries(module_${wrench_module} PUBLIC wren_runtime EGL::EGL OpenGLES2::OpenGLES2)

# This is the static module to be included in the runtime host
add_library(module_${wrench_module}_static STATIC ${CMAKE_CURRENT_SOURCE_DIR}/src/${wrench_module}.c)
target_link_libraries(module_${wrench_module}_static PUBLIC wren_runtime EGL::EGL OpenGLES2::OpenGLES2)

# Copy script file to binary folder
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/wren/${wrench_module}.wren ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${wrench_module}.wren COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/wren/${wrench_module}_app.wren ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${wrench_module}_app.wren COPYONLY)

