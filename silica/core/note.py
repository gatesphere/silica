#@+leo-ver=5-thin
#@+node:peckj.20131218082219.4088: * @file note.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131218082219.4089: ** << imports >>
import silica.core.sglobals as sg
from silica.core.silicaevent import SilicaEvent
from silica.core.errors import SilicaAlphabetError
import random
import fractions
#@-<< imports >>

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
    self.duration = fractions.Fraction(1,1)
    self.register = 5
    self.prevregister = 5
    self.volume = 12000
    self.tempo = 120
    self.instrument = None # replace with PIANO
    self.deltadegree = 'same'
    self.statestack = []
  #@+node:peckj.20131222154620.7093: *3* __str__
  def __str__(self):
    out = '''NOTE < 
      scalestack = %s
      degree = %s
      register = %s
      duration = %s
      deltadegree = %s
      volume = %s
      tempo = %s
      instrument = %s
      prevregister = %s
    >'''%([str(s) for s in self.scale], self.degree, self.register,
          self.duration, self.deltadegree, self.volume,
          self.tempo, self.instrument, self.prevregister)
    return out
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
    return SilicaEvent('pitch', notestate=self.makestate())
    #return None
  #@+node:peckj.20131218082219.4136: *5* lp
  def lp(self):
    new = self.degree - 1
    if new == 0:
      new = len(self.scale[-1])
      if self.register > 0: 
        self.register = self.register - 1
    self.degree = new
    self.deltadegree = 'lower'
    return SilicaEvent('pitch', notestate=self.makestate())
    #return None
  #@+node:peckj.20131218082219.4137: *5* cp
  def cp(self):
    return random.choice([self.lp,self.rp])() ## tricksy tricksy
  #@+node:peckj.20131219081918.4170: *4* play/rest
  #@+node:peckj.20131219081918.4171: *5* play
  def play(self):
    se = SilicaEvent('play', notestate=self.makestate())
    self.prevregister = self.register
    self.deltadegree = 'same'
    return se
  #@+node:peckj.20131219081918.4172: *5* rest
  def rest(self):
    return SilicaEvent('rest', notestate=self.makestate())
  #@+node:peckj.20131219081918.4169: *4* durations
  #@+node:peckj.20131219081918.4220: *5* expand
  def expand(self, factor):
    self.duration *= factor
    return SilicaEvent('duration', notestate=self.makestate())
  #@+node:peckj.20131219081918.4221: *6* xN
  def x2(self): self.expand(2)
  def x3(self): self.expand(3)
  def x5(self): self.expand(5)
  def x7(self): self.expand(7)
  #@+node:peckj.20131219081918.4222: *5* shrink
  def shrink(self, factor):
    self.duration /= factor
    return SilicaEvent('duration', notestate=self.makestate())
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
      self.volume = value
      return SilicaEvent('volume', notestate=self.makestate())
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
      return SilicaEvent('tempo', notestate=self.makestate())
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
  #@+node:peckj.20140103121318.3965: *4* scales
  #@+node:peckj.20140103121318.3964: *5* change_scale
  def change_scale(self, new_scale, relative=False):
    if relative:
      pitch = self.scale[-1].get_name_for_degree(self.degree)
      new_degree = new_scale.get_degree_for_name(pitch)
      if new_degree is None:
        # error!
        msg = 'Cannot change to scale %s relatively: pitch %s not in scale.' % (new_scale.name, pitch)
        error = SilicaAlphabetError(msg)
        raise error
      else:
        self.degree = new_degree
        self.scale.append(new_scale)
    else:
      self.degree = 1
      self.scale.append(new_scale)
      self.deltadegree = 'same'
    return SilicaEvent('scale', notestate=self.makestate())
  #@+node:peckj.20140103121318.3966: *5* pop_alphabet
  def pop_alphabet(self, relative=False):
    if len(self.scale) == 1:
      msg = 'Cannot pop alphabet: must leave one in stack.'
      error = SilicaAlphabetError(msg)
      raise error
    if relative:
      pitch = self.scale[-1].get_name_for_degree(self.degree)
      new_scale = self.scale[-2]
      new_degree = new_scale.get_degree_for_name(pitch)
      if new_degree is None:
        msg = 'Cannot pop to scale %s relatively: pitch %s not in scale.' % (new_scale.name, pitch)
        error = SilicaAlphabetError(msg)
        raise error
      self.scale.pop()
      self.degree = new_degree
    else:
      self.scale.pop()
      self.degree = 1
      self.deltadegree = 'same'
    return SilicaEvent('scale', notestate=self.makestate())
  #@+node:peckj.20140106082417.4659: *4* instruments
  #@+node:peckj.20140106082417.4660: *5* change_instrument
  def change_instrument(self, instrument):
    self.instrument = instrument
    return SilicaEvent('instrument', notestate=self.makestate())
  #@+node:peckj.20140106082417.4635: *4* state (do not return SilicaEvents)
  #@+node:peckj.20140106082417.4636: *5* pushstate
  def pushstate(self):
    state = self.makestate()
    self.statestack.append(state)
    return None
  #@+node:peckj.20140108090613.4236: *5* makestate
  def makestate(self):
    state = {'scale': self.scale[:], # copy, not store-by-ref
             'degree': self.degree,
             'duration': self.duration,
             'register': self.register,
             'volume': self.volume,
             'tempo': self.tempo,
             'instrument': self.instrument,
             'deltadegree': self.deltadegree,
             'prevregister': self.prevregister}
    return state
  #@+node:peckj.20140106082417.4637: *5* popstate
  def popstate(self):
    if len(self.statestack) > 0:
      self.applystate(self.statestack.pop())
    return None
  #@+node:peckj.20140106082417.4638: *5* removestate
  def removestate(self):
    if len(self.statestack) > 0:
      self.statestack.pop()
    return None
  #@+node:peckj.20140106082417.4639: *5* applystate
  def applystate(self, state):
    self.scale = state['scale']
    self.degree = state['degree']
    self.duration = state['duration']
    self.register = state['register']
    self.volume = state['volume']
    self.tempo = state['tempo']
    self.instrument = state['instrument']
    self.deltadegree = state['deltadegree']
    self.prevregister = state['prevregister']
  #@+node:peckj.20140214082311.4228: *4* grouping
  #@+node:peckj.20140214082311.4229: *5* begingroup
  def begingroup(self):
    return SilicaEvent('begingroup', notestate=self.makestate())
  #@+node:peckj.20140214082311.4231: *5* endgroup
  def endgroup(self):
    return SilicaEvent('endgroup', notestate=self.makestate())
  #@-others
#@-others
#@-leo
