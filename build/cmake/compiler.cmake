###########################################################################################
#                                                                                         #
#                                   Compile definitions                                   #
#                                                                                         #
###########################################################################################
set( CMAKE_CXX_STANDARD 20 )
set( CMAKE_CXX_STANDARD_REQUIRED True )

# https://stackoverflow.com/questions/10046114/in-cmake-how-can-i-test-if-the-compiler-is-clang
if( CMAKE_CXX_COMPILER_ID STREQUAL "Clang" )
   message( NOTICE "compiler: Clang" )
   add_definitions( -Wall )
   add_definitions( -Wextra )
   add_definitions( -Wno-ignored-qualifiers )
   add_definitions( -Wno-unused-const-variable )
   add_definitions( -Wno-unused-variable )
   add_definitions( -Wno-unused-parameter )
   add_definitions( -Wno-unused-function )
   add_definitions( -Wno-unused-result )
   add_definitions( -Wno-unused-private-field )
   add_definitions( -Wno-overloaded-virtual )
elseif( CMAKE_CXX_COMPILER_ID STREQUAL "GNU" )
   message( NOTICE "compiler: GCC" )
   add_definitions( -Wall )
   add_definitions( -Wextra )
   add_definitions( -Wno-ignored-qualifiers )
   add_definitions( -Wno-unused-but-set-variable )
   add_definitions( -Wno-unused-variable )
   add_definitions( -Wno-unused-parameter )
   add_definitions( -Wno-unused-function )
   add_definitions( -Wno-unused-result )
   add_definitions( -Wno-comment )
elseif( CMAKE_CXX_COMPILER_ID STREQUAL "Intel" )
   msg_vrb( "compiler: Intel C++" )
elseif( CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" )
   msg_vrb( "compiler: Visual Studio C++" )
endif( )

if( CMAKE_SYSTEM_NAME STREQUAL "Linux" )
   add_compile_definitions( CARPC_BUILD_OS_LINUX )
elseif( CMAKE_SYSTEM_NAME STREQUAL "QNX" )
   add_compile_definitions( CARPC_BUILD_OS_QNX )
elseif( CMAKE_SYSTEM_NAME STREQUAL "Generic" )
   add_compile_definitions( CARPC_BUILD_OS_RTOS )
endif( )



if( CARPC_BUILD_DEBUG )
   add_definitions( -O0 )
   add_definitions( -g )
   add_compile_definitions( CARPC_BUILD_DEBUG )
else( )
   add_definitions( -Ofast )
endif( )

if( CARPC_BUILD_RTTI_ENABLED )
   add_definitions( -frtti )
   add_compile_definitions( CARPC_BUILD_RTTI_ENABLED )
else( )
   add_definitions( -fno-rtti )
endif( )

if( CARPC_BUILD_TRACE_ENABLED )
   add_compile_definitions( CARPC_BUILD_TRACE_ENABLED )
endif( )

if( CARPC_BUILD_POLICY_STD )
   add_compile_definitions( CARPC_BUILD_POLICY_STD )
endif( )
