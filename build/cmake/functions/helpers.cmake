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
