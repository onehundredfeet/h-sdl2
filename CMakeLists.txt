cmake_minimum_required(VERSION 3.10)
project (sdl2 C CXX )

if(APPLE)
    enable_language(OBJC)
    enable_language(OBJCXX)
endif()

if (NOT SDL2_ROOT) 
set(SDL2_ROOT "../sdl2")
endif()

if (NOT SDL2_SRC_DIR) 
set(SDL2_SRC_DIR "${SDL2_ROOT}/source")
endif()
if (NOT SDL2_INC_DIR) 
set(SDL2_INC_DIR "${SDL2_ROOT}/include")
endif()

set(FP16_INC_DIR "ext/FP16/include")

if (NOT HL_INCLUDE_DIR) 
    set(HL_INCLUDE_DIR "/usr/local/include")
endif()

if (NOT XXHASH_ROOT_DIR) 
    set(XXHASH_ROOT_DIR "ext/xxHash")
endif()

if (NOT HL_LIB_DIR) 
    set(HL_LIB_DIR "/usr/local/lib")
endif()

if (NOT COMMON_LIB_DIR) 
    set(COMMON_LIB_DIR "/usr/local/lib")
endif()

if (NOT HDLL_DESTINATION) 
    set(HDLL_DESTINATION "/usr/local/lib")
endif()

if (NOT SDL2_LIB_DIR)
    set(SDL2_LIB_DIR "ext/sdl2")
    set(SDL2_LIB_INC "${SDL2_LIB_DIR}/Common_3")
    set(SDL2_LIB_SRC "${SDL2_LIB_DIR}/Common_3")
    set(SDL2_OS_SRC "${SDL2_LIB_DIR}/Common_3/OS")
    set(SDL2_TP_SRC "${SDL2_LIB_DIR}/Common_3/ThirdParty/OpenSource")
    set(SDL2_MW_SRC "${SDL2_LIB_DIR}/Middleware_3")
    set(SDL2_RDR_SRC "${SDL2_LIB_DIR}/Common_3/Renderer")
    set(SDL2_EASTL_DIR "${SDL2_TP_SRC}/EASTL")
    set(SDL2_TP_INC ${SDL2_TP_SRC} )
endif()


set( SDL2_OS_SRCS 
    ${SDL2_OS_SRC}/Logging/Log.c
    ${SDL2_OS_SRC}/Darwin/DarwinThread.c
    ${SDL2_OS_SRC}/Darwin/DarwinLog.c
    ${SDL2_OS_SRC}/Darwin/CocoaFileSystem.mm
    ${SDL2_OS_SRC}/FileSystem/FileSystem.cpp
    ${SDL2_OS_SRC}/FileSystem/UnixFileSystem.cpp
    ${SDL2_OS_SRC}/FileSystem/SystemRun.cpp
    ${SDL2_OS_SRC}/MemoryTracking/MemoryTracking.c
    ${SDL2_OS_SRC}/Core/Screenshot.cpp
)

set ( SDL2_MW_SRCS
    ${SDL2_MW_SRC}/ParallelPrimitives/ParallelPrimitives.cpp
)

set (SDL2_TP_SRCS
    ${SDL2_TP_SRC}/basis_universal/transcoder/basisu_transcoder.cpp
    ${SDL2_TP_SRC}/meshoptimizer/src/vcacheoptimizer.cpp
    ${SDL2_TP_SRC}/meshoptimizer/src/vfetchoptimizer.cpp
    ${SDL2_TP_SRC}/meshoptimizer/src/indexgenerator.cpp
    ${SDL2_TP_SRC}/meshoptimizer/src/overdrawoptimizer.cpp
    ${SDL2_TP_SRC}/meshoptimizer/src/allocator.cpp
#    ${SDL2_TP_SRC}/FluidStudios/MemoryManager/mmgr.c
)

set (SDL2_RENDERER_SRCS
    ${SDL2_RDR_SRC}/Renderer.cpp
    ${SDL2_RDR_SRC}/Metal/MetalRenderer.mm
    ${SDL2_RDR_SRC}/Metal/MetalRaytracing.mm
    ${SDL2_RDR_SRC}/Metal/MetalShaderReflection.mm
    ${SDL2_RDR_SRC}/ResourceLoader.cpp
    ${SDL2_RDR_SRC}/CommonShaderReflection.cpp
    
)

set(SDL2_EASTL_SRCS
    ${SDL2_EASTL_DIR}/eastl.cpp
   # ${SDL2_EASTL_DIR}/EAStdC/EASprintf.cpp
  #  ${SDL2_EASTL_DIR}/EAStdC/EAMemory.cpp
 #   ${SDL2_EASTL_DIR}/allocator_sdl2.cpp
#    ${SDL2_EASTL_DIR}/allocator_eastl.cpp
)

add_library(sdl2.hdll SHARED
src/sdl2.cpp
src/hl-sdl2.cpp
src/hl-sdl2-shaders.cpp
src/hl-sdl2-metal.mm
${SDL2_OS_SRCS}
${SDL2_TP_SRCS}
${SDL2_RENDERER_SRCS}
${SDL2_MW_SRCS}
${SDL2_EASTL_SRCS}
${XXHASH_ROOT_DIR}/xxhash.c
)

set_source_files_properties(${SDL2_RENDERER_SRCS} ${SDL2_MW_SRCS} ${SDL2_OS_SRCS} src/sdl2.cpp src/hl-sdl2.cpp PROPERTIES COMPILE_FLAGS "-x objective-c++ -std=c++17")


set_target_properties(sdl2.hdll
PROPERTIES
PREFIX ""
OUTPUT_NAME sdl2
SUFFIX .hdll
)

set_property(TARGET sdl2.hdll PROPERTY CXX_STANDARD 17)

cmake_policy(SET CMP0015 NEW)

target_include_directories(sdl2.hdll
PRIVATE
${SDL2_INC_DIR}
${SDL2_LIB_INC}
${HL_INCLUDE_DIR}
${SDL2_TP_INC}
${FP16_INC_DIR}
"${XXHASH_ROOT_DIR}"
)

find_library( METAL_LIB Metal)
find_library( METALKIT_LIB MetalKit)
find_library( QUARTZ_LIB QuartzCore)
find_library( FOUNDATION_LIB Foundation)
find_library( IOKIT_LIB IOKit)
find_library( METAL_PERF_SHADER_LIB MetalPerformanceShaders)
find_library( SHADERC_LIB shaderc_combined)
find_library( SDL_LIB SDL2)
find_library( APPKITLIB AppKit)
find_library( COREGRAPHICSLIB CoreGraphics)
find_library( SPIRVCROSS_CORELIB spirv-cross-core)
find_library( SPIRVCROSS_METALLIB spirv-cross-msl)
find_library( SPIRVCROSS_GLSLLIB spirv-cross-glsl)

if (UNIX)
    # Some special flags are needed for GNU GCC compiler
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -fPIC -fpermissive")
    #not sure why the ${HL_LIB_DIR} is necessary given the above.
    SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -shared  ")

    find_library(LIBHL NAMES hl HINTS ${HL_LIB_DIR} )
else()
    find_library(LIBHL NAMES libhl HINTS ${HL_LIB_DIR} )
endif (UNIX)

set_property (TARGET sdl2.hdll APPEND_STRING PROPERTY COMPILE_FLAGS " -mpclmul -fobjc-arc")
 
target_link_libraries(sdl2.hdll ${LIBHL} ${METAL_LIB} ${QUARTZ_LIB} ${FOUNDATION_LIB} ${IOKIT_LIB} ${METAL_PERF_SHADER_LIB} ${SHADERC_LIB} ${SDL_LIB} ${APPKITLIB} ${COREGRAPHICSLIB} ${METALKIT_LIB} ${SPIRVCROSS_CORELIB} ${SPIRVCROSS_METALLIB} ${SPIRVCROSS_GLSLLIB})

install(TARGETS sdl2.hdll )
