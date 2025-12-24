# Find all files with defined extentions in defined directory and put them to FILES variable.
# Parameters:
#     LOCATION - (in) directory where recursive search will be performed
#     EXTENTIONS - (in) (list) file extentions what should be found
#     FILES - (out) list of detected files
# Example:
#     find_files_by_ext( RECURSE FILES PROJECT_SOURCE_FILES LOCATION ${PROJECT_SOURCE_DIR} EXTENTIONS ${CPP_EXTENTIONS} )
#     msg_dbg( "PROJECT_SOURCE_FILES = " ${PROJECT_SOURCE_FILES} )
function( find_files_by_ext )
   set( OPTIONS RECURSE )
   set( ONE_VALUE_ARGS FILES LOCATION )
   set( MULTI_VALUE_ARGS EXTENTIONS )
   cmake_parse_arguments( ARG "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN} )



   set( LOCAL_FILES "" )
   foreach( EXTENTION ${ARG_EXTENTIONS} )
      if( ARG_RECURSE )
         file( GLOB_RECURSE _FILES_ ${ARG_LOCATION}/*.${EXTENTION} )
      else( )
         file( GLOB _FILES_ ${ARG_LOCATION}/*.${EXTENTION} )
      endif( )

      list( APPEND LOCAL_FILES ${_FILES_} )
   endforeach( )
   set( ${ARG_FILES} ${LOCAL_FILES} PARENT_SCOPE )
endfunction( )



# This function defined 'deploy' target to install (deploy)
# passed artifacts (files and directories):
#    TARGETS: ${CMAKE_INSTALL_PREFIX}/bin/${SUBDIR_TARGETS|SUBDIR_ALL}
#    HEADERS: ${CMAKE_INSTALL_PREFIX}/include/${SUBDIR_HEADERS|SUBDIR_ALL}
#    CONFIGS: ${CMAKE_INSTALL_PREFIX}/etc/${SUBDIR_CONFIGS|SUBDIR_ALL}
# 'SUBDIR_TARGETS', 'SUBDIR_HEADERS', 'SUBDIR_CONFIGS' - parameter
# what defines the additional subdirectories for artifact types
# inside destination installation path.
# 'SUBDIR_ALL' - parameter
# what defines the additional subdirectories for eachh artifact type
# inside destination installation path in case if corresponding 'SUBDIR_*'
# is not defined for thihs artifact type.
function( fenix_add_deploy_targets )
   set( OPTIONS )
   set( ONE_VALUE_ARGS NAME SUBDIR_ALL SUBDIR_TARGETS SUBDIR_INCLUDES SUBDIR_CONFIGS )
   set( MULTI_VALUE_ARGS TARGETS INCLUDES CONFIGS )
   cmake_parse_arguments( __LOCAL "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN} )

   set( LOCAL_RESULT "" )


   add_custom_target( deploy_${__LOCAL_NAME}
         DEPENDS ${PROJECT_TARGET_NAME}
         COMMENT "Deploying '${PROJECT_TARGET_NAME}'"
      )

   foreach( __LOCAL_TARGET IN LISTS __LOCAL_TARGETS )
      get_target_property( TGT_TYPE ${__LOCAL_TARGET} TYPE )

      if( __LOCAL_SUBDIR_TARGETS )
         set( SUBDIR ${__LOCAL_SUBDIR_TARGETS} )
      elseif( __LOCAL_SUBDIR_ALL )
         set( SUBDIR ${__LOCAL_SUBDIR_ALL} )
      else( )
         set( SUBDIR "" )
      endif( )

      if( TGT_TYPE STREQUAL "EXECUTABLE")
         set( DEPLOY_DIR ${CMAKE_INSTALL_PREFIX}/bin/${SUBDIR}/ )
      elseif( TGT_TYPE STREQUAL "STATIC_LIBRARY")
         set( DEPLOY_DIR ${CMAKE_INSTALL_PREFIX}/lib/${SUBDIR}/ )
      elseif( TGT_TYPE STREQUAL "SHARED_LIBRARY")
         set( DEPLOY_DIR ${CMAKE_INSTALL_PREFIX}/lib/${SUBDIR}/ )
      elseif( TGT_TYPE STREQUAL "MODULE_LIBRARY")
         set( DEPLOY_DIR ${CMAKE_INSTALL_PREFIX}/lib/${SUBDIR}/ )
      else( )
         message( FATAL_ERROR "Unknown target type ${TGT_TYPE}" )
      endif( )

      add_custom_command(
            TARGET deploy_${PROJECT_TARGET_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory ${DEPLOY_DIR}
            COMMAND ${CMAKE_COMMAND} -E copy
               $<TARGET_FILE:${__LOCAL_TARGET}>
               ${DEPLOY_DIR}
            COMMENT "Copying ${TGT_TYPE}: ${__LOCAL_TARGET} -> ${DEPLOY_DIR}"
         )

   endforeach( )

   foreach( __LOCAL_INCLUDE IN LISTS __LOCAL_INCLUDES )
      set( DEPLOY_DIR ${CMAKE_INSTALL_PREFIX}/include/${SUBDIR}/ )

      if( IS_DIRECTORY "${__LOCAL_INCLUDE}" )
         add_custom_command(
               TARGET deploy_${PROJECT_TARGET_NAME} POST_BUILD
               COMMAND ${CMAKE_COMMAND} -E make_directory ${DEPLOY_DIR}
               COMMAND ${CMAKE_COMMAND} -E copy_directory 
                  ${__LOCAL_INCLUDE}
                  ${DEPLOY_DIR}
               COMMENT "Copying INCLUDE: ${__LOCAL_INCLUDE} -> ${DEPLOY_DIR}"
            )
      else( )
         add_custom_command(
               TARGET deploy_${PROJECT_TARGET_NAME} POST_BUILD
               COMMAND ${CMAKE_COMMAND} -E make_directory ${DEPLOY_DIR}
               COMMAND ${CMAKE_COMMAND} -E copy_directory 
                  ${__LOCAL_INCLUDE}
                  ${DEPLOY_DIR}
               COMMENT "Copying INCLUDE: ${__LOCAL_INCLUDE} -> ${DEPLOY_DIR}"
            )
      endif( )
   endforeach( )

   foreach( __LOCAL_CONFIG IN LISTS __LOCAL_CONFIGS )
      set( DEPLOY_DIR ${CMAKE_INSTALL_PREFIX}/etc/${SUBDIR}/ )

      if( IS_DIRECTORY "${__LOCAL_CONFIG}" )
         add_custom_command(
               TARGET deploy_${PROJECT_TARGET_NAME} POST_BUILD
               COMMAND ${CMAKE_COMMAND} -E make_directory ${DEPLOY_DIR}
               COMMAND ${CMAKE_COMMAND} -E copy_directory 
                  ${__LOCAL_CONFIG}
                  ${DEPLOY_DIR}
               COMMENT "Copying CONFIG: ${__LOCAL_CONFIG} -> ${DEPLOY_DIR}"
            )
      elseif( )
         add_custom_command(
               TARGET deploy_${PROJECT_TARGET_NAME} POST_BUILD
               COMMAND ${CMAKE_COMMAND} -E make_directory ${DEPLOY_DIR}
               COMMAND ${CMAKE_COMMAND} -E copy_directory 
                  ${__LOCAL_CONFIG}
                  ${DEPLOY_DIR}
               COMMENT "Copying CONFIG: ${__LOCAL_CONFIG} -> ${DEPLOY_DIR}"
            )
      endif( )
   endforeach( )
endfunction( )
