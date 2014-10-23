require 'formula'

class PlplotFixed < Formula
  homepage 'http://plplot.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/plplot/plplot/5.10.0%20Source/plplot-5.10.0.tar.gz'
  sha1 'ea962cb0138c9b4cbf97ecab1fac1919ea0f939f'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on :x11 => :optional

  conflicts_with 'plplot'

  option 'with-java'

  patch :DATA

  def install
    args = std_cmake_args
    args << '-DPLD_wxwidgets=OFF' << '-DENABLE_wxwidgets=OFF' << '-DPL_HAVE_PTHREAD=ON'
    args << '-DENABLE_java=OFF' if build.without? 'java'
    args << '-DPLD_xcairo=OFF' if build.without? 'x11'
    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end
__END__
commit 467c0b0ef58b1759238d7ec3551e3e3fe8f36c5b
Author: Alan W. Irwin <airwin@users.sourceforge.net>
Date:   Fri Apr 4 17:31:22 2014 +0000

    Solve name clash <https://sourceforge.net/p/plplot/bugs/146/> by
    replacing HAVE_CONFIG_H ==> PLPLOT_HAVE_CONFIG_H everywhere within
    our source tree.
    
    svn path=/trunk/; revision=13096

diff --git a/CMakeLists.txt b/CMakeLists.txt
index fceaa8f..5176f1d 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -125,7 +125,7 @@ configure_file(
   ${CMAKE_CURRENT_BINARY_DIR}/plplot_config.h
   )
 # Allow access to the generated plplot_config.h for this build.
-add_definitions("-DHAVE_CONFIG_H")
+add_definitions("-DPLPLOT_HAVE_CONFIG_H")
 # Install top-level files
 
 # Enable testing framework for examples
diff --git a/bindings/ocaml/CMakeLists.txt b/bindings/ocaml/CMakeLists.txt
index 7fc8388..ff392f0 100644
--- a/bindings/ocaml/CMakeLists.txt
+++ b/bindings/ocaml/CMakeLists.txt
@@ -98,7 +98,7 @@ if(ENABLE_ocaml)
     ${CMAKE_CURRENT_BINARY_DIR}/dllplplot_stubs.so
     ${CMAKE_CURRENT_BINARY_DIR}/libplplot_stubs.a
     COMMAND ${OCAMLC} -ccopt -I${CAMLIDL_LIB_DIR} -c ${CMAKE_CURRENT_BINARY_DIR}/plplot_core_stubs.c
-    COMMAND ${OCAMLC} -ccopt -I${CMAKE_SOURCE_DIR}/include -ccopt -I${CMAKE_BINARY_DIR}/include -ccopt -I${CMAKE_SOURCE_DIR}/lib/qsastime -ccopt -I${CMAKE_BINARY_DIR} -ccopt -I${CAMLIDL_LIB_DIR} -ccopt -DHAVE_CONFIG_H -c ${CMAKE_CURRENT_SOURCE_DIR}/plplot_impl.c
+    COMMAND ${OCAMLC} -ccopt -I${CMAKE_SOURCE_DIR}/include -ccopt -I${CMAKE_BINARY_DIR}/include -ccopt -I${CMAKE_SOURCE_DIR}/lib/qsastime -ccopt -I${CMAKE_BINARY_DIR} -ccopt -I${CAMLIDL_LIB_DIR} -ccopt -DPLPLOT_HAVE_CONFIG_H -c ${CMAKE_CURRENT_SOURCE_DIR}/plplot_impl.c
     COMMAND ${OCAMLMKLIB} -o plplot_stubs -L${CAMLIDL_LIB_DIR} -lcamlidl -L${CMAKE_BINARY_DIR}/src -lplplot${LIB_TAG} ${CMAKE_CURRENT_BINARY_DIR}/plplot_core_stubs.o ${CMAKE_CURRENT_BINARY_DIR}/plplot_impl.o ${ocaml_STATIC_FLAGS}
     DEPENDS
     ${CMAKE_CURRENT_BINARY_DIR}/plplot_core_stubs.c
diff --git a/bindings/ocaml/plcairo/CMakeLists.txt b/bindings/ocaml/plcairo/CMakeLists.txt
index 423ef80..d98acf5 100644
--- a/bindings/ocaml/plcairo/CMakeLists.txt
+++ b/bindings/ocaml/plcairo/CMakeLists.txt
@@ -36,7 +36,7 @@ if(ENABLE_ocaml AND OCAML_HAS_CAIRO)
     ${CMAKE_CURRENT_BINARY_DIR}/plcairo_impl.o
     ${CMAKE_CURRENT_BINARY_DIR}/dllplcairo_stubs.so
     ${CMAKE_CURRENT_BINARY_DIR}/libplcairo_stubs.a
-    COMMAND ${OCAMLC} -ccopt "${CAIRO_COMPILE_FLAGS}" -cclib "${CAIRO_LINK_FLAGS}" -ccopt -I${CMAKE_SOURCE_DIR}/include -ccopt -I${CMAKE_BINARY_DIR}/include -ccopt -I${CMAKE_SOURCE_DIR}/lib/qsastime  -ccopt -I${CMAKE_BINARY_DIR} -ccopt -DHAVE_CONFIG_H -c ${CMAKE_CURRENT_SOURCE_DIR}/plcairo_impl.c
+    COMMAND ${OCAMLC} -ccopt "${CAIRO_COMPILE_FLAGS}" -cclib "${CAIRO_LINK_FLAGS}" -ccopt -I${CMAKE_SOURCE_DIR}/include -ccopt -I${CMAKE_BINARY_DIR}/include -ccopt -I${CMAKE_SOURCE_DIR}/lib/qsastime  -ccopt -I${CMAKE_BINARY_DIR} -ccopt -DPLPLOT_HAVE_CONFIG_H -c ${CMAKE_CURRENT_SOURCE_DIR}/plcairo_impl.c
     COMMAND ${OCAMLMKLIB} -o plcairo_stubs ${CAIRO_LINK_FLAGS_LIST} -L${CMAKE_BINARY_DIR}/src -lplplot${LIB_TAG} ${CMAKE_CURRENT_BINARY_DIR}/plcairo_impl.o
     DEPENDS
     ${CMAKE_CURRENT_SOURCE_DIR}/plcairo_impl.c
diff --git a/include/plConfig.h.in b/include/plConfig.h.in
index ee10f81..27ce48b 100644
--- a/include/plConfig.h.in
+++ b/include/plConfig.h.in
@@ -29,7 +29,7 @@
 // any user applications).  Therefore, the configured plConfig.h
 // should be installed.  In contrast, plplot_config.h.in (note,
 // plConfig.h #includes plplot_config.h for the core build because
-// HAVE_CONFIG_H is #defined in that case) contains configured macros
+// PLPLOT_HAVE_CONFIG_H is #defined in that case) contains configured macros
 // that are only required for the core build.  Therefore, in contrast
 // to plConfig.h, plplot_config.h should not be installed.
 //
@@ -43,7 +43,7 @@
 #ifndef __PLCONFIG_H__
 #define __PLCONFIG_H__
 
-#ifdef HAVE_CONFIG_H
+#ifdef PLPLOT_HAVE_CONFIG_H
 #  include <plplot_config.h>
 #endif
 
diff --git a/plplot_config.h.in b/plplot_config.h.in
index 57ee282..25e9472 100644
--- a/plplot_config.h.in
+++ b/plplot_config.h.in
@@ -3,7 +3,7 @@
 // examples (and presumably any user applications).  Therefore, the
 // configured plplot_config.h should not be installed.  In contrast,
 // include/plConfig.h.in (note, the configured plConfig.h result
-// #includes plplot_config.h for the core build because HAVE_CONFIG_H
+// #includes plplot_config.h for the core build because PLPLOT_HAVE_CONFIG_H
 // is #defined in that case) contains configured macros that are
 // required for the core build, installed examples build, and build of
 // user applications.  Therefore, in contrast to plplot_config.h,
