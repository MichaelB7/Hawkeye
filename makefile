#!/bin/bash

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
EXE= $(current_dir:.d=)

DEFINES=  -D MACOSX -D TB
CC=gcc-mp-4.8
 
OBJECTS=src/Hawkeye.cpp src/tbprobe.cpp

CXXFLAGS= $(DEFINES)  -pipe -fomit-frame-pointer -Ofast -Wno-array-bounds  -march=corei7 -msse4.2 --param max-inline-insns-auto=600 --param inline-min-speedup=5 -funsafe-loop-optimizations  -pthread -fprofile-generate

CXXFLAGS-R= $(DEFINES) -pipe -fomit-frame-pointer -flto -Ofast -march=corei7 -msse4.2 --param max-inline-insns-auto=100 --param inline-min-speedup=25 -funsafe-loop-optimizations  -Wno-coverage-mismatch -pthread -fprofile-use -fprofile-correction

STRIP=strip

clean:
	rm -f src/*.o *.gcda *.gcno

g-pro:
	rm -f src/*.o *.gcda *.gcno
	$(CC) $(CXXFLAGS) $(OBJECTS)   -o $(EXE)

g-rel:
	rm -f src/*.o
	$(CC) $(CXXFLAGS-R) $(OBJECTS) -o $(EXE)
	$(STRIP) $(EXE)
	/Applications/Upx/upx2 --lzma $(EXE)
	cp $(EXE) /Users/michaelbyrne/cluster.mfb



## to build PGO Build for the Mac:
## have the makefile above the source direcotry
## move the files in the syzygy folder to the src folder
## e.g., path might be /sources/hawkeye/hawkeye-1.01.d/src
## makefile will name the exe "hawkeye-1.01."
## adjust defines/flags as neccessary , you might want to change CC to gcc ,i.e, "CC=gcc" w/o quotes
## type "g-pro" w/o quotes
## start hawkeye at the command prompt
## go depth 16
## quit
## type "g-rel" w/o quotes
## take out the upx2 line if you don't have upx2 ( exe compressor)
## please do not ask me how to compile for windows or linux - not my thing...
## I left the old gull makefiles intact, they may be usefull, I'm not sure 




