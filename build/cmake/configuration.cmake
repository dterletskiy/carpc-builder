# set(CMAKE_GENERATOR "Sublime Text 2 - Unix Makefiles")

set( CMAKE_VERBOSE_MAKEFILE on )

# Root source directory
set( ROOT_SOURCE_DIR ${SOURCE_DIR} )

# Root binary directory
set( ROOT_BINARY_DIR ${CMAKE_BINARY_DIR} )

# Root gen directory
if( NOT DEFINED ROOT_GEN_DIR )
   set( ROOT_GEN_DIR ${ROOT_BINARY_DIR}/gen )
endif( )

# Root deploy directory
if( NOT DEFINED ROOT_DEPLOY_DIR )
   set( ROOT_DEPLOY_DIR ${CMAKE_INSTALL_PREFIX} )
else( )
   set( CMAKE_INSTALL_PREFIX ${ROOT_DEPLOY_DIR} )
endif( )

# Python FW directory
if( NOT DEFINED PFW_DIR )
   set( PFW_DIR ${FENIX_DIR}/submodules/dterletskiy/python_fw )
endif( )

# antlr jar file
if( NOT DEFINED ANTLR4_JAR )
   set( ANTLR4_JAR ${FENIX_DIR}/thirdparty/antlr/antlr-4.10.1-complete.jar )
endif( )

# plantuml jar file
if( NOT DEFINED PLANTUML_JAR )
   set( PLANTUML_JAR ${FENIX_DIR}/thirdparty/plantuml/plantuml-1.2021.14.jar )
endif( )

# Add path to installed CARPC api headers
if( DEFINED CARPC_API )
   include_directories( ${CARPC_API} )
endif( )

# Add path to installed CARPC libraries
if( DEFINED CARPC_LIB )
   link_directories( ${CARPC_LIB} )
endif( )




# Enable colored tracing for console
fenix_is_on_off(
      CARPC_BUILD_TRACE_ENABLED
      CARPC_BUILD_TRACE_ENABLED
      FENIX_POSITIVE_VALUE
   )

# Enable debug information
fenix_is_on_off(
      CARPC_BUILD_DEBUG
      CARPC_BUILD_DEBUG
      FENIX_NEGATIVE_VALUE
   )

# Enable RTTI
fenix_is_on_off(
      CARPC_BUILD_RTTI_ENABLED
      CARPC_BUILD_RTTI_ENABLED
      FENIX_POSITIVE_VALUE
   )

# Enable STD policy
fenix_is_on_off(
      CARPC_BUILD_POLICY_STD
      CARPC_BUILD_POLICY_STD
      FENIX_POSITIVE_VALUE
   )
