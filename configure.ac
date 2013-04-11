#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([Hezelnut], [0.0.1], [ned.rihine@gmail.com])
AM_INIT_AUTOMAKE
AC_CONFIG_SRCDIR([include/Hezelnut/HNObject.h])
AC_CONFIG_HEADERS([include/config.h])
AC_CONFIG_MACRO_DIR([builds/m4])


# 
# --enable-tests
# 
AC_ARG_ENABLE(tests,
    AC_HELP_STRING([--enable-tests],
    [enable test suites [default=no]]),
    ,enable_tests=no)

# 
# --enable-debug
# 
AC_ARG_ENABLE(debug,
    AC_HELP_STRING([--enable-debug],
        [use 'DEBUG' configuration [default=no]]),
        , enable_debug=no)

# 
# CFLAGS 
# 
if test x$enable_debug = xyes; then
  CFLAGS="$CFLAGS -g -W -Wall"
else
  CFLAGS="$CFLAGS -O2 -W -Wall"
fi

## Makefile.am variables
AM_CONDITIONAL(TESTS, test x$enable_tests = xyes)


# Checks for programs.
AC_PROG_CC
AC_PROG_CPP
AC_PROG_OBJC
AC_PROG_LIBTOOL
AC_PROG_INSTALL

AC_LIBTOOL_WIN32_DLL


# Checks for libraries.


# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([limits.h stddef.h stdio.h stdarg.h stdlib.h string.h])


# Checks for typedefs, structures, and compiler characteristics.
## Keywords
AC_C_CONST
AC_C_INLINE
AC_C_VOLATILE
AC_C_STRINGIZE

## Types
AC_TYPE_SIZE_T
AC_CHECK_SIZEOF(void *)

## Functions
AC_FUNC_MALLOC


# Checks for library functions.

# Output files
AC_CONFIG_FILES([Makefile
    include/Makefile
    include/Hezelnut/Makefile
    src/Makefile])
AC_OUTPUT
