#@+leo-ver=5-thin
#@+node:peckj.20131218082219.4117: * @file mode.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131218082219.4118: ** << imports >>
from silica.core.entity import Entity
import silica.core.sglobals as sg
#@-<< imports >>

#@+others
#@+node:peckj.20131218082219.4120: ** class Mode
class Mode(Entity):
  #@+others
  #@+node:peckj.20131218082219.4122: *3* __init__
  def __init__(self, name, intervals):
    desc = '%s Mode' % name
    super(self.__class__,self).__init__(name, desc)
    self.name = name
    self.intervals = intervals
  #@+node:peckj.20131218082219.4124: *3* __str__
  def __str__(self):
    '< MODE ' + self.name.upper() + ' >'
  #@+node:peckj.20131218082219.4125: *3* __repr__
  def __repr__(self):
    return 'Mode(%s,%s)' % (self.name, self.intervals)
  #@+node:peckj.20131218082219.4123: *3* __len__
  def __len__(self):
    return len(self.intervals)
  #@-others
#@-others
#@-leo
