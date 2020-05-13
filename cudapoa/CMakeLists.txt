#
# Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.
#

project(cudapoa)

# Process data subdirectory first
add_subdirectory(data)

# Project specific NVCC flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -std=c++11")
message(STATUS "nvcc flags for cudapoa: ${CUDA_NVCC_FLAGS}")

get_property(cga_library_type GLOBAL PROPERTY cga_library_type)
cuda_add_library(cudapoa ${cga_library_type}
    src/cudapoa.cpp
    src/cudapoa_kernels.cu
    src/batch.cpp
    )

target_link_libraries(cudapoa cgabase)

target_compile_options(cudapoa PRIVATE -Werror -Wall -Wextra)
if (cga_optimize_for_native_cpu)
    target_compile_options(cudapoa PRIVATE -march=native)
endif()

if(cga_enable_cudapoa_nw_print)
    target_compile_definitions(cudapoa PUBLIC NW_VERBOSE_PRINT)
endif()

if(spoa_accurate)
    target_compile_definitions(cudapoa PUBLIC SPOA_ACCURATE)
endif()

target_include_directories(cudapoa
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)

add_doxygen_source_dir(${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS cudapoa
    COMPONENT cgalogging
    EXPORT cudapoa
    DESTINATION lib
    INCLUDES DESTINATION include
)
install(DIRECTORY include/ DESTINATION include)
install(EXPORT cudapoa DESTINATION cmake)

# Add other folders.
add_subdirectory(tests)
add_subdirectory(benchmarks)
add_subdirectory(samples)


# Add auto formatting.
cga_enable_auto_formatting("${CMAKE_CURRENT_SOURCE_DIR}")

FIND_PACKAGE(SWIG REQUIRED)
INCLUDE(${SWIG_USE_FILE})

FIND_PACKAGE(PythonLibs)
INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/src  
                    ${CMAKE_CURRENT_SOURCE_DIR}/include
                    ${CMAKE_CURRENT_SOURCE_DIR}/../common/base/include)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y -fPIC")

SET_PROPERTY(SOURCE binding/cudapoa.i PROPERTY CPLUSPLUS ON)
        
SWIG_ADD_LIBRARY(pycudapoa LANGUAGE python SOURCES binding/cudapoa.i)
SWIG_LINK_LIBRARIES(pycudapoa cudapoa cgabase spdlog ${PYTHON_LIBRARIES})

#find_package(Java REQUIRED)
#find_package(JNI REQUIRED)
#include_directories(${JNI_INCLUDE_DIRS})

#SWIG_ADD_LIBRARY(jcudapoa LANGUAGE java SOURCES binding/cudapoa.i)
#SWIG_LINK_LIBRARIES(jcudapoa ${PYTHON_LIBRARIES} spdlog cgabase)