#!/usr/bin/env io

// silica programming language
// Jacob M. Peck
// silica runner

// if run as a script, this will not be nil, but a file
SCRIPT_FILE := System args at(1)

// if run from outside the silica directory, this is important
SILICA_DIR := nil
if(System getEnvironmentVariable("SILICA_DIR") == nil,
  writeln("WARNING: Environment variable SILICA_DIR not set.\nSane behavior cannot be guaranteed.\n")
  ,
  SILICA_DIR = Path absolute(System getEnvironmentVariable("SILICA_DIR"))
)


if(SILICA_DIR != nil,
  doFile(Path with(SILICA_DIR, "lib/io-symbols.io"))
  doFile(Path with(SILICA_DIR, "silica_main.io"))
  ,
  doFile("lib/io-symbols.io")
  doFile("silica_main.io")
)
