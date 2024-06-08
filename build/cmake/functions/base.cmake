set( FENIX_POSITIVE_VALUES "true" "TRUE" "yes" "YES" "on" "ON" )
set( FENIX_POSITIVE_VALUE "ON" )
set( FENIX_NEGATIVE_VALUES "false" "FALSE" "no" "NO" "off" "OFF" )
set( FENIX_NEGATIVE_VALUE "OFF" )



# Test string the variable for positive or negative boolean value.
# In this way, the call parameters can be checked.
# Parameters:
#     OUT_RESULT - (out) test result ON/OFF
#     IN_VALUE - (in) variable to test
#     IN_DEFAULT_VALUE - (in optional) default result in case if IN_VALUE is not defined
# Example:
#     set( VARIABLE "yes" )
#     fenix_is_on_off( RESULT VARIABLE )
#     msg_err( "RESULT = " ${RESULT} )
# Example:
#     fenix_is_on_off( RESULT VARIABLE ON )
#     msg_err( "RESULT = " ${RESULT} )
function( fenix_is_on_off OUT_RESULT IN_VALUE )
   if( ${ARGC} GREATER 2 )
      set( IN_DEFAULT_VALUE ${ARGV2} )
   else( )
      set( IN_DEFAULT_VALUE ${FENIX_NEGATIVE_VALUE} )
   endif( )

   if( NOT DEFINED ${IN_VALUE} )
      set( ${OUT_RESULT} ${IN_DEFAULT_VALUE} PARENT_SCOPE )
   else( )
      set( ${OUT_RESULT} ${FENIX_NEGATIVE_VALUE} PARENT_SCOPE )

      foreach( POSITIVE_ITEM IN LISTS FENIX_POSITIVE_VALUES )
         if( ${POSITIVE_ITEM} STREQUAL ${IN_VALUE} )
            set( ${OUT_RESULT} ${FENIX_POSITIVE_VALUE} PARENT_SCOPE )
            break( )
         endif( )
      endforeach( )
   endif( )
endfunction( )



# Function for searching all targets defined in all current directory and all
# subdirectories.
# link: https://stackoverflow.com/a/62311397
# Parameters:
#     OUT_TARGETS - (out) list of targets
# Example:
# fenix_get_all_targets( TARGETS )
# msg_dbg( "List of all targets" )
# foreach( TARGET IN LISTS TARGETS )
#    msg_dbg( " - '${TARGET}'" )
# endforeach( )
function( fenix_get_all_targets OUT_TARGETS )
   set( LOCAL_TARGETS )
   __fenix_all_targets_recursive__( LOCAL_TARGETS ${CMAKE_CURRENT_SOURCE_DIR} )
   set( ${OUT_TARGETS} ${LOCAL_TARGETS} PARENT_SCOPE )

   msg_dbg( "List of targets:" )
   foreach( LOCAL_TARGET IN LISTS LOCAL_TARGETS )
      msg_inf( "   - " ${LOCAL_TARGET} )
   endforeach( )
endfunction( )

# Helper macro for "fenix_get_all_targets" function
macro( __fenix_all_targets_recursive__ OUT_TARGETS IN_DIR )
   get_property( SUBDIRS DIRECTORY ${IN_DIR} PROPERTY SUBDIRECTORIES )
   foreach( SUBDIR ${SUBDIRS} )
   __fenix_all_targets_recursive__( ${OUT_TARGETS} ${SUBDIR} )
   endforeach( )

   get_property( CURRENT_TARGETS DIRECTORY ${IN_DIR} PROPERTY BUILDSYSTEM_TARGETS )
   list( APPEND ${OUT_TARGETS} ${CURRENT_TARGETS} )
endmacro( )




# This function has the same functionality as default cmake 'add_subdirectory' function
function( fenix_add_subdirectory IN_SUBDIR )

   if( ARGC GREATER 1 )
      set( IN_BIN_DIR "" )
      list( GET ARGV 1 IN_BIN_DIR )
      add_subdirectory( ${IN_SUBDIR} ${IN_BIN_DIR} )
   else( )
      add_subdirectory( ${IN_SUBDIR} )
   endif( )

   fenix_current_gen_dir( )
   fenix_project_gen_dir( )
endfunction( )

# This function calls:
#     'project' function
#     'fenix_project_gen_dir' function
#     '__fenix_setup_target_name__' function
# Parameters:
#     Single value:
#        TARGET - defines 'PROJECT_TARGET_NAME' what will be used during the build
#        PROJECT - defines 'PROJECT_NAME' what will be used during the build
# Example:
#     fenix_project( TARGET tracing PROJECT TRACING )
macro( fenix_project )
   set( OPTIONS )
   set( ONE_VALUE_ARGS TARGET PROJECT )
   set( MULTI_VALUE_ARGS )
   cmake_parse_arguments( __LOCAL "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN} )

   if( NOT DEFINED __LOCAL_TARGET )
      message( FATAL_ERROR "'TARGET' argument must be defined." )
   endif( )

   if( NOT DEFINED __LOCAL_PROJECT )
      message( FATAL_ERROR "'PROJECT' argument must be defined." )
   endif( )

   project( ${__LOCAL_PROJECT} )
   fenix_project_gen_dir( PROJECT ${__LOCAL_PROJECT} )
   __fenix_setup_target_name__( ${__LOCAL_TARGET} )
endmacro( )

# This function updates:
#     'FENIX_CURRENT_GEN_DIR' based on 'CMAKE_CURRENT_SOURCE_DIR' and 'ROOT_GEN_DIR'
macro( fenix_current_gen_dir )
   string( REGEX REPLACE "${ROOT_SOURCE_DIR}" "${ROOT_GEN_DIR}" __GEN_DIR__ ${CMAKE_CURRENT_SOURCE_DIR} )
   set( FENIX_CURRENT_GEN_DIR  "${__GEN_DIR__}" CACHE INTERNAL "FENIX_CURRENT_GEN_DIR" )
endmacro( )

# This function updates:
#     'PROJECT_GEN_DIR' based on 'PROJECT_SOURCE_DIR' and 'ROOT_GEN_DIR'
#     '${PROJECT_NAME}_GEN_DIR' base on '${PROJECT_NAME}_SOURCE_DIR' and 'ROOT_GEN_DIR'
# Parameters:
#     Single value:
#        PROJECT - defines 'PROJECT_NAME' what will be used during the build. This argument is optional and
#                  in case it is not defined 'PROJECT_NAME' variable value will be used.
# Example:
#     fenix_project_gen_dir( )
#     fenix_project_gen_dir( PROJECT TRACING )
macro( fenix_project_gen_dir )
   set( OPTIONS )
   set( ONE_VALUE_ARGS PROJECT )
   set( MULTI_VALUE_ARGS )
   cmake_parse_arguments( __LOCAL "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN} )

   set( __PROJECT_NAME__ ${PROJECT_NAME} )
   if( DEFINED __LOCAL_PROJECT )
      set( __PROJECT_NAME__ ${__LOCAL_PROJECT} )
      # TDA: Need to test if project exists
   endif( )

   string( REGEX REPLACE "${ROOT_SOURCE_DIR}" "${ROOT_GEN_DIR}" __GEN_DIR__ ${PROJECT_SOURCE_DIR} )
   set( PROJECT_GEN_DIR  "${__GEN_DIR__}" CACHE INTERNAL "PROJECT_GEN_DIR" )

   string( REGEX REPLACE "${ROOT_SOURCE_DIR}" "${ROOT_GEN_DIR}" __GEN_DIR__ ${${__PROJECT_NAME__}_SOURCE_DIR} )
   set( ${__PROJECT_NAME__}_GEN_DIR  "${__GEN_DIR__}" CACHE INTERNAL "${__PROJECT_NAME__}_GEN_DIR" )
endmacro( )

# Calculate target name as a last directory from the location path
# and put it to PROJECT_TARGET_NAME variable.
# Later on this variable is used as a name for building target using add_library(...)
# and other functions.
# Generate source files list and put them to PROJECT_SOURCE_FILES variable.
# Example:
#     __fenix_setup_target_name__( TRACING )
#     msg_dbg( "PROJECT_TARGET_NAME = " ${PROJECT_TARGET_NAME} )
function( __fenix_setup_target_name__ IN_TARGET_NAME )
   set( PROJECT_TARGET_NAME  "${IN_TARGET_NAME}" CACHE INTERNAL "PROJECT_TARGET_NAME" )
   set( ${PROJECT_NAME}_TARGET_NAME  "${IN_TARGET_NAME}" CACHE INTERNAL "${PROJECT_NAME}_TARGET_NAME" )
endfunction( )





# function( experimental )
#    set( OPTIONS )
#    set( ONE_VALUE_ARGS NAME RESULT )
#    set( MULTI_VALUE_ARGS TARGETS )
#    cmake_parse_arguments( __LOCAL "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN} )

#    set( LOCAL_RESULT "" )

#    print_variable( __LOCAL_NAME )
#    msg_dbg( "__LOCAL_TARGETS:" )
#    foreach( __LOCAL_TARGET IN LISTS __LOCAL_TARGETS )
#       msg_inf( "   - " ${__LOCAL_TARGET} )
#       list( APPEND LOCAL_RESULT ${__LOCAL_TARGET} )
#    endforeach( )

#    set( ${__LOCAL_RESULT} ${LOCAL_RESULT} PARENT_SCOPE )
# endfunction( )

# set( LIST "" )
# list( APPEND LIST XXX YYY ZZZ )

# set( RESULT_LIST "" )
# print_variable( RESULT_LIST )

# experimental(
#    NAME tracing
#    RESULT RESULT_LIST
#    TARGETS AAA BBB
#    TARGETS CCC
#    TARGETS ${LIST}
# )

# print_variable( RESULT_LIST )
