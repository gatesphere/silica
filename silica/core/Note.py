#@+leo-ver=5-thin
#@+node:peckj.20131218082219.4088: * @file note.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131218082219.4089: ** << imports >>
import silica.core.sglobals as sg
import random
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131218082219.4090: ** << declarations >>
#@-<< declarations >>

#@+others
#@+node:peckj.20131218082219.4091: ** class Note
class Note(object):
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
  #@+node:peckj.20131219081918.4168: *4* pitches
  #@+node:peckj.20131218082219.4094: *5* rp
  def rp(self):
    new = self.degree + 1
    if new == len(self.scale[-1]) + 1:
      new = 1
      if self.register < 9: 
        self.register = self.register + 1
    self.degree = new
    self.deltadegree = 'raise'
    return None
  #@+node:peckj.20131218082219.4136: *5* lp
  def lp(self):
    new = self.degree - 1
    if new == 0:
      new = len(self.scale[-1])
      if self.register > 0: 
        self.register = self.register - 1
    self.degree = new
    self.deltadegree = 'lower'
    return None
  #@+node:peckj.20131218082219.4137: *5* cp
  def cp(self):
    return random.choice([self.lp,self.rp])() ## tricksy tricksy
  #@+node:peckj.20131219081918.4169: *4* durations
  #@+node:peckj.20131219081918.4170: *4* play/rest
  #@+node:peckj.20131219081918.4171: *5* play
  def play(self):
    out = ''
    if self.deltadegree == 'lower': out = out + '\\'
    if self.deltadegree == 'raise': out = out + '/'
    deltaRegister = self.prevregister - self.register
    while deltaRegister < -1:
      deltaRegister += 1
      out = out + '/'
    while deltaRegister > 1:
      deltaRegister -= 1
      out = out + '\\'
    self.prevregister = self.register # important!
    self.deltadegree = 'same'
    pitch = self.scale[-1].get_name_for_degree(self.degree)
    out = out + ' ' + pitch + str(self.duration)
    return out
  #@+node:peckj.20131219081918.4172: *5* rest
  def rest(self):
    return 'S%s' % self.duration
  #@-others
#@-others
#@-leo
