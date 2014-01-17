#@+leo-ver=5-thin
#@+node:peckj.20131224101941.5050: * @file modules/home.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131224101941.5052: ** << imports >>
import silica.core.sglobals as sg
#@-<< imports >>

#@+others
#@+node:peckj.20131224101941.5054: ** primitives
def primitives():
  sg.new_primitive('play', 'Plays the note with the current state.', lambda sg: sg.note.play())
  sg.new_primitive('rest', 'Rests the note for the current duration.', lambda sg: sg.note.rest())
  sg.new_primitive('rp', 'Raises the pitch of the note by one scale degree.', lambda sg: sg.note.rp())
  sg.new_primitive('lp', 'Lowers the pitch of the note by one scale degree.', lambda sg: sg.note.lp())
  sg.new_primitive('cp', 'Stochastically applies either RP or LP.', lambda sg: sg.note.cp())
  sg.new_primitive('x2', 'Expands the current duration by a factor of 2.', lambda sg: sg.note.x2())
  sg.new_primitive('x3', 'Expands the current duration by a factor of 3.', lambda sg: sg.note.x3())
  sg.new_primitive('x5', 'Expands the current duration by a factor of 5.', lambda sg: sg.note.x5())
  sg.new_primitive('x7', 'Expands the current duration by a factor of 7.', lambda sg: sg.note.x7())
  sg.new_primitive('s2', 'Shrinks the current duration by a factor of 2.', lambda sg: sg.note.s2())
  sg.new_primitive('s3', 'Shrinks the current duration by a factor of 3.', lambda sg: sg.note.s3())
  sg.new_primitive('s5', 'Shrinks the current duration by a factor of 5.', lambda sg: sg.note.s5())
  sg.new_primitive('s7', 'Shrinks the current duration by a factor of 7.', lambda sg: sg.note.s7())
  sg.new_primitive('maxvol', 'Sets the volume to the maximum (16000).', lambda sg: sg.note.maxvol())
  sg.new_primitive('minvol', 'Sets the volume to the minimum (0).', lambda sg: sg.note.minvol())
  sg.new_primitive('midvol', 'Sets the volume to a mid-range value (8000).', lambda sg: sg.note.midvol())
  sg.new_primitive('startvol', 'Sets the volume to the starting value (12000).', lambda sg: sg.note.startvol())
  sg.new_primitive('incvol', 'Increments the volume by 1000.', lambda sg: sg.note.incvol())
  sg.new_primitive('incvol1', 'Increments the volume by 100.', lambda sg: sg.note.incvol1())
  sg.new_primitive('decvol', 'Decrements the volume by 1000.', lambda sg: sg.note.decvol())
  sg.new_primitive('decvol1', 'Decrements the volume by 100.', lambda sg: sg.note.decvol1())
  sg.new_primitive('maxtempo', 'Sets the tempo to the maximum (400 bpm).', lambda sg: sg.note.maxtempo())
  sg.new_primitive('mintempo', 'Sets the tempo to the minimum (20 bpm).', lambda sg: sg.note.mintempo())
  sg.new_primitive('midtempo', 'Sets the tempo to a mid-range value (190 bpm).', lambda sg: sg.note.midtempo())
  sg.new_primitive('starttempo', 'Sets the tempo to the starting value (120 bpm).', lambda sg: sg.note.starttempo())
  sg.new_primitive('doubletempo', 'Doubles the tempo.', lambda sg: sg.note.doubletempo())
  sg.new_primitive('tripletempo', 'Triples the tempo.', lambda sg: sg.note.tripletempo())
  sg.new_primitive('halftempo', 'Halves the tempo.', lambda sg: sg.note.halftempo())
  sg.new_primitive('thirdtempo', 'Thirds the tempo.', lambda sg: sg.note.thirdtempo())
  sg.new_primitive('inctempo', 'Increments the tempo by 10 bpm.', lambda sg: sg.note.inctempo())
  sg.new_primitive('inctempo1', 'Increments the tempo by 1 bpm.', lambda sg: sg.note.inctempo1())
  sg.new_primitive('dectempo', 'Decrements the tempo by 10 bpm.', lambda sg: sg.note.dectempo())
  sg.new_primitive('dectempo1', 'Decrements the tempo by 1 bpm.', lambda sg: sg.note.dectempo1())
  sg.new_primitive('popalphabet', 'Attempts to relatively pop and apply the top alphabet from the scalestack', lambda sg: sg.note.pop_alphabet(relative=True))
  sg.new_primitive('popalphabet$', 'Absolutely pops the top alphabet from the scalestack.', lambda sg: sg.note.pop_alphabet())
  sg.new_primitive('pushstate', 'Pushes the current state of the note onto the statestack.', lambda sg: sg.note.pushstate())
  sg.new_primitive('popstate', 'Pops the top state off the statestack and applies it to the note.', lambda sg: sg.note.popstate())
  sg.new_primitive('removestate', 'Removes the top state off the statestack without applying it to the note.', lambda sg: sg.note.removestate())
  # for now...
  sg.new_primitive('begingroup', 'Used to mark the beginning of a group.', lambda sg: '{')
  sg.new_primitive('endgroup', 'Used to mark the end of a group.', lambda sg: '}')
#@+node:peckj.20131224101941.5056: ** metacommands
def metacommands():
  from silica.core.silicaevent import SilicaEvent
  def exit(sg):
    sg.exit = True
    return SilicaEvent('meta',message='Goodbye!')
  sg.new_metacommand('-exit', 'Exits silica.', exit)
  
  def state(sg):
    return SilicaEvent('meta', message=str(sg.note))
  sg.new_metacommand('-state', 'Prints the state of the note.', state)

  def reset(sg):
    sg.note.reset()
    return SilicaEvent('meta', message='Note state has been reset.')
  sg.new_metacommand('-reset', 'Resets the state of the note.', reset)
#@+node:peckj.20140103121318.3960: ** modes
def modes():
  sg.new_mode('CHROMATIC', [1,1,1,1,1,1,1,1,1,1,1,1])
  sg.new_mode('DIMINISHED', [2,1,2,1,2,1,2,1])
  sg.new_mode('HALFWHOLEDIMINISHED', [1,2,1,2,1,2,1,2])
  sg.new_mode('MAJOR', [2,2,1,2,2,2,1])
  sg.new_mode('MINOR', [2,1,2,2,1,2,2])
  sg.new_mode('HARMONICMINOR', [2,1,2,2,1,3,1])
  sg.new_mode('DORIAN', [2,1,2,2,2,1,2])
  sg.new_mode('PHRYGIAN', [1,2,2,2,1,2,2])
  sg.new_mode('LYDIAN', [2,2,2,1,2,2,1])
  sg.new_mode('MIXOLYDIAN', [2,2,1,2,2,1,2])
  sg.new_mode('LOCRIAN', [1,2,2,1,2,2,2])
  sg.new_mode('WHOLETONE', [2,2,2,2,2,2])
  sg.new_mode('BLUES', [3,2,1,1,3,2])
  sg.new_mode('PENTAMAJOR', [2,2,3,2,3])
  sg.new_mode('PENTAMINOR', [3,3,2,3,2])
  sg.new_mode('MAJORTRIAD', [4,3,5])
  sg.new_mode('MINORTRIAD', [3,4,5])
  sg.new_mode('DIMINISHEDTRIAD', [3,3,6])
  sg.new_mode('AUGMENTEDTRIAD', [4,4,4])
#@+node:peckj.20140103121318.3961: ** scales
def scales():
  reldesc = 'Attempts to relatively push the scale %s onto the scalestack.'
  absdesc = 'Absolutely pushes the scale %s onto the scalestack.'
  
  for m in sg.modetable.keys():
    mode = sg.get_mode(m)
    for tonic in sg.pitchnames:
      n = '%s-%s' % (tonic, mode.name)
      sg.new_scale(n, mode, tonic)
  
  def make_scalechanger_lambda(scale, relative): 
    return lambda sg: sg.note.change_scale(scale, relative=relative)
    
  for s in sg.scaletable.keys():
    scale = sg.get_scale(s)
    sg.new_scalechanger(scale.name + '$', reldesc % scale.name, make_scalechanger_lambda(scale, True))
    sg.new_scalechanger(scale.name, absdesc % scale.name, make_scalechanger_lambda(scale, False))
#@+node:peckj.20140106082417.4661: ** instruments
def instruments():
  ilist = [
  #@+<< instrument list >>
  #@+node:peckj.20140106082417.4663: *3* << instrument list >>
  # piano
  "PIANO",
  "BRIGHT_ACOUSTIC",
  "ELECTRIC_GRAND",
  "HONKEY_TONK",
  "ELECTRIC_PIANO",
  "ELECTRIC_PIANO_2",
  "HARPISCHORD",
  "CLAVINET",

  # chromatic percussion
  "CELESTA",
  "GLOCKENSPIEL",
  "MUSIC_BOX",
  "VIBRAPHONE",
  "MARIMBA",
  "XYLOPHONE",
  "BELLS",
  "DULCIMER",

  # organ
  "DRAWBAR_ORGAN",
  "PERCUSSIVE_ORGAN",
  "ROCK_ORGAN",
  "CHURCH_ORGAN",
  "REED_ORGAN",
  "ACCORDIAN",
  "HARMONICA",
  "TANGO_ACCORDIAN",

  # guitar
  "GUITAR",
  "STEEL_STRING_GUITAR",
  "ELECTRIC_JAZZ_GUITAR",
  "ELECTRIC_CLEAN_GUITAR",
  "ELECTRIC_MUTED_GUITAR",
  "OVERDRIVEN_GUITAR",
  "DISTORTION_GUITAR",
  "GUITAR_HARMONICS",

  # bass
  "ACOUSTIC_BASS",
  "ELECTRIC_BASS_FINGER",
  "ELECTRIC_BASS_PICK",
  "FRETLESS_BASS",
  "SLAP_BASS",
  "SLAP_BASS_2",
  "SYNTH_BASS",
  "SYNTH_BASS_2",

  # strings
  "VIOLIN",
  "VIOLA",
  "CELLO",
  "CONTRABASS",
  "TREMOLO_STRINGS",
  "PIZZICATO_STRINGS",
  "ORCHESTRAL_STRINGS",
  "TIMPANI",

  # ensemble
  "STRING_ENSEMBLE_1",
  "STRING_ENSEMBLE_2",
  "SYNTH_STRINGS",
  "SYNTH_STRINGS_2",
  "CHOIR_AAHS",
  "VOICE_OOHS",
  "SYNTH_VOICE",
  "ORCHESTRA_HIT",

  # brass
  "TRUMPET",
  "TROMBONE",
  "TUBA",
  "MUTED_TRUMPET",
  "FRENCH_HORN",
  "BRASS",
  "SYNTH_BRASS_1",
  "SYNTH_BRASS_2",

  # reed
  "SOPRANO_SAX",
  "ALTO_SAX",
  "TENOR_SAX",
  "BARITONE_SAX",
  "OBOE",
  "ENGLISH_HORN",
  "BASSOON",
  "CLARINET",

  # pipe
  "PICCOLO",
  "FLUTE",
  "RECORDER",
  "PANFLUTE",
  "BLOWN_BOTTLE",
  "SKAKUHACHI",
  "WHISTLE",
  "OCARINA",

  # synth lead
  "SQUARE",
  "SAWTOOTH",
  "CALLIOPE",
  "CHIFF",
  "CHARANG",
  "VOICE",
  "FIFTHS",
  "BASSLEAD",

  # synth pad
  "NEW_AGE",
  "WARM",
  "POLYSYNTH",
  "CHOIR",
  "BOWED",
  "METALLIC",
  "HALO",
  "SWEEP",

  # synth effects
  "RAIN",
  "SOUNDTRACK",
  "CRYSTAL",
  "ATMOSPHERE",
  "BRIGHTNESS",
  "GOBLINS",
  "ECHOES",
  "SCI-FI",

  # ethnic
  "SITAR",
  "BANJO",
  "SHAMISEN",
  "KOTO",
  "KALIMBA",
  "BAGPIPE",
  "FIDDLE",
  "SHANAI",

  # tuned percussive
  "TINKLE_BELL",
  "AGOGO",
  "STEEL_DRUMS",
  "WOODBLOCK",
  "TAIKO_DRUM",
  "MELODIC_TOM",
  "SYNTH_DRUM",
  "REVERSE_CYMBAL",

  # sound effects
  "GUITAR_FRET_NOISE",
  "BREATH_NOISE",
  "SEASHORE",
  "BIRD_TWEET",
  "TELEPHONE",
  "HELICOPTER",
  "APPLAUSE",
  "GUNSHOT"
  #@-<< instrument list >>
  #@afterref
]
  for i in ilist:
    inst = sg.new_instrument(i)
    sg.new_instrumentchanger(i, 'Changes the current instrument to %s.' % i, inst)
#@+node:peckj.20131224101941.5057: ** run
def run():
  primitives()
  metacommands()
  modes()
  scales()
  instruments()
  
  ## test macros
  sg.new_macro('P', 'play')
  sg.new_macro('R', 'rest')
  sg.new_macro('HAT', 'p rp p lp p')
  sg.new_macro('STAIRS3', 'p rp p rp p rp')
  sg.new_macro('HATCMD', 'begingroup p rp p lp p endgroup')
  return True
#@-others
#@-leo
