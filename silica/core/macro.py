#@+leo-ver=5-thin
#@+node:peckj.20140106180202.4620: * @file macro.py
#@@language python

#@+<< imports >>
#@+node:peckj.20140106180202.4621: ** << imports >>
import silica.core.sglobals as sg
from silica.core.entity import Entity
#@-<< imports >>

#@+others
#@+node:peckj.20140106180202.4622: ** class Macro
class Macro(Entity):
  #@+others
  #@+node:peckj.20140106180202.4623: *3* __init__
  def __init__(self, name, value):
    desc = "Macro %s" % name
    super(self.__class__,self).__init__(name, desc)
    self.value = value
  #@+node:peckj.20140106180202.4626: *3* expand
  def expand(self):
    return self.value
  #@+node:peckj.20140106180202.4625: *3* __str__
  def __str__(self):
    return "< MACRO " + self.name + " >"
  #@-others
#@-others
#@-leo
