#@+leo-ver=5-thin
#@+node:peckj.20131218082219.4088: * @file Note.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131218082219.4089: ** << imports >>
import silica.core.Globals as sg
import random
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131218082219.4090: ** << declarations >>
#@-<< declarations >>

#@+others
#@+node:peckj.20131218082219.4091: ** class Note
class Note:
  #@+others
  #@+node:peckj.20131218082219.4092: *3* __init__
  def __init__(self):
    self.reset()
  #@+node:peckj.20131218082219.4093: *3* reset
  def reset(self):
    ''' reset all ivars to default values '''
    self.scale = [sg.get_scale('C-MAJOR')]
    self.degree = 1
    self.duration = 1
    self.register = 5
    self.prevregister = 5
    self.volume = 12000
    self.tempo = 120
    self.instrument = None # replace with PIANO
    self.deltadegree = 'same'
    self.statestack = None
  #@+node:peckj.20131218082219.4135: *3* primitives
  #@+node:peckj.20131218082219.4094: *4* rp
  def rp(self):
    new = self.degree + 1
    if new == len(self.scale[-1]):
      new = 1
      if self.register < 9: 
        self.register = self.register + 1
    self.degree = new
    self.deltadegree = 'raise'
    return None
  #@+node:peckj.20131218082219.4136: *4* lp
  def rp(self):
    new = self.degree - 1
    if new == 0:
      new = len(self.scale[-1])
      if self.register > 0: 
        self.register = self.register - 1
    self.degree = new
    self.deltadegree = 'lower'
    return None
  #@+node:peckj.20131218082219.4137: *4* cp
  def cp(self):
    random.choice([self.lp,self.rp])() ## tricksy tricksy
  #@-others
#@-others
#@-leo
