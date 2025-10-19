cmake_minimum_required(VERSION 3.13)
project(libnode_test)
set(CMAKE_CXX_STANDARD 17)

file(GLOB LIBNODE_ARCHIVES ${CMAKE_CURRENT_LIST_DIR}/../../lib/*)
set(LIBNODE_INCLUDE ${CMAKE_CURRENT_LIST_DIR}/../../include ${CMAKE_CURRENT_LIST_DIR})

add_library(libnode INTERFACE)

if(UNIX AND NOT APPLE)
  target_link_libraries(libnode INTERFACE
    "-Wl,--start-group" ${LIBNODE_ARCHIVES} "-Wl,--end-group"
    pthread dl rt m "-rdynamic"
  )
elseif(WIN32)
  target_link_libraries(libnode INTERFACE
    ${LIBNODE_ARCHIVES} ws2_32 dbghelp crypt32 winmm iphlpapi psapi userenv
  )
  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    target_link_options(libnode INTERFACE "/SAFESEH:NO")
  endif()
else() # APPLE
  target_link_libraries(libnode INTERFACE ${LIBNODE_ARCHIVES})
endif()

target_include_directories(libnode INTERFACE ${LIBNODE_INCLUDE})

# --------------------------------------------

add_executable(simple
  simple.cc
  node_embedding_api.cc
)
target_link_libraries(simple PRIVATE libnode)

add_executable(process_argv
  process_argv.cc
  node_embedding_api.cc
)
target_link_libraries(process_argv PRIVATE libnode)

if(WIN32)
  target_compile_options(simple PRIVATE "/MT")
  target_compile_options(process_argv PRIVATE "/MT")
endif()
