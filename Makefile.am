SUBDIRS = include src
if TESTS
  SUBDIRS += tests
endif

pkgconfigdir = $(libdir)/pkg-config
pkgincludedir = $(includedir)
pkginclude_HEADERS = ./include/Hezelnut/Hezelnut.h
pkgconfig_DATA = Hezelnut.pc

CLEANFILES = Hezelnut.pc

EXTRA_DIST = Hezelnut.pc.in

ACLOCAL_AMFLAGS = -I builds/m4

dist-hook: changelog

changelog: $(top_srcdir)/.git/HEAD
	git log --stat > ChangeLog

doc: doxygen.conf
	doxygen doxygen.conf

doxygen.conf:
	doxygen -g doxygen.conf
