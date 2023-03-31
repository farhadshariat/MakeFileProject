#note: you can aliasing mingw32-make to make(go to c:\\MinGW\bin and rename mingw32-make to make)
CC=gcc
CClang=clang
CPP=g++
CFLAGS=-g -Wall
AR = ar -rc
RANLIB = ranlib

TARGETNAME=main

LIBSdir = lib
OBJSdir = obj
SRCdir = src
INCdir = ./src/inc/
TEMPLATEdir = atemplate
TEST = tests

# you can add your own tempalate 
TEMPLATEfile = template

DefaultTempalte = '\#include <stdio.h>\n\nint main()\n{\n\tprintf("Hello world!\\n");\n\treturn 0;\n}'

ASMFLAGS=-fverbose-asm #-fverbose-asm comment all the c code next to assembly code (very useful)
#gcc -S -masm=intel -Og -fverbose-asm main.c (intel assembly syntax)
#clang -S -mllvm --x86-asm-syntax=intel main.c (clang tool intel assembly syntax)
# -Woverloaded-virtual is Working for C++		 
# dependency file maker "-MD -MP"
#..... LIST
# -Wextra -Wfloat-equal -Wundef -Wcast-align -Wwrite-strings -Wlogical-op -Wmissing-declarations -Wredundant-decls -Wshadow
#..... LIST

# wildcard finds all file which is finiesh by certain postfix (.s .c .h .d)
ASM_SRCS = $(wildcard *.s)

SRCS = $(wildcard $(SRCdir)/*.c)
OBJS := $(SRCS:$(SRCdir)/%.c=$(OBJSdir)/%.o)

#in a case you need list of header files
INCS = $(wildcard $(SRCdir)/$(INCdir)/*.h)

LIBS := $(SRCS:$(SRCdir)/%.c=$(LIBSdir)/%.a)
LIBSNAMES := $(SRCS:$(SRCdir)/%.c=-l:%.a)
FILENAMES := $(SRCS:$(SRCdir)/%.c=%)


#in case you need test

TESTS =$(wildcard $(TEST)/*.c)
TESTBINS =$(patsubst $(TEST)/%.c, $(TEST)/bin/%, $(TESTS))

#tell the shell that it does not need to worry about making file they are just commands(.PHONY all)

all:$(OBJSdir) $(LIBS) $(TARGETNAME)

test:

create:
	mkdir $(TEST)
	mkdir $(TEST)/bin
	mkdir $(TEMPLATEdir)
	mkdir $(OBJSdir)
	mkdir $(SRCdir)
	mkdir $(LIBSdir)
	mkdir $(INCdir)
	touch $(TEMPLATEdir)/$(TEMPLATEfile).txt
	echo $(DefaultTempalte) >> $(TEMPLATEdir)/$(TEMPLATEfile).txt	
	cat $(TEMPLATEdir)/$(TEMPLATEfile).txt >> $(SRCdir)/$(TARGETNAME).c

#echo $(MainTempalte) >> $(SRCdir)/$(TARGETNAME).c	

#region Assembly Configuration 

#region assembly code generator				#.......... if you want assembly script for your code
# main: $(SRCS)								
# 	$(CC) $(CFLAGS) -S $(ASMFLAGS) $^
#end region

#region assembly exe builder				#.......... if you want to ru your assembly
# asmEXE: $(ASM_SRCS)
# 	$(CC) $(CFLAGS) -o $@ $^
#end region

#end region 

$(LIBS): $(OBJS)
	$(AR) $@ $(OBJS)
	$(RANLIB) $@

# doit:
# 	$(foreach var,$(FILENAMES),ar -r lib/$(var).a obj/$(var).o)

$(OBJSdir)/%.o: $(SRCdir)/%.c
	$(CC) $(CFLAGS) -I $(INCdir) -c $^ -o $@

$(TARGETNAME): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ -L ./$(LIBSdir)/ $(LIBSNAMES)

$(TEST)/bin/%: $(TEST)/%.c
	$(CC) $(CFLAGS) $< $(OBJS) -o $@ -lcriterion




# -include $(SRCS:%.c=%.d)

clean:
	rm -rf $(OBJSdir)/*
	rm -rf $(LIBSdir)/*
	rm ./$(TARGETNAME)