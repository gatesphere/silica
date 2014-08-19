#@+leo-ver=5-thin
#@+node:peckj.20131218082219.4105: * @file sglobals.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131218082219.4106: ** << imports >>
## important note:
## any modules that import sg must use deferred imports
import os
import sys
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131218082219.4107: ** << declarations >>
pitchnames = ['C', 'V', 'D', 'W', 'E', 'F', 'X', 'G', 'Y', 'A', 'Z', 'B']

modetable = {}
scaletable = {}
instrumenttable = {}
namespacetable = {}
tokentable = {}

current_namespace = []

note = None
parser = None
repl = None

exit = False
silica_version = 'pre-alpha'
debug = False
auto_invariance = False
max_recursive_depth = 2000
#@-<< declarations >>

#@+others
#@+node:peckj.20131219081918.4217: ** initialization
#@+node:peckj.20131219081918.4218: *3* initialize
def initialize(debugmode=False):
  # debug?
  set_debug(debugmode)
  
  # load the 'home' module, which contains
  # all of the language's base primitives,
  # metacommands, modes, scales, instruments, 
  # and transforms
  
  # create the 'home' namespace
  new_namespace('home') # default
  
  # load the 'home' module
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
  new_token(name, p, 'primitive')
  return p
#@+node:peckj.20140103121318.3963: *3* new_scalechanger
def new_scalechanger(name, desc, behavior):
  from silica.core.scalechanger import ScaleChanger
  sc = ScaleChanger(name.upper(), desc, behavior)
  new_token(name, sc, 'primitive')
  return sc
#@+node:peckj.20131222154620.7088: *3* new_metacommand
def new_metacommand(name, desc, behavior):
  from silica.core.metacommand import MetaCommand
  m = MetaCommand(name.upper(), desc, behavior)
  new_token(name, m, 'metacommand')
  return m
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
  new_token(name, ic, 'primitive')
  return ic
#@+node:peckj.20140106180202.4627: *3* new_macro
def new_macro(name, value, args=None):
  from silica.core.macro import Macro
  # if debug:
    # trace('MACRO DEFINITION')
    # trace('name: %s' % name)
    # trace('value: %s' % value)
    # trace('args: %s' % args)
  m = Macro(name, value, args)
  new_token(name, m, 'macro')
  return m
#@+node:peckj.20140214082311.4234: *3* new_token
def new_token(token, value, t_type):
  ns = '::'.join(current_namespace)
  tokentable[ns][token.lower()] = (value, t_type)
#@+node:peckj.20131219081918.4214: *3* new_namespace
def new_namespace(name):
  if '::' in name:
    components = name.split('::')
  else:
    components = [name]
  for namespace in components: 
    new_namespace_name = '::'.join(current_namespace + [namespace])
    ns = tokentable.get(new_namespace_name, None)
    if ns is None:
      # namespace doesn't exist, so create it
      ns = {}
      tokentable[new_namespace_name] = ns
    current_namespace.append(namespace)
#@+node:peckj.20131218082219.4108: ** lookup methods
#@+node:peckj.20131218082219.4109: *3* get_mode
def get_mode(name):
  return modetable.get(name,None)
#@+node:peckj.20131218082219.4110: *3* get_scale
def get_scale(name):
  return scaletable.get(name,None)
#@+node:peckj.20131218082219.4111: *3* get_instrument # stub
#@+node:peckj.20131218082219.4113: *3* get_token
def get_token(token):
  # gets a token in the current namespace, recursing back if it can't find it
  ns_stack = current_namespace[:] # copy
  while len(ns_stack) > 0:
    ns_name = '::'.join(ns_stack)
    ns = tokentable[ns_name]
    tok = ns.get(token.lower(), None)
    if tok is not None:
      return tok
    ns_stack = ns_stack[:-1]
  return (None, None) # cannot find it in the current namespace chain, so it doesn't exist
#@+node:peckj.20131218082219.4114: *3* load_module
def load_module(name):
  import sys
  mod = 'modules.%s' % name
  m = __import__(mod)
  m.__dict__[name].run()
  del m
  del sys.modules[mod]
#@+node:peckj.20140307080519.11094: ** internals
#@+node:peckj.20140402084328.4750: *3* get_homedir
def get_homedir():
  return os.path.expanduser('~')
#@+node:peckj.20140307080519.11095: *3* get_autoexec
def get_autoexec():
  homedir = get_homedir()
  autoexec = os.path.join(homedir, '.silicarc')
  if os.path.isfile(autoexec): return autoexec
  return None
#@+node:peckj.20140402084328.4751: *3* get_replhistory
def get_replhistory():
  ''' return the path to the .silica_history file, whether it exists or not '''
  homedir = get_homedir()
  replhistory = os.path.join(homedir, '.silica_history')
  return replhistory
  
#@+node:peckj.20140307080519.11099: *3* set_debug
def set_debug(v):
  global debug
  debug = v
#@+node:peckj.20140307080519.11100: *3* toggle_debug
def toggle_debug():
  global debug
  debug = not debug
#@+node:peckj.20140307080519.11097: *3* trace
def trace(s):
  # print s to stderr
  s = s + '\n'
  sys.stderr.write(s)
  sys.stderr.flush()
#@-others
#@-leo
