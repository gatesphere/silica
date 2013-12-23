#@+leo-ver=5-thin
#@+node:peckj.20131222154620.7080: * @file metacommand.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131222154620.7081: ** << imports >>
import silica.core.sglobals as sg
from silica.core.entity import Entity
#@-<< imports >>

#@+others
#@+node:peckj.20131222154620.7082: ** class MetaCommand
class MetaCommand(Entity):
  #@+others
  #@+node:peckj.20131222154620.7083: *3* __init__
  def __init__(self, name, desc, behavior):
    super(self.__class__,self).__init__(name, desc)
    self.behavior = behavior
  #@+node:peckj.20131222154620.7084: *3* execute
  def execute(self):
    return self.behavior(sg)
  #@+node:peckj.20131222154620.7085: *3* __str__
  def __str__(self):
    return "< METACOMMAND " + self.name + " >"
  #@-others
#@-others
#@-leo
