#
# File Name   : Makefile
# Description : Makefile for the compilers project.
# 
# Course      : Introduction to Compilers
# Dept. of Electrical and Computer Engineering, Seoul National University
#

LEX = flex

CC = gcc
CFLAGS = -g
LDFLAGS = -lfl

# Modify here if there are additional source files.
OBJECTS = lex.yy.o hash.o

all: subc

subc: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o subc

lex.yy.o: lex.yy.c

lex.yy.c: subc.l
	$(LEX) $(LFLAGS) subc.l

clean: 
	rm -f *.o lex.yy.c subc