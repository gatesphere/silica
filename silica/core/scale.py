#@+leo-ver=5-thin
#@+node:peckj.20131218082219.4095: * @file scale.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131218082219.4096: ** << imports >>
from silica.core.entity import Entity
import silica.core.sglobals as sg
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131218082219.4097: ** << declarations >>
#@-<< declarations >>

#@+others
#@+node:peckj.20131218082219.4098: ** class Scale
class Scale(Entity):
  #@+others
  #@+node:peckj.20131218082219.4129: *3* initializers
  #@+node:peckj.20131218082219.4103: *4* __init__
  def __init__(self, name, mode, tonic):
    desc = '%s-%s Scale' % (mode.name, tonic)
    super(self.__class__,self).__init__(name, desc)
    self.mode = mode
    self.tonic = tonic
    self.pitchnames = None # set by the call following this
    self.generate_pitchnames()
  #@+node:peckj.20131218082219.4104: *4* generate_pitchnames
  def generate_pitchnames(self):
    pn = [self.tonic]
    pos = sg.pitchnames.index(self.tonic)
    last = self.mode.intervals[:-1]
    for i in last:
      pos = pos + i
      if pos >= len(sg.pitchnames):
        pos = pos - len(sg.pitchnames)
      pn.append(sg.pitchnames[pos])
    self.pitchnames = pn
  #@+node:peckj.20131218082219.4130: *3* reporting
  #@+node:peckj.20131218082219.4126: *4* __len__
  def __len__(self):
    return len(self.mode)
  #@+node:peckj.20131218082219.4133: *4* __str__
  def __str__(self):
    return '< SCALE ' + self.name.upper() + ' >'
  #@+node:peckj.20131218082219.4134: *4* __repr__
  def __repr__(self):
    return 'Scale(%s,%s,%s)' % (self.name, self.mode, self.tonic)
  #@+node:peckj.20131218082219.4127: *4* get_name_for_degree
  def get_name_for_degree(self, degree):
    return self.pitchnames[degree-1]
  #@+node:peckj.20131218082219.4128: *4* get_degree_for_name
  def get_degree_for_name(self, name):
    try:
      pos = self.pitchnames.index(name)
      return pos+1
    except:
      return None
  #@+node:peckj.20131218082219.4131: *4* get_offset_from_c
  def get_offset_from_c(self):
    pos = sg.pitchnames.index(self.tonic)
    if pos > len(sg.pitchnames) / 2:
      pos = pos - len(sg.pitchnames)
    return pos
  #@+node:peckj.20131218082219.4132: *4* get_midi_octave
  def get_midi_octave(self, orig, pitch):
    offset = self.get_offset_from_c()
    lower = sg.pitchnames[0:offset]
    higher = sg.pitchnames[offset:]
    if offset < 0 and pitch in higher:
      return orig - 1
    elif offset > 0 and pitch in lower:
      return orig + 1
    else:
      return orig
  #@-others
#@-others
#@-leo
