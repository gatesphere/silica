// silica programming language
// Jacob M. Peck
// Instrument proto

if(?REPL_DEBUG, writeln("  + Loading Instrument.io"))

silica Instrument := silica Entity clone do(
  with := method(name,
    self clone setName(name)
  )
  
  asString := method(
    "< INSTRUMENT " .. self name .. " >"
  )
)

silica InstrumentTable := silica EntityTable clone do(
  clone := method(self)
  new := method(name,
    self table atIfAbsentPut(name, silica Instrument with(name))
  )
  
  asString := method(
    "< INSTRUMENTTABLE >"
  )
)

if(?REPL_DEBUG, writeln("    + Initializing the standard pitched instruments"))
list(
  // piano
  "PIANO",
  "BRIGHT_ACOUSTIC",
  "ELECTRIC_GRAND",
  "HONKEY_TONK",
  "ELECTRIC_PIANO",
  "ELECTRIC_PIANO_2",
  "HARPISCHORD",
  "CLAVINET",

  // chromatic percussion
  "CELESTA",
  "GLOCKENSPIEL",
  "MUSIC_BOX",
  "VIBRAPHONE",
  "MARIMBA",
  "XYLOPHONE",
  "BELLS",
  "DULCIMER",

  // organ
  "DRAWBAR_ORGAN",
  "PERCUSSIVE_ORGAN",
  "ROCK_ORGAN",
  "CHURCH_ORGAN",
  "REED_ORGAN",
  "ACCORDIAN",
  "HARMONICA",
  "TANGO_ACCORDIAN",

  // guitar
  "GUITAR",
  "STEEL_STRING_GUITAR",
  "ELECTRIC_JAZZ_GUITAR",
  "ELECTRIC_CLEAN_GUITAR",
  "ELECTRIC_MUTED_GUITAR",
  "OVERDRIVEN_GUITAR",
  "DISTORTION_GUITAR",
  "GUITAR_HARMONICS",

  // bass
  "ACOUSTIC_BASS",
  "ELECTRIC_BASS_FINGER",
  "ELECTRIC_BASS_PICK",
  "FRETLESS_BASS",
  "SLAP_BASS",
  "SLAP_BASS_2",
  "SYNTH_BASS",
  "SYNTH_BASS_2",

  // strings
  "VIOLIN",
  "VIOLA",
  "CELLO",
  "CONTRABASS",
  "TREMOLO_STRINGS",
  "PIZZICATO_STRINGS",
  "ORCHESTRAL_STRINGS",
  "TIMPANI",

  // ensemble
  "STRING_ENSEMBLE_1",
  "STRING_ENSEMBLE_2",
  "SYNTH_STRINGS",
  "SYNTH_STRINGS_2",
  "CHOIR_AAHS",
  "VOICE_OOHS",
  "SYNTH_VOICE",
  "ORCHESTRA_HIT",

  // brass
  "TRUMPET",
  "TROMBONE",
  "TUBA",
  "MUTED_TRUMPET",
  "FRENCH_HORN",
  "BRASS",
  "SYNTH_BRASS_1",
  "SYNTH_BRASS_2",

  // reed
  "SOPRANO_SAX",
  "ALTO_SAX",
  "TENOR_SAX",
  "BARITONE_SAX",
  "OBOE",
  "ENGLISH_HORN",
  "BASSOON",
  "CLARINET",

  // pipe
  "PICCOLO",
  "FLUTE",
  "RECORDER",
  "PANFLUTE",
  "BLOWN_BOTTLE",
  "SKAKUHACHI",
  "WHISTLE",
  "OCARINA",

  // synth lead
  "SQUARE",
  "SAWTOOTH",
  "CALLIOPE",
  "CHIFF",
  "CHARANG",
  "VOICE",
  "FIFTHS",
  "BASSLEAD",

  // synth pad
  "NEW_AGE",
  "WARM",
  "POLYSYNTH",
  "CHOIR",
  "BOWED",
  "METALLIC",
  "HALO",
  "SWEEP",

  // synth effects

  "RAIN",
  "SOUNDTRACK",
  "CRYSTAL",
  "ATMOSPHERE",
  "BRIGHTNESS",
  "GOBLINS",
  "ECHOES",
  "SCI-FI",

  // ethnic
  "SITAR",
  "BANJO",
  "SHAMISEN",
  "KOTO",
  "KALIMBA",
  "BAGPIPE",
  "FIDDLE",
  "SHANAI",

  // tuned percussive
  "TINKLE_BELL",
  "AGOGO",
  "STEEL_DRUMS",
  "WOODBLOCK",
  "TAIKO_DRUM",
  "MELODIC_TOM",
  "SYNTH_DRUM",
  "REVERSE_CYMBAL",

  // sound effects
  "GUITAR_FRET_NOISE",
  "BREATH_NOISE",
  "SEASHORE",
  "BIRD_TWEET",
  "TELEPHONE",
  "HELICOPTER",
  "APPLAUSE",
  "GUNSHOT"
) foreach(inst,
  silica InstrumentTable new(inst)
)
