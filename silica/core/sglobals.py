#@+leo-ver=5-thin
#@+node:peckj.20131218082219.4105: * @file sglobals.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131218082219.4106: ** << imports >>
## important note:
## any modules that import sg must use deferred imports
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131218082219.4107: ** << declarations >>
pitchnames = ['C', 'V', 'D', 'W', 'E', 'F', 'X', 'G', 'Y', 'A', 'Z', 'B']

modetable = {}
scaletable = {}
instrumenttable = {}
namespacetable = {}
tokentable = {}

note = None
parser = None
repl = None

exit = False
silica_version = 'pre-alpha'
#@-<< declarations >>

#@+others
#@+node:peckj.20131219081918.4217: ** initialization
#@+node:peckj.20131219081918.4218: *3* initialize
def initialize():
  init_create_note()
  init_create_parser()
  init_create_repl()
  
  # defaults
  init_create_primitives()
  init_create_metacommands()
#@+node:peckj.20131219081918.4219: *4* init_create_note # stub
def init_create_note():
  global note
  from silica.core.note import Note
  ## temporary
  # create C-MAJOR scale
  new_mode('MAJOR', [2,2,1,2,2,2,1])
  new_scale('C-MAJOR', get_mode('MAJOR'), 'C')

  # create note and play around with it  
  n = Note()
  note = n
#@+node:peckj.20131219081918.4281: *4* init_create_parser
def init_create_parser():
  global parser
  from silica.core.parser import Parser
  parser = Parser()
#@+node:peckj.20131219081918.4282: *4* init_create_repl
def init_create_repl():
  global repl
  from silica.ui.repl import REPL
  repl = REPL()
#@+node:peckj.20131221180451.4202: *4* init_create_primitives
def init_create_primitives():
  new_primitive('play', 'Plays the note with the current state.', lambda sg: sg.note.play())
  new_primitive('rest', 'Rests the note for the current duration.', lambda sg: sg.note.rest())
  new_primitive('rp', 'Raises the pitch of the note by one scale degree.', lambda sg: sg.note.rp())
  new_primitive('lp', 'Lowers the pitch of the note by one scale degree.', lambda sg: sg.note.lp())
  new_primitive('cp', 'Stochastically applies either RP or LP.', lambda sg: sg.note.cp())
  new_primitive('x2', 'Expands the current duration by a factor of 2.', lambda sg: sg.note.x2())
  new_primitive('x3', 'Expands the current duration by a factor of 3.', lambda sg: sg.note.x3())
  new_primitive('x5', 'Expands the current duration by a factor of 5.', lambda sg: sg.note.x5())
  new_primitive('x7', 'Expands the current duration by a factor of 7.', lambda sg: sg.note.x7())
  new_primitive('s2', 'Shrinks the current duration by a factor of 2.', lambda sg: sg.note.s2())
  new_primitive('s3', 'Shrinks the current duration by a factor of 3.', lambda sg: sg.note.s3())
  new_primitive('s5', 'Shrinks the current duration by a factor of 5.', lambda sg: sg.note.s5())
  new_primitive('s7', 'Shrinks the current duration by a factor of 7.', lambda sg: sg.note.s7())
  new_primitive('maxvol', 'Sets the volume to the maximum (16000).', lambda sg: sg.note.maxvol())
  new_primitive('minvol', 'Sets the volume to the minimum (0).', lambda sg: sg.note.minvol())
  new_primitive('midvol', 'Sets the volume to a mid-range value (8000).', lambda sg: sg.note.midvol())
  new_primitive('startvol', 'Sets the volume to the starting value (12000).', lambda sg: sg.note.startvol())
  new_primitive('incvol', 'Increments the volume by 1000.', lambda sg: sg.note.incvol())
  new_primitive('incvol1', 'Increments the volume by 100.', lambda sg: sg.note.incvol1())
  new_primitive('decvol', 'Decrements the volume by 1000.', lambda sg: sg.note.decvol())
  new_primitive('decvol1', 'Decrements the volume by 100.', lambda sg: sg.note.decvol1())
  new_primitive('maxtempo', 'Sets the tempo to the maximum (400 bpm).', lambda sg: sg.note.maxtempo())
  new_primitive('mintempo', 'Sets the tempo to the minimum (20 bpm).', lambda sg: sg.note.mintempo())
  new_primitive('midtempo', 'Sets the tempo to a mid-range value (190 bpm).', lambda sg: sg.note.midtempo())
  new_primitive('starttempo', 'Sets the tempo to the starting value (120 bpm).', lambda sg: sg.note.starttempo())
  new_primitive('doubletempo', 'Doubles the tempo.', lambda sg: sg.note.doubletempo())
  new_primitive('tripletempo', 'Triples the tempo.', lambda sg: sg.note.tripletempo())
  new_primitive('halftempo', 'Halves the tempo.', lambda sg: sg.note.halftempo())
  new_primitive('thirdtempo', 'Thirds the tempo.', lambda sg: sg.note.thirdtempo())
  new_primitive('inctempo', 'Increments the tempo by 10 bpm.', lambda sg: sg.note.inctempo())
  new_primitive('inctempo1', 'Increments the tempo by 1 bpm.', lambda sg: sg.note.inctempo1())
  new_primitive('dectempo', 'Decrements the tempo by 10 bpm.', lambda sg: sg.note.dectempo())
  new_primitive('dectempo1', 'Decrements the tempo by 1 bpm.', lambda sg: sg.note.dectempo1())
  
  ## NOT YET IMPLEMENTED
  #new_primitive('pushstate', 'Pushes the current state of the note onto the statestack.', lambda sg: sg.note.pushstate())
  #new_primitive('popstate', 'Pops the top state off the statestack and applies it to the note.', lambda sg: sg.note.popstate())
  #new_primitive('removestate', 'Removes the top state off the statestack without applying it to the note.', lambda sg: sg.note.removestate())
  #new_primitive('popalphabet', 'Attempts to relatively pop and plly the top alphabet from the scalestack.', lambda sg: sg.note.popalphabet(relative=True))
  #new_primitive('popalphabet$', 'Absolutely pops the top alphabet from the scalestack.', lambda sg: sg.note.popalhpabet())
#@+node:peckj.20131222154620.7091: *4* init_create_metacommands
def init_create_metacommands():
  def exit(sg):
    sg.exit = True
    return 'Goodbye!'
  new_metacommand('-exit', 'Exits silica.', exit)
  
  def state(sg):
    return str(sg.note)
  new_metacommand('-state', 'Prints the state of the note.', state)

  def reset(sg):
    sg.note.reset()
    return 'Note state has been reset.'
  new_metacommand('-reset', 'Resets the state of the note.', reset)
#@+node:peckj.20131218082219.4108: ** lookup methods
#@+node:peckj.20131218082219.4109: *3* get_mode
def get_mode(name):
  return modetable.get(name,None)
#@+node:peckj.20131218082219.4110: *3* get_scale
def get_scale(name):
  return scaletable.get(name,None)
#@+node:peckj.20131218082219.4111: *3* get_instrument # stub
#@+node:peckj.20131218082219.4112: *3* get_namespace # stub
#@+node:peckj.20131218082219.4113: *3* get_token # stub
#@+node:peckj.20131218082219.4114: *3* load_module # stub
#@+node:peckj.20131219081918.4210: ** creation methods
#@+node:peckj.20131219081918.4211: *3* new_mode
def new_mode(name, intervals):
  from silica.core.mode import Mode
  m = Mode(name, intervals)
  modetable[name] = m
  return m
  
#@+node:peckj.20131219081918.4212: *3* new_scale
def new_scale(name, mode, tonic):
  from silica.core.scale import Scale
  s = Scale(name, mode, tonic)
  scaletable[name] = s
  return s
#@+node:peckj.20131221180451.4201: *3* new_primitive
def new_primitive(name, desc, behavior):
  from silica.core.primitive import Primitive
  p = Primitive(name.upper(), desc, behavior)
  tokentable[name.lower()] = (p, 'primitive')
#@+node:peckj.20131222154620.7088: *3* new_metacommand
def new_metacommand(name, desc, behavior):
  from silica.core.metacommand import MetaCommand
  m = MetaCommand(name.upper(), desc, behavior)
  tokentable[name.lower()] = (m, 'metacommand')
#@+node:peckj.20131219081918.4213: *3* new_instrument # stub
#@+node:peckj.20131219081918.4214: *3* new_namespace # stub
#@+node:peckj.20131219081918.4215: *3* new_token # stub
#@-others
#@-leo
