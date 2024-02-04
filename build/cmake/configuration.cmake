# set(CMAKE_GENERATOR "Sublime Text 2 - Unix Makefiles")

set( CMAKE_VERBOSE_MAKEFILE on )

# Root source directory
set( ROOT_SOURCE_DIR ${CMAKE_SOURCE_DIR} )

# Root binary directory
set( ROOT_BINARY_DIR ${CMAKE_BINARY_DIR} )

# Root gen directory
if( NOT DEFINED ROOT_GEN_DIR )
   set( ROOT_GEN_DIR ${ROOT_BINARY_DIR}/gen )
endif( )

# Root delivery directory
if( NOT DEFINED ROOT_DELIVERY_DIR )
   set( ROOT_DELIVERY_DIR ${CMAKE_INSTALL_PREFIX} )
else( )
   set( CMAKE_INSTALL_PREFIX ${ROOT_DELIVERY_DIR} )
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

# Target OS
if( NOT DEFINED TARGET_OS )
   set( TARGET_OS "linux" )
endif( )




# Enable framework system tracin
fenix_is_on_off(
      SYS_TRACE
      SYS_TRACE
      FENIX_POSITIVE_VALUE
   )

# Enable application tracing
fenix_is_on_off(
      MSG_TRACE
      MSG_TRACE
      FENIX_POSITIVE_VALUE
   )

# Enable colored tracing for console
fenix_is_on_off(
      COLORED_TRACE
      COLORED_TRACE
      FENIX_POSITIVE_VALUE
   )

# Enable dlt tracing
fenix_is_on_off(
      DLT_TRACE
      DLT_TRACE
      FENIX_POSITIVE_VALUE
   )

# Enable dlt tracing
fenix_is_on_off(
      DEBUG_STREAM
      DEBUG_STREAM
      FENIX_NEGATIVE_VALUE
   )

# Enable memory allocator hooks
fenix_is_on_off(
      MEMORY_HOOK
      MEMORY_HOOK
      FENIX_NEGATIVE_VALUE
   )

# Enable instrumental functionality
fenix_is_on_off(
      INSTRUMENTAL
      INSTRUMENTAL
      FENIX_NEGATIVE_VALUE
   )

# Enable debug information
fenix_is_on_off(
      USE_DEBUG
      USE_DEBUG
      FENIX_NEGATIVE_VALUE
   )

# Enable goolgle protobuf
fenix_is_on_off(
      USE_GPB
      USE_GPB
      FENIX_POSITIVE_VALUE
   )

# Enable RTTI
fenix_is_on_off(
      USE_RTTI
      USE_RTTI
      FENIX_POSITIVE_VALUE
   )
