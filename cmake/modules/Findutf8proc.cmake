# - Try to find the utf8proc
# Once done this will define
#
#  UTF8PROC_FOUND - system has utf8proc
#  UTF8PROC_INCLUDE_DIR - The include directory to use for the utf8proc headers
#  UTF8PROC_LIBRARIES - Link these to use utf8proc
#  UTF8PROC_DEFINITIONS - Compiler switches required for using utf8proc

# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

mark_as_advanced(
  UTF8PROC_INCLUDE_DIR
  UTF8PROC_LIBRARY
)

# Append UTF8PROC_ROOT or $ENV{UTF8PROC_ROOT} if set (prioritize the direct cmake var)
set(_UTF8PROC_ROOT_SEARCH_DIR "")

if(UTF8PROC_ROOT)
  list(APPEND _UTF8PROC_ROOT_SEARCH_DIR ${UTF8PROC_ROOT})
else()
  set(_ENV_UTF8PROC_ROOT $ENV{UTF8PROC_ROOT})
  if(_ENV_UTF8PROC_ROOT)
    list(APPEND _UTF8PROC_ROOT_SEARCH_DIR ${_ENV_UTF8PROC_ROOT})
  endif()
endif()

# Additionally try and use pkconfig to find libutf8proc

find_package(PkgConfig QUIET)
pkg_check_modules(PC_UTF8PROC QUIET libutf8proc)

# ------------------------------------------------------------------------
#  Search for utf8proc include DIR
# ------------------------------------------------------------------------

set(_UTF8PROC_INCLUDE_SEARCH_DIRS "")
list(APPEND _UTF8PROC_INCLUDE_SEARCH_DIRS
  ${UTF8PROC_INCLUDEDIR}
  ${_UTF8PROC_ROOT_SEARCH_DIR}
  ${PC_UTF8PROC_INCLUDE_DIRS}
  ${SYSTEM_LIBRARY_PATHS}
)

# Look for a standard utf8proc header file.
find_path(UTF8PROC_INCLUDE_DIR utf8proc.h
  PATHS ${_UTF8PROC_INCLUDE_SEARCH_DIRS}
  PATH_SUFFIXES include
)

if(EXISTS "${UTF8PROC_INCLUDE_DIR}/utf8proc.h")
  file(STRINGS "${UTF8PROC_INCLUDE_DIR}/utf8proc.h" UTF8PROC_VERSION_MAJOR_LINE REGEX "^#define[ \t]+UTF8PROC_VERSION_MAJOR[ \t]+[0-9]+$")
  file(STRINGS "${UTF8PROC_INCLUDE_DIR}/utf8proc.h" UTF8PROC_VERSION_MINOR_LINE REGEX "^#define[ \t]+UTF8PROC_VERSION_MINOR[ \t]+[0-9]+$")
  file(STRINGS "${UTF8PROC_INCLUDE_DIR}/utf8proc.h" UTF8PROC_VERSION_PATCH_LINE REGEX "^#define[ \t]+UTF8PROC_VERSION_PATCH[ \t]+[0-9]+$")
  string(REGEX REPLACE "^#define[ \t]+UTF8PROC_VERSION_MAJOR[ \t]+([0-9]+)$" "\\1" UTF8PROC_VERSION_MAJOR "${UTF8PROC_VERSION_MAJOR_LINE}")
  string(REGEX REPLACE "^#define[ \t]+UTF8PROC_VERSION_MINOR[ \t]+([0-9]+)$" "\\1" UTF8PROC_VERSION_MINOR "${UTF8PROC_VERSION_MINOR_LINE}")
  string(REGEX REPLACE "^#define[ \t]+UTF8PROC_VERSION_PATCH[ \t]+([0-9]+)$" "\\1" UTF8PROC_VERSION_PATCH "${UTF8PROC_VERSION_PATCH_LINE}")
  set(UTF8PROC_VERSION ${UTF8PROC_VERSION_MAJOR}.${UTF8PROC_VERSION_MINOR}.${UTF8PROC_VERSION_PATCH})
endif()

# ------------------------------------------------------------------------
#  Search for utf8proc lib DIR
# ------------------------------------------------------------------------

set(_UTF8PROC_LIBRARYDIR_SEARCH_DIRS "")
list(APPEND _UTF8PROC_LIBRARYDIR_SEARCH_DIRS
  ${UTF8PROC_LIBRARYDIR}
  ${_UTF8PROC_ROOT_SEARCH_DIR}
  ${PC_UTF8PROC_LIBRARY_DIRS}
  ${SYSTEM_LIBRARY_PATHS}
)

# Static library setup
if(UNIX AND UTF8PROC_USE_STATIC_LIBS)
  set(_UTF8PROC_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
endif()

set(UTF8PROC_PATH_SUFFIXES
  lib
  lib64
)

find_library(UTF8PROC_LIBRARY utf8proc
  PATHS ${_UTF8PROC_LIBRARYDIR_SEARCH_DIRS}
  PATH_SUFFIXES ${UTF8PROC_PATH_SUFFIXES}
)

if(UNIX AND UTF8PROC_USE_STATIC_LIBS)
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${_UTF8PROC_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
  unset(_UTF8PROC_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES)
endif()

# ------------------------------------------------------------------------
#  Cache and set UTF8PROC_FOUND
# ------------------------------------------------------------------------

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(utf8proc
  FOUND_VAR UTF8PROC_FOUND
  REQUIRED_VARS
    UTF8PROC_LIBRARY
    UTF8PROC_INCLUDE_DIR
  VERSION_VAR UTF8PROC_VERSION
)

if(UTF8PROC_FOUND)
  set(UTF8PROC_LIBRARIES ${UTF8PROC_LIBRARY})
  set(UTF8PROC_INCLUDE_DIRS ${UTF8PROC_INCLUDE_DIR})
  set(UTF8PROC_DEFINITIONS ${PC_UTF8PROC_CFLAGS_OTHER})

  get_filename_component(UTF8PROC_LIBRARY_DIRS ${UTF8PROC_LIBRARY} DIRECTORY)

  if(NOT TARGET UTF8PROC::utf8proc)
    add_library(UTF8PROC::utf8proc UNKNOWN IMPORTED)
    set_target_properties(UTF8PROC::utf8proc PROPERTIES
      IMPORTED_LOCATION "${UTF8PROC_LIBRARIES}"
      INTERFACE_COMPILE_DEFINITIONS "${UTF8PROC_DEFINITIONS}"
      INTERFACE_INCLUDE_DIRECTORIES "${UTF8PROC_INCLUDE_DIRS}"
    )
  endif()
endif()
