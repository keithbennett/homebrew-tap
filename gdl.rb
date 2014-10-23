require 'formula'

class Gdl < Formula
  homepage 'http://gnudatalanguage.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/gnudatalanguage/gdl/0.9.5/gdl-0.9.5.tar.gz'
  sha1 'b512497030ec9432aebd075fefb41d674d736d72'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gsl'
  depends_on 'plplot-fixed'

  patch :DATA

  def install
    args = std_cmake_args
    args << '-DNETCDF=OFF' << '-DHDF=OFF' << '-DHDF5=OFF' << '-DFFTW=OFF'
    args << '-DEIGEN3=OFF' << '-DPSLIB=OFF' << '-DWXWIDGETS=OFF'
    args << '-DMAGICK=OFF'

    mkdir "gdl-build" do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end

__END__
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 1f7ffec..00cf63b 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -297,3 +297,5 @@ install(DIRECTORY ${CMAKE_SOURCE_DIR}/src/pro/ DESTINATION ${CMAKE_INSTALL_PREFI
 	PATTERN Makefile* EXCLUDE
 	PATTERN UrgentNeed.txt EXCLUDE)
 
+set_source_files_properties(GDLParser.cpp PROPERTIES COMPILE_FLAGS "-O1")
+set_source_files_properties(GDLTreeParser.cpp PROPERTIES COMPILE_FLAGS "-O1")
diff --git a/src/base64.hpp b/src/base64.hpp
index 95423d8..94a2aa8 100644
--- a/src/base64.hpp
+++ b/src/base64.hpp
@@ -147,7 +147,7 @@ namespace base64 {
 						Warning("base64 decode error: unexpected fill char -- offset read?");
 						return false;
 					}
-					if(!(isspace(data[i-1]))) {
+					if(!(std::isspace(data[i-1]))) {
 						//cerr << "base 64 decode error: illegal character '" << data[i-1] << "' (0x" << std::hex << (int)data[i-1] << std::dec << ")" << endl;
 						Warning("base 64 decode error: illegal character");
 						return false;
@@ -165,7 +165,7 @@ namespace base64 {
 						Warning("base64 decode error: unexpected fill char -- offset read?");
 						return false;
 					}
-					if(!(isspace(data[i-1]))) {
+					if(!(std::isspace(data[i-1]))) {
 						//cerr << "base 64 decode error: illegal character '" << data[i-1] << '\'' << endl;
 						Warning("base 64 decode error: illegal character");
 						return false;
@@ -190,7 +190,7 @@ namespace base64 {
 					if(fillchar == data[i-1]) {
 						return true;
 					}
-					if((!isspace(data[i-1]))) {
+					if((!std::isspace(data[i-1]))) {
 						//cerr << "base 64 decode error: illegal character '" << data[i-1] << '\'' << endl;
 						Warning("base 64 decode error: illegal character");
 						return false;
@@ -215,7 +215,7 @@ namespace base64 {
 					if(fillchar == data[i-1]) {
 						return true;
 					}
-					if(!(isspace(data[i-1]))) {
+					if(!(std::isspace(data[i-1]))) {
 						//cerr << "base 64 decode error: illegal character '" << data[i-1] << '\'' << endl;
 						Warning("base 64 decode error: illegal character");
 						return false;
diff --git a/src/basic_fun.cpp b/src/basic_fun.cpp
index cf2db87..b729a1c 100644
--- a/src/basic_fun.cpp
+++ b/src/basic_fun.cpp
@@ -6483,7 +6483,7 @@ BaseGDL* strtok_fun(EnvT* e) {
       while (p < e) 
       {
         // scheme = 1*[ lowalpha | digit | "+" | "-" | "." ]
-        if (!(isalpha(*p)) && !(isdigit(*p)) && (*p != '+') && (*p != '.') && (*p != '-')) 
+        if (!(std::isalpha(*p)) && !(std::isdigit(*p)) && (*p != '+') && (*p != '.') && (*p != '-'))
         {
           if (e + 1 < ue) goto parse_port;
           else goto just_path;
@@ -6501,7 +6501,7 @@ BaseGDL* strtok_fun(EnvT* e) {
       {
         // check if the data we get is a port this allows us to correctly parse things like a.com:80
         p = e + 1;
-        while (isdigit(*p)) p++;
+        while (std::isdigit(*p)) p++;
 	if ((*p == '\0' || *p == '/') && (p - e) < 7) goto parse_port;
         urlstru->InitTag("SCHEME", DStringGDL(string(s, (e - s))));
         length -= ++e - s;
@@ -6552,7 +6552,7 @@ BaseGDL* strtok_fun(EnvT* e) {
       parse_port:
       p = e + 1;
       pp = p;
-      while (pp-p < 6 && isdigit(*pp)) pp++;
+      while (pp-p < 6 && std::isdigit(*pp)) pp++;
       if (pp-p < 6 && (*pp == '/' || *pp == '\0')) 
       {
         memcpy(port_buf, p, (pp-p));
diff --git a/src/devicex.hpp b/src/devicex.hpp
index f30f5a6..960ce3b 100644
--- a/src/devicex.hpp
+++ b/src/devicex.hpp
@@ -392,7 +392,7 @@ public:
     winList[ wIx]->SETOPT( "plwindow", buf);
 
     // we use our own window handling
-    winList[ wIx]->SETOPT( "drvopt","usepth=1");
+    winList[ wIx]->SETOPT( "drvopt","usepth=0");
 
     PLINT r[ctSize], g[ctSize], b[ctSize];
     actCT.Get( r, g, b);
diff --git a/src/gsl_fun.cpp b/src/gsl_fun.cpp
index e66d77d..2a72f3b 100644
--- a/src/gsl_fun.cpp
+++ b/src/gsl_fun.cpp
@@ -3183,7 +3183,7 @@ namespace lib {
       e->AssureScalarPar<DStringGDL>(0, tmpname);    
       name.reserve(tmpname.length());
       for (string::iterator it = tmpname.begin(); it < tmpname.end(); it++) 
-        if (*it != ' ' && *it != '_') name.append(1, (char)tolower(*it));
+        if (*it != ' ' && *it != '_') name.append(1, (char)std::tolower(*it));
     }
 
 #ifdef USE_UDUNITS
diff --git a/src/str.cpp b/src/str.cpp
index e8b9a39..231faef 100644
--- a/src/str.cpp
+++ b/src/str.cpp
@@ -178,7 +178,7 @@ string StrUpCase(const string& s)
   ArrayGuard<char> guard( r);
   r[len]=0;
   for(unsigned i=0;i<len;i++)
-    r[i]=toupper(sCStr[i]);
+    r[i]=std::toupper(sCStr[i]);
   return string(r);
 }
 void StrUpCaseInplace( string& s)
@@ -189,7 +189,7 @@ void StrUpCaseInplace( string& s)
 //   ArrayGuard<char> guard( r);
 //   r[len]=0;
   for(unsigned i=0;i<len;i++)
-    s[i]=toupper(s[i]);
+    s[i]=std::toupper(s[i]);
 //   return string(r);
 }
 
@@ -201,7 +201,7 @@ string StrLowCase(const string& s)
   ArrayGuard<char> guard( r);
   r[len]=0;
   for(unsigned i=0;i<len;i++)
-    r[i]=tolower(sCStr[i]);
+    r[i]=std::tolower(sCStr[i]);
   return string(r);
 }
 void StrLowCaseInplace(string& s)
@@ -209,8 +209,8 @@ void StrLowCaseInplace(string& s)
   unsigned len=s.length();
 //   char const *sCStr=s.c_str();
   for(unsigned i=0;i<len;i++)
-    s[i]=tolower(s[i]);
-//     s[i]=tolower(sCStr[i]);
+    s[i]=std::tolower(s[i]);
+//     s[i]=std::tolower(sCStr[i]);
 }
 
 // replacement for library routine 
