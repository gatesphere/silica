#@+leo-ver=5-thin
#@+node:peckj.20140106082417.4653: * @file instrumentchanger.py
#@@language python

#@+<< imports >>
#@+node:peckj.20140106082417.4654: ** << imports >>
import silica.core.sglobals as sg
from silica.core.entity import Entity
#@-<< imports >>

#@+others
#@+node:peckj.20140106082417.4655: ** class InstrumentChanger
class InstrumentChanger(Entity):
  #@+others
  #@+node:peckj.20140106082417.4656: *3* __init__
  def __init__(self, name, desc, behavior):
    super(self.__class__,self).__init__(name, desc)
    self.behavior = behavior
  #@+node:peckj.20140106082417.4657: *3* execute
  def execute(self):
    return self.behavior(sg)
  #@+node:peckj.20140106082417.4658: *3* __str__
  def __str__(self):
    return "< INSTRUMENTCHANGER " + self.name + " >"
  #@-others
#@-others
#@-leo
