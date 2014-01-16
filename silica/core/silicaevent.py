#@+leo-ver=5-thin
#@+node:peckj.20140116082214.3851: * @file silicaevent.py
#@@language python

#@+<< imports >>
#@+node:peckj.20140116082214.3852: ** << imports >>
#@-<< imports >>

#@+others
#@+node:peckj.20140116082214.3853: ** class SilicaEvent
class SilicaEvent(object):
  #@+others
  #@+node:peckj.20140116082214.3854: *3* __init__ # stub
  def __init__(self, eventtype, notestate):
    self.eventtype = eventtype # one of play, rest, pitch, tempo, instrument, volume, etc.
    self.notestate = notestate
  #@-others
#@-others
#@-leo
