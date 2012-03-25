#!/usr/bin/env io

// silica programming language
// Jacob M. Peck
// silica runner

////////////////////////////////////////////////////////////////////////////////
// File: Globals
//
// Globally available variables

// Group: Variables
/* Topic: Variables
 * SCRIPT_FILE - the script file provided to silica on the command line
 * SILICA_DIR - an environment variable, pointing to the location of the silica directory
 * AUTOEXEC - a path to the autoexec file, if it exists
 * SILICA_VERSION - the version number
 * REPL_MAX_RECURSIVE_DEPTH - how deep the parser will go before bailing
 * REPL_RELOAD - whether to reload the language on exit
 * REPL_LOAD_HISTORY - whether to load the history on startup
 * REPL_AUTOINVARIANT - whether or not auto-invariance mode is enabled
 * REPL_SIREN_ENABLED - whether or not to read and write to siren
 * REPL_DEBUG - whether or not to print textual debugging info
 * silica exit - whether or not to exit the REPL loop after the current command
 */

// if run as a script, this will not be nil, but a file
SCRIPT_FILE := System args at(1)

// if run from outside the silica directory, this is important
SILICA_DIR := nil
if(System getEnvironmentVariable("SILICA_DIR") == nil,
  writeln("WARNING: Environment variable SILICA_DIR not set.\nSane behavior cannot be guaranteed.\n")
  ,
  SILICA_DIR = Path absolute(System getEnvironmentVariable("SILICA_DIR"))
)

// autoexec file?
AUTOEXEC := nil
if(SILICA_DIR != nil,
  AUTOEXEC = Path with(SILICA_DIR, "autoexec.silica")
)

// load the language
if(SILICA_DIR != nil,
  doFile(Path with(SILICA_DIR, "lib/io-symbols.io"))
  doFile(Path with(SILICA_DIR, "silica_main.io"))
  ,
  doFile("lib/io-symbols.io")
  doFile("silica_main.io")
)
