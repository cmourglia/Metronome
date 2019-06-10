cmake_minimum_required(VERSION 3.12)
project(Metronome)

set(CMAKE_CXX_STANDARD 17)

if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
   message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
   file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/v0.14/conan.cmake"
                 "${CMAKE_BINARY_DIR}/conan.cmake")
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

conan_cmake_run(REQUIRES sfml/2.5.1@bincrafters/stable
                BASIC_SETUP CMAKE_TARGETS
                BUILD missing
                OPTIONS sfml:audio=True)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5 COMPONENTS Core Gui Qml Quick Multimedia QuickControls2 REQUIRED)

add_executable(metronome src/main.cpp src/timer.cpp)
target_link_libraries(metronome PUBLIC Qt5::Core Qt5::Gui Qt5::Qml Qt5::Quick Qt5::Multimedia Qt5::QuickControls2)
target_link_libraries(metronome PUBLIC CONAN_PKG::sfml)
