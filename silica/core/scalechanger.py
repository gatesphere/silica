#@+leo-ver=5-thin
#@+node:peckj.20140103121318.3954: * @file scalechanger.py
#@@language python

#@+<< imports >>
#@+node:peckj.20140103121318.3955: ** << imports >>
import silica.core.sglobals as sg
from silica.core.entity import Entity
#@-<< imports >>

#@+others
#@+node:peckj.20140103121318.3956: ** class ScaleChanger
class ScaleChanger(Entity):
  #@+others
  #@+node:peckj.20140103121318.3957: *3* __init__
  def __init__(self, name, desc, behavior):
    super(self.__class__,self).__init__(name, desc)
    self.behavior = behavior
  #@+node:peckj.20140103121318.3958: *3* execute
  def execute(self):
    return self.behavior(sg)
  #@+node:peckj.20140103121318.3959: *3* __str__
  def __str__(self):
    return "< SCALECHANGER " + self.name + " >"
  #@-others
#@-others
#@-leo
