// silica programming language
// Jacob M. Peck
// home module - modes

if(?REPL_DEBUG, writeln("    + Initializing default modes..."))

// 12-tone modes
silica ModeTable new("CHROMATIC", list(1,1,1,1,1,1,1,1,1,1,1,1))
// 8-tone modes
silica ModeTable new("DIMINISHED", list(2,1,2,1,2,1,2,1))
silica ModeTable new("HALFWHOLEDIMINISHED", list(1,2,1,2,1,2,1,2))
// 7-tone modes
silica ModeTable new("MAJOR", list(2,2,1,2,2,2,1))
silica ModeTable new("MINOR", list(2,1,2,2,1,2,2))
silica ModeTable new("HARMONICMINOR", list(2,1,2,2,1,3,1))
silica ModeTable new("DORIAN", list(2,1,2,2,2,1,2))
silica ModeTable new("PHRYGIAN", list(1,2,2,2,1,2,2))
silica ModeTable new("LYDIAN", list(2,2,2,1,2,2,1))
silica ModeTable new("MIXOLYDIAN", list(2,2,1,2,2,1,2))
silica ModeTable new("LOCRIAN", list(1,2,2,1,2,2,2))
// 6-tone modes
silica ModeTable new("WHOLETONE", list(2,2,2,2,2,2))
silica ModeTable new("BLUES", list(3,2,1,1,3,2))
// 5-tone modes
silica ModeTable new("PENTAMAJOR", list(2,2,3,2,3))
silica ModeTable new("PENTAMINOR", list(3,3,1,3,2))
// 3-tone modes (triads)
silica ModeTable new("MAJORTIRAD", list(4,3,5))
silica ModeTable new("MINORTRIAD", list(3,4,5))
silica ModeTable new("DIMINISHEDTRIAD", list(3,3,6))
silica ModeTable new("AUGMENTEDTRIAD", list(4,4,4))
