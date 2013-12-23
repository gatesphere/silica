#@+leo-ver=5-thin
#@+node:peckj.20131219081918.4285: * @file parser.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131219081918.4286: ** << imports >>
import silica.core.sglobals as sg
#@-<< imports >>

#@+others
#@+node:peckj.20131219081918.4288: ** class Parser
class Parser(object):
  #@+others
  #@+node:peckj.20131222154620.7072: *3* __init__
  def __init__(self):
    self.fn_table = {'primitive': self.run_primitive,
                     'metacommand': self.run_metacommand}
    self.mcmode = False
  #@+node:peckj.20131222154620.7092: *3* reset_parsing_state
  def reset_parsing_state(self):
    self.mcmode = False
  #@+node:peckj.20131221180451.4203: *3* parse_line # stub
  def parse_line(self, string):
    self.reset_parsing_state()
    if string.startswith('-'):
      self.mcmode = True
    toks = string.split()
    out = []
    for tok in toks:
      element, etype = sg.tokentable[tok.lower()]
      v = self.fn_table[etype](element)
      if v is not None:
        out.append(v)
    out = ' '.join(out)
    return out
  #@+node:peckj.20131222154620.7073: *3* run_primitive
  def run_primitive(self, p):
    if self.mcmode:
      return None
    return p.execute()
  #@+node:peckj.20131222154620.7090: *3* run_metacommand
  def run_metacommand(self, m):
    if self.mcmode:
      return m.execute()
    else:
      return None
  #@-others
#@-others
#@-leo
