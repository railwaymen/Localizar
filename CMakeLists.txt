cmake_minimum_required(VERSION 3.7)
project(Localizar)

file(GLOB_RECURSE swiftFiles *.swift)

add_custom_target(Localizar
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES ${swiftFiles})
