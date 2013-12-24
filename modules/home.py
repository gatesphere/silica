#@+leo-ver=5-thin
#@+node:peckj.20131224101941.5050: * @file ../modules/home.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131224101941.5052: ** << imports >>
import silica.core.sglobals as sg
#@-<< imports >>

#@+others
#@+node:peckj.20131224101941.5054: ** primitives
def primitives():
  sg.new_primitive('play', 'Plays the note with the current state.', lambda sg: sg.note.play())
  sg.new_primitive('rest', 'Rests the note for the current duration.', lambda sg: sg.note.rest())
  sg.new_primitive('rp', 'Raises the pitch of the note by one scale degree.', lambda sg: sg.note.rp())
  sg.new_primitive('lp', 'Lowers the pitch of the note by one scale degree.', lambda sg: sg.note.lp())
  sg.new_primitive('cp', 'Stochastically applies either RP or LP.', lambda sg: sg.note.cp())
  sg.new_primitive('x2', 'Expands the current duration by a factor of 2.', lambda sg: sg.note.x2())
  sg.new_primitive('x3', 'Expands the current duration by a factor of 3.', lambda sg: sg.note.x3())
  sg.new_primitive('x5', 'Expands the current duration by a factor of 5.', lambda sg: sg.note.x5())
  sg.new_primitive('x7', 'Expands the current duration by a factor of 7.', lambda sg: sg.note.x7())
  sg.new_primitive('s2', 'Shrinks the current duration by a factor of 2.', lambda sg: sg.note.s2())
  sg.new_primitive('s3', 'Shrinks the current duration by a factor of 3.', lambda sg: sg.note.s3())
  sg.new_primitive('s5', 'Shrinks the current duration by a factor of 5.', lambda sg: sg.note.s5())
  sg.new_primitive('s7', 'Shrinks the current duration by a factor of 7.', lambda sg: sg.note.s7())
  sg.new_primitive('maxvol', 'Sets the volume to the maximum (16000).', lambda sg: sg.note.maxvol())
  sg.new_primitive('minvol', 'Sets the volume to the minimum (0).', lambda sg: sg.note.minvol())
  sg.new_primitive('midvol', 'Sets the volume to a mid-range value (8000).', lambda sg: sg.note.midvol())
  sg.new_primitive('startvol', 'Sets the volume to the starting value (12000).', lambda sg: sg.note.startvol())
  sg.new_primitive('incvol', 'Increments the volume by 1000.', lambda sg: sg.note.incvol())
  sg.new_primitive('incvol1', 'Increments the volume by 100.', lambda sg: sg.note.incvol1())
  sg.new_primitive('decvol', 'Decrements the volume by 1000.', lambda sg: sg.note.decvol())
  sg.new_primitive('decvol1', 'Decrements the volume by 100.', lambda sg: sg.note.decvol1())
  sg.new_primitive('maxtempo', 'Sets the tempo to the maximum (400 bpm).', lambda sg: sg.note.maxtempo())
  sg.new_primitive('mintempo', 'Sets the tempo to the minimum (20 bpm).', lambda sg: sg.note.mintempo())
  sg.new_primitive('midtempo', 'Sets the tempo to a mid-range value (190 bpm).', lambda sg: sg.note.midtempo())
  sg.new_primitive('starttempo', 'Sets the tempo to the starting value (120 bpm).', lambda sg: sg.note.starttempo())
  sg.new_primitive('doubletempo', 'Doubles the tempo.', lambda sg: sg.note.doubletempo())
  sg.new_primitive('tripletempo', 'Triples the tempo.', lambda sg: sg.note.tripletempo())
  sg.new_primitive('halftempo', 'Halves the tempo.', lambda sg: sg.note.halftempo())
  sg.new_primitive('thirdtempo', 'Thirds the tempo.', lambda sg: sg.note.thirdtempo())
  sg.new_primitive('inctempo', 'Increments the tempo by 10 bpm.', lambda sg: sg.note.inctempo())
  sg.new_primitive('inctempo1', 'Increments the tempo by 1 bpm.', lambda sg: sg.note.inctempo1())
  sg.new_primitive('dectempo', 'Decrements the tempo by 10 bpm.', lambda sg: sg.note.dectempo())
  sg.new_primitive('dectempo1', 'Decrements the tempo by 1 bpm.', lambda sg: sg.note.dectempo1())
  
  ## NOT YET IMPLEMENTED
  #new_primitive('pushstate', 'Pushes the current state of the note onto the statestack.', lambda sg: sg.note.pushstate())
  #new_primitive('popstate', 'Pops the top state off the statestack and applies it to the note.', lambda sg: sg.note.popstate())
  #new_primitive('removestate', 'Removes the top state off the statestack without applying it to the note.', lambda sg: sg.note.removestate())
  #new_primitive('popalphabet', 'Attempts to relatively pop and plly the top alphabet from the scalestack.', lambda sg: sg.note.popalphabet(relative=True))
  #new_primitive('popalphabet$', 'Absolutely pops the top alphabet from the scalestack.', lambda sg: sg.note.popalhpabet())
#@+node:peckj.20131224101941.5056: ** metacommands
def metacommands():
  def exit(sg):
    sg.exit = True
    return 'Goodbye!'
  sg.new_metacommand('-exit', 'Exits silica.', exit)
  
  def state(sg):
    return str(sg.note)
  sg.new_metacommand('-state', 'Prints the state of the note.', state)

  def reset(sg):
    sg.note.reset()
    return 'Note state has been reset.'
  sg.new_metacommand('-reset', 'Resets the state of the note.', reset)
#@+node:peckj.20131224101941.5057: ** run
def run():
  primitives()
  metacommands()
  return True
#@-others
#@-leo
