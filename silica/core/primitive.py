#@+leo-ver=5-thin
#@+node:peckj.20131221114825.4521: * @file primitive.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131221114825.4522: ** << imports >>
import silica.core.sglobals as sg
from silica.core.entity import Entity
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131221114825.4523: ** << declarations >>
#@-<< declarations >>

#@+others
#@+node:peckj.20131221114825.4524: ** class Primitive
class Primitive(Entity):
  #@+others
  #@+node:peckj.20131221114825.4525: *3* __init__
  def __init__(self, name, desc, behavior):
    super(self.__class__,self).__init__(name, desc)
    self.behavior = behavior
  #@+node:peckj.20131221180451.4199: *3* execute
  def execute(self):
    return self.behavior(sg)
  #@+node:peckj.20131221180451.4200: *3* __str__
  def __str__(self):
    return "< PRIMITIVE " + self.name + " >"
  #@-others
#@-others
#@-leo
