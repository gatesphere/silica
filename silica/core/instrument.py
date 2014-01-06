#@+leo-ver=5-thin
#@+node:peckj.20140106082417.4641: * @file instrument.py
#@@language python

#@+<< imports >>
#@+node:peckj.20140106082417.4642: ** << imports >>
from silica.core.entity import Entity
#@-<< imports >>

#@+others
#@+node:peckj.20140106082417.4643: ** class Instrument
class Instrument(Entity):
  #@+others
  #@+node:peckj.20140106082417.4644: *3* __init__
  def __init__(self, name):
    desc = 'Instrument: %s' % name
    super(self.__class__,self).__init__(name, desc)
  #@+node:peckj.20140106082417.4645: *3* __str__
  def __str__(self):
    return '< INSTRUMENT ' + self.name.upper() + ' >'
  #@+node:peckj.20140106082417.4646: *3* __repr__
  def __repr__(self):
    return 'Instrument(%s)' % (self.name)
  #@-others
#@-others
#@-leo
