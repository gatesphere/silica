#@+leo-ver=5-thin
#@+node:peckj.20131219081918.4285: * @file parser.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131219081918.4286: ** << imports >>
import silica.core.sglobals as sg
from silica.core.silicaevent import SilicaEvent
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
    return out
  #@+at
  #   out = ' '.join(out)
  #   if self.groups_are_balanced(out):
  #     return out
  #   else:
  #     sg.note.applystate(self.notestate)
  #     return 'Error: groups not fully balanced.'
  #@+node:peckj.20140108090613.4237: *4* groups_are_balanced
  def groups_are_balanced(self, out):
    pushchars = ['{']
    popchars = ['}']
    stack = []
    for c in out:
      if c in pushchars: stack.append(c)
      if c in popchars and stack[-1] == pushchars[popchars.index(c)]: stack.pop()
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
  #@-others
#@-others
#@-leo
