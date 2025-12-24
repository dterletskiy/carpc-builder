cmake_minimum_required( VERSION 3.16 FATAL_ERROR )



# 'FENIX_SUBDIR' must be defined as relative path to 'carpc-builder' project
set( FENIX_SUBDIR "./" )
# 'init.cmake' from 'carpc-builder' must be called to initialize build system
include( ${FENIX_SUBDIR}/init.cmake )



fenix_project( TARGET fenix PROJECT FENIX )

# 'TARGET_PREFIX' - Variable that defines the prefix to add to each target.
set( TARGET_PREFIX "carpc-" )

# 'SOURCE_DIR' - A variable that defines the path to the CMakeLists.txt
# file of the project with the source code for the build.
fenix_add_subdirectory( ${SOURCE_DIR} build )

# Scanning all targets defined in the 'SOURCE_DIR'
fenix_get_all_targets( TARGETS )

# Filter only targets starts withh 'deploy_' and collect them to single
# 'deploy' target to deploy all.
fenix_filter_targets_by_prefix( DEPLOY_TARGETS "${TARGETS}" "deploy_" )
add_custom_target( deploy ALL COMMENT "Deploying all components" )
add_dependencies( deploy ${DEPLOY_TARGETS} )

print_list( "${TARGETS}" MESSAGE "Defined targets:" )
print_list( "${DEPLOY_TARGETS}" MESSAGE "Defined deploy targets:" )

# Generate graph file with dependancies between targets.
generate_dependencies_graph( ${ROOT_GEN_DIR} ${CMAKE_PROJECT_NAME} "${TARGETS}" )
