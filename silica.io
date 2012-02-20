#!/usr/bin/env io

// silica programming language
// Jacob M. Peck
// silica runner

// if run as a script, this will not be nil, but a file
SCRIPT_FILE := System args at(1)

// load libraries
doFile("lib/io-symbols.io")

// run silica
doFile("silica_main.io")
