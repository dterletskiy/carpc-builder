# include( ./build/message.cmake )



###########################################################################################
#                                                                                         #
#                                 Print functions for debug                               #
#                                                                                         #
###########################################################################################
# Print variable by its name.
# Parameters:
#     IN_VARIABLE - (in) variable name
# Example:
#     set( FOO "EXTERNAL" )
#     print_variable( FOO )
function( print_variable IN_VARIABLE )
   msg_vrb( "${IN_VARIABLE} = ${${IN_VARIABLE}}" )
endfunction( )

function( print_environment_variables )
   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                       '${PROJECT_NAME}' ENVIRONMENT VARIABLES (BEGIN):                    " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )

   execute_process( COMMAND "${CMAKE_COMMAND}" "-E" "environment" )

   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                        '${PROJECT_NAME}' ENVIRONMENT VARIABLES (END):                     " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )
endfunction( )

function( print_cmake_variables )
   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                           '${PROJECT_NAME}' CMAKE VARIABLES (BEGIN):                      " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )

   get_cmake_property( _variableNames VARIABLES )
   list( SORT _variableNames )
   foreach (_variableName ${_variableNames})
      msg_vrb( "${_variableName}=${${_variableName}}" )
   endforeach( )

   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                            '${PROJECT_NAME}' CMAKE VARIABLES (END):                       " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )
endfunction( )

function( print_variables )
   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                              '${PROJECT_NAME}' variables (BEGIN):                         " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )

   # [cmake] Name of the project given to the project command.
   print_variable( PROJECT_NAME )

   # [cmake] Path to top of source tree. Same as CMAKE_SOURCE_DIR.
   print_variable( CMAKE_HOME_DIRECTORY )

   # [cmake] The path to the top level of the source tree.
   print_variable( CMAKE_SOURCE_DIR )
   # [cmake] The path to the source directory currently being processed.
   print_variable( CMAKE_CURRENT_SOURCE_DIR )
   # [cmake] Top level source directory for the named project.
   print_variable( ${PROJECT_NAME}_SOURCE_DIR )
   # [cmake] This is the source directory for project.
   print_variable( PROJECT_SOURCE_DIR )

   # [cmake] The path to the top level of the build tree.
   print_variable( CMAKE_BINARY_DIR )
   # [cmake] The path to the binary directory currently being processed.
   print_variable( CMAKE_CURRENT_BINARY_DIR )
   # [cmake] Top level binary directory for the named project.
   print_variable( ${PROJECT_NAME}_BINARY_DIR )
   # [cmake] Full path to build directory for project.
   print_variable( PROJECT_BINARY_DIR )

   # [cmake] Install directory used by install().
   print_variable( CMAKE_INSTALL_PREFIX )

   # [fenix] Full path to generate files directory for project.
   print_variable( PROJECT_GEN_DIR )
   # [fenix] Top level generate directory for the named project.
   print_variable( FENIX_CURRENT_GEN_DIR )
   # [fenix] Top level generate directory for the named project.
   print_variable( ${PROJECT_NAME}_GEN_DIR )

   # [fenix]
   print_variable( ROOT_SOURCE_DIR )
   # [fenix]
   print_variable( ROOT_BINARY_DIR )
   # [fenix]
   print_variable( ROOT_DEPLOY_DIR )
   # [fenix]
   print_variable( ROOT_GEN_DIR )
   # [fenix]
   print_variable( CARPC_INCLUDE_DIR )
   # [fenix]
   print_variable( CARPC_LIB_DIR )

   # [fenix] Name of the target given to the project command.
   print_variable( PROJECT_TARGET_NAME )

   # [fenix] List of source files in the project.
   # It is generated during calling function "find_files_by_ext".
   print_variable( PROJECT_SOURCE_FILES )
   print_variable( PROJECT_GEN_FILES )
   print_variable( PROJECT_GEN_ADL_FILES )
   print_variable( PROJECT_GEN_IDL_FILES )
   print_variable( PROJECT_GEN_PROTO_FILES )

   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                               '${PROJECT_NAME}' variables (END):                          " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )
endfunction( )

function( print_configuration )
   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                             '${PROJECT_NAME}' configuration (BEGIN):                      " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )

   msg_dbg( "SYS_TRACE        = " ${SYS_TRACE} )
   msg_dbg( "MSG_TRACE        = " ${MSG_TRACE} )
   msg_dbg( "COLORED_TRACE    = " ${COLORED_TRACE} )
   msg_dbg( "DLT_TRACE        = " ${DLT_TRACE} )
   msg_dbg( "MEMORY_HOOK      = " ${MEMORY_HOOK} )
   msg_dbg( "INSTRUMENTAL     = " ${INSTRUMENTAL} )
   msg_dbg( "USE_DEBUG        = " ${USE_DEBUG} )
   msg_dbg( "USE_GPB          = " ${USE_GPB} )
   msg_dbg( "USE_RTTI         = " ${USE_RTTI} )

   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                              '${PROJECT_NAME}' configuration (END):                       " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )
endfunction( )

function( print_toolchain_config )
   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                            '${PROJECT_NAME}' toolchain config (BEGIN):                    " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )

   msg_vrb( "TOOLCHAIN = $ENV{TOOLCHAIN}" )
   msg_vrb( "SYSROOT = $ENV{SYSROOT}" )
   msg_vrb( "ARCH = $ENV{ARCH}" )
   msg_vrb( "OS = $ENV{OS}" )
   msg_vrb( "API = $ENV{API}" )
   msg_vrb( "TARGET = $ENV{TARGET}" )
   msg_vrb( "SESSION = $ENV{SESSION}" )
   msg_vrb( "AR = $ENV{AR}" )
   msg_vrb( "AS = $ENV{AS}" )
   msg_vrb( "CC = $ENV{CC}" )
   msg_vrb( "CXX = $ENV{CXX}" )
   msg_vrb( "LD = $ENV{LD}" )
   msg_vrb( "RANLIB = $ENV{RANLIB}" )
   msg_vrb( "STRIP = $ENV{STRIP}" )

   msg_dbg( "###########################################################################################" )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "                             '${PROJECT_NAME}' toolchain config (END):                     " )
   msg_dbg( "#                                                                                         #" )
   msg_dbg( "###########################################################################################" )
endfunction( )
