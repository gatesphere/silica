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
  # load the 'home' module, which contains
  # all of the language's base primitives,
  # metacommands, modes, scales, instruments, 
  # and transforms
  load_module('home') # located in ../modules/home.py

  # next, initialize the proper values
  init_create_note()
  init_create_parser()
  init_create_repl()
  

#@+node:peckj.20131219081918.4219: *4* init_create_note # stub
def init_create_note():
  global note
  from silica.core.note import Note

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
#@+node:peckj.20131218082219.4114: *3* load_module
def load_module(name):
  import sys
  mod = 'modules.%s' % name
  m = __import__(mod)
  m.__dict__[name].run()
  del m
  del sys.modules[mod]
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
#@+node:peckj.20140103121318.3963: *3* new_scalechanger
def new_scalechanger(name, desc, behavior):
  from silica.core.scalechanger import ScaleChanger
  sc = ScaleChanger(name.upper(), desc, behavior)
  tokentable[name.lower()] = (sc, 'primitive') # scale changers are executed just like primitives
#@+node:peckj.20131222154620.7088: *3* new_metacommand
def new_metacommand(name, desc, behavior):
  from silica.core.metacommand import MetaCommand
  m = MetaCommand(name.upper(), desc, behavior)
  tokentable[name.lower()] = (m, 'metacommand')
#@+node:peckj.20140106082417.4662: *3* new_instrument
def new_instrument(name):
  from silica.core.instrument import Instrument
  i = Instrument(name)
  instrumenttable[name] = i
  return i
#@+node:peckj.20131219081918.4213: *3* new_instrumentchanger
def new_instrumentchanger(name, desc, instrument):
  from silica.core.instrumentchanger import InstrumentChanger
  behavior = lambda sg: sg.note.change_instrument(instrument)
  ic = InstrumentChanger(name.upper(), desc, behavior)
  tokentable[name.lower()] = (ic, 'primitive') # instrument changers are executed just like primitives
#@+node:peckj.20131219081918.4214: *3* new_namespace # stub
#@-others
#@-leo
