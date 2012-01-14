SUBDIRS = src


dist-hook: changelog

changelog: $(top_srcdir)/.git/HEAD
	git log --stat > ChangeLog

git-status:
	git status -v > HEAD.diff

doc: doxygen.conf
	doxygen doxygen.conf
