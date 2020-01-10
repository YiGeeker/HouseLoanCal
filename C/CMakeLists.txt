cmake_minimum_required(VERSION 3.9)
project(HouseLoanCal C)
set(SRC_LIST HouseLoanCal.c)

if(CMAKE_EXPORT_COMPILE_COMMANDS)
  include_directories(SYSTEM C:/GNU/mingw64/x86_64-w64-mingw32/include)
endif()

add_executable(${PROJECT_NAME} ${SRC_LIST})

if(MSVC)
  add_definitions(/source-charset:utf-8 /execution-charset:gbk)
elseif(MINGW)
  add_definitions(-fexec-charset=GBK)
endif()

install(TARGETS ${PROJECT_NAME}
  DESTINATION ${PROJECT_SOURCE_DIR})
