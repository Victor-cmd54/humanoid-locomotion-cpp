cmake_minimum_required(VERSION 3.20)
project(humanoid_locomotion_cpp LANGUAGES CXX)

add_executable(humanoid_locomotion src/main.cpp)
target_compile_features(humanoid_locomotion PRIVATE cxx_std_20)

if(MSVC)
    target_compile_options(humanoid_locomotion PRIVATE /W4 /permissive-)
else()
    target_compile_options(humanoid_locomotion PRIVATE -Wall -Wextra -Wpedantic)
endif()

enable_testing()
add_test(NAME locomotion_command_limits COMMAND humanoid_locomotion)
