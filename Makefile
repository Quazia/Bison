
##########################################################################
################# SPECIAL MAKEFILE FOR flex/bison project ################
##########################################################################
##### $Id: Makefile,v 1.3 2016/01/24 23:33:00 bks Exp $ #####
##########################################################################

#
# Definitions
#

CC =		gcc
CCC =		g++

CCFLAGS =	-ggdb
CFLAGS =	-ggdb 
# CFLAGS =	-ggdb -Wall   # will reveal warnings regarding bison/flex code
LIBFLAGS =	-lm

C_FILES =	symtab.c
H_FILES =	symtab.h compiler.h
LEX_FILES =	scanner.lex calc.lex compiler.lex prefix.lex
Y_FILES =	calc.y compiler.y prefix.y

OUTPUT_FILES =	calc.output compiler.output prefix.output

SOURCEFILES =	$(C_FILES) $(H_FILES) $(LEX_FILES) $(Y_FILES)

.precious:	$(SOURCEFILES)

INTERMEDIATE =	scanner.yy.c \
		calc.tab.c calc.yy.c \
		compiler.tab.c compiler.yy.c \
		prefix.tab.c prefix.yy.c \
		symtab.o \
		$(OUTPUT_FILES)

EXECS = scanner calc compiler prefix	

#
# Main targets
#

all:	 scanner calc prefix compiler

scanner:	scanner.yy.c
	$(CC) $(CFLAGS) -o scanner scanner.yy.c

scanner.yy.c:	scanner.lex
	flex -oscanner.yy.c scanner.lex

calc:	calc.tab.c calc.yy.c symtab.o
	$(CC) $(CFLAGS) -o calc calc.tab.c symtab.o

calc.yy.c:	calc.lex
	flex -ocalc.yy.c calc.lex

calc.tab.c:	calc.y symtab.h
	bison -v calc.y

prefix:	prefix.tab.c prefix.yy.c symtab.o
	$(CC) $(CFLAGS) -o prefix prefix.tab.c symtab.o

prefix.yy.c:	prefix.lex
	flex -oprefix.yy.c prefix.lex

prefix.tab.c:	prefix.y symtab.h
	bison -v prefix.y

compiler:	compiler.tab.c compiler.yy.c
	$(CC) $(CFLAGS) -o compiler compiler.tab.c

compiler.yy.c:	compiler.lex
	flex -ocompiler.yy.c compiler.lex

compiler.tab.c:	compiler.y compiler.h
	bison -v compiler.y

#
# Dependencies
#

#
# Housekeeping
#

Archive:	archive.tgz
	@echo to extract, gunzip $<

archive.tgz:	$(SOURCEFILES) Makefile
	tar cf - $(SOURCEFILES) Makefile | gzip > archive.tgz

clean:
	-/bin/rm -r $(INTERMEDIATE) core 2> /dev/null
	-/bin/rm -rf *.dSYM core 2> /dev/null

realclean:	clean
	-/bin/rm -r $(EXECS) core 2> /dev/null

