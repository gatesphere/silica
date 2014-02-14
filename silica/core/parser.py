#@+leo-ver=5-thin
#@+node:peckj.20131219081918.4285: * @file parser.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131219081918.4286: ** << imports >>
import silica.core.sglobals as sg
from silica.core.silicaevent import SilicaEvent
from silica.core.errors import SilicaNameError, SilicaGroupError
#@-<< imports >>

#@+others
#@+node:peckj.20131219081918.4288: ** class Parser
class Parser(object):
  #@+others
  #@+node:peckj.20131222154620.7072: *3* __init__
  def __init__(self):
    self.fn_table = {'primitive': self.run_primitive,
                     'metacommand': self.run_metacommand,
                     'macro': self.run_macro}
    self.mcmode = False
    self.notestate = None
  #@+node:peckj.20131222154620.7092: *3* reset_parsing_state
  def reset_parsing_state(self):
    self.mcmode = False
    self.notestate = None
  #@+node:peckj.20131221180451.4203: *3* parse_line # stub
  def parse_line(self, string, reset=True):
    if reset: self.reset_parsing_state()
    if string.startswith('-'):
      self.mcmode = True
    self.notestate = sg.note.makestate() # to recover from errors without affecting note.statestack
    #print 'parse_line: %s' % string
    toks = string.split()
    if len(toks) > 1 and toks[1] == '>>':
      # define macro!
      event = self.define_macro(toks)
      return [event]
    out = []
    for tok in toks:
      try:
        element, etype = sg.tokentable[tok.lower()]
        v = self.fn_table[etype](element)
        if v is not None:
          #print 'v(%s): %s' % (string,v)
          # v may be a list, in which case, append them all separately
          if hasattr(v, '__iter__') and not isinstance(v, basestring):
            for e in v: out.append(e)
          else: out.append(v)
      except Exception as e:
        sg.note.applystate(self.notestate) # exception occurred, the notestate must be reset
        return [SilicaEvent('exception', exception=e)] # only return the exception!
    if self.groups_are_balanced(out):
      return out
    else:
      e = SilicaGroupError('Groups are unbalanced.')
      sg.note.applystate(self.notestate)
      return [SilicaEvent('exception', exception=e)]
    return out
  #@+node:peckj.20140108090613.4237: *4* groups_are_balanced
  def groups_are_balanced(self, out):
    pushtypes = ['begingroup']
    poptypes = ['endgroup']
    
    stack = []
    for event in out:
      if event.eventtype in pushtypes: stack.append(event.eventtype)
      if event.eventtype in poptypes:
        if len(stack) > 0 and stack[-1] == pushtypes[poptypes.index(event.eventtype)]: 
          stack.pop()
        else: # trying to pop before a push!
          return False 
    return len(stack) == 0
  #@+node:peckj.20131222154620.7073: *3* run_primitive
  def run_primitive(self, p):
    if self.mcmode:
      return None
    return p.execute()
  #@+node:peckj.20140106180202.4630: *3* run_macro
  def run_macro(self, m):
    if self.mcmode:
      return None
    return self.parse_line(m.expand(), reset=False)
  #@+node:peckj.20131222154620.7090: *3* run_metacommand
  def run_metacommand(self, m):
    if self.mcmode:
      return m.execute()
    else:
      return None
  #@+node:peckj.20140123152153.4522: *3* define_macro
  def define_macro(self, toks):
    name = toks[0].upper()
    if self.valid_name(name):
      contents = " ".join(toks[2:])
      sg.new_macro(name, contents)
      return SilicaEvent('macro_def', message='Macro %s defined.' % name)
    else:
      ex = SilicaNameError('The name %s is invalid in this context.' % name)
      return SilicaEvent('exception', exception=ex)
  #@+node:peckj.20140123152153.4523: *4* valid_name # stub
  def valid_name(self, name):
    forbidden_chars = ['(', ')', ':', '=', '+', '-', ',', '>>']
    for c in forbidden_chars:
      if c in name:
        return False
    element, etype = sg.tokentable.get(name.lower(), (None, None))
    if element and etype in ['primitive', 'metacommand', 'transform']:
      return False
    return True
  #@-others
#@+node:peckj.20140124085532.3988: ** class ParserNew # stub
# this class will eventually be a proper parser, if the original parser is too slow
class ParserNew(object):
  #@+others
  #@+node:peckj.20140124085532.3989: *3* __init__
  def __init__(self):
    pass
  #@-others
#@-others
#@-leo
