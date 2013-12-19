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
    self.duration = 1.0
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
  #@+node:peckj.20131219081918.4169: *4* durations
  #@+node:peckj.20131219081918.4220: *5* expand
  def expand(self, factor):
    self.duration *= float(factor)
    return None
  #@+node:peckj.20131219081918.4221: *6* xN
  def x2(self): self.expand(2)
  def x3(self): self.expand(3)
  def x5(self): self.expand(5)
  def x7(self): self.expand(7)
  #@+node:peckj.20131219081918.4222: *5* shrink
  def shrink(self, factor):
    self.duration /= float(factor)
    return None
  #@+node:peckj.20131219081918.4223: *6* sN
  def s2(self): self.shrink(2)
  def s3(self): self.shrink(3)
  def s5(self): self.shrink(5)
  def s7(self): self.shrink(7)
  #@+node:peckj.20131219081918.4224: *4* volume
  #@+node:peckj.20131219081918.4225: *5* set_vol
  def set_vol(self, value, relative=False):
    if relative:
      self.set_vol(self.volume + value)
    else:
      if value < 0: value = 0
      if value > 16000: value = 16000
      self.volume(value)
      return None
  #@+node:peckj.20131219081918.4227: *6* primitives
  def maxvol(self): self.set_vol(16000)
  def minvol(self): self.set_vol(0)
  def midvol(self): self.set_vol(8000)
  def startvol(self): self.set_vol(12000)
  def incvol(self): self.set_vol(1000, relative=True)
  def incvol1(self): self.set_vol(100, relative=True)
  def decvol(self): self.set_vol(-1000, relative=True)
  def decvol1(self): self.set_vol(-100, relative=True)
  #@+node:peckj.20131219081918.4228: *4* tempo
  #@+node:peckj.20131219081918.4229: *5* set_tempo
  def set_tempo(self, value, relative=False):
    if relative:
      self.set_tempo(self.tempo + value)
    else:
      if value < 20: value = 20
      if value > 400: value = 400
      self.tempo = value
      return None
  #@+node:peckj.20131219081918.4230: *6* primatives
  def doubletempo(self): self.set_tempo(self.tempo * 2)
  def tripletempo(self): self.set_tempo(self.tempo * 3)
  def halftempo(self): self.set_tempo(self.tempo / 2)
  def thirdtempo(self): self.set_tempo(self.tempo / 3)
  def mintempo(self): self.set_tempo(20)
  def maxtempo(self): self.set_tempo(400)
  def midtempo(self): self.set_tempo(190)
  def starttempo(self): self.set_tempo(120)
  def inctempo(self): self.set_tempo(10, relative=True)
  def inctempo1(self): self.set_tempo(1, relative=True)
  def dectempo(self): self.set_tempo(-10, relative=True)
  def dectempo1(self): self.set_tempo(-1, relative=True)
  #@-others
#@-others
#@-leo
