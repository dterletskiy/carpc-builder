cmake_minimum_required( VERSION 3.16 FATAL_ERROR )



# 'FENIX_SUBDIR' myst be defined as relative path to 'carpc-builder' project
set( FENIX_SUBDIR "./" )
# 'init.cmake' from 'carpc-builder' must be called to initialize build system
include( ${FENIX_SUBDIR}/init.cmake )



fenix_project( TARGET fenix PROJECT FENIX )


set( TARGET_PREFIX "carpc-" )
fenix_add_subdirectory( ${SOURCE_DIR} build )

fenix_get_all_targets( TARGETS )
generate_dependencies_graph( ${ROOT_GEN_DIR} ${CMAKE_PROJECT_NAME} "${TARGETS}" )
