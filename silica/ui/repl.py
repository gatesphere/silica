#@+leo-ver=5-thin
#@+node:peckj.20131219081918.4268: * @file repl.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131219081918.4269: ** << imports >>
import silica.core.sglobals as sg
import readline
import os
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131219081918.4270: ** << declarations >>
HISTORY_FILE = '.silica_history'
#@-<< declarations >>

#@+others
#@+node:peckj.20131219081918.4271: ** class REPL
class REPL(object):
  #@+others
  #@+node:peckj.20131219081918.4272: *3* __init__
  def __init__(self):
    self.silent = False
    self.prompt = 'silica> '
    self.load_history()
    readline.set_completer(HistoryCompleter().complete)
    readline.parse_and_bind('tab: complete')
    
  #@+node:peckj.20131219081918.4289: *3* history
  #@+node:peckj.20131219081918.4276: *4* load_history
  def load_history(self):
    if os.path.exists(HISTORY_FILE):
      readline.read_history_file(HISTORY_FILE)
  #@+node:peckj.20131219081918.4277: *4* save_history
  def save_history(self):
    readline.write_history_file(HISTORY_FILE)
  #@+node:peckj.20131219081918.4290: *3* running
  #@+node:peckj.20131219081918.4278: *4* run
  def run(self, autoexec=None, script=None):
    # handle autoexec
    if autoexec is not None:
      self.run_script(autoexec)
    
    # handle script
    if script is not None:    
      self.run_script(script)
      sg.exit = True # exit after script, not after autoexec
    
    # handle interactive mode
    else:
      while True:
        ln = raw_input(self.prompt)
        out = self.interpret_line(ln)
        if not self.silent:
          print out
        if sg.exit:
          self.save_history()
          return

        
  #@+node:peckj.20131219081918.4279: *4* interpret_line
  def interpret_line(self, line):
    out = sg.parser.parse_line(line)
    return self.interpret_events(out)

  #@+node:peckj.20140116082214.4160: *5* interpret_events
  def interpret_events(self, events):
    event_map = {'play': self.interpret_play_event,
                 'rest': self.interpret_rest_event,
                 'meta': self.interpret_meta_event,
                 'exception': self.interpret_exception_event,
                 'macro_def': self.interpret_macro_def_event}
                 
    out = []
    for event in events:
      if event.eventtype in event_map.keys():
        out.append(event_map[event.eventtype](event))
         
    if out is None or len(out) == 0:
      out = 'okay.'
    else:
      out = ' '.join(out)
    return '--> ' + out
  #@+node:peckj.20140116082214.4161: *6* interpret_play_event
  def interpret_play_event(self, event):
    es = event.notestate
    deltadegree = es['deltadegree']
    prevregister = es['prevregister']
    register = es['register']
    scale = es['scale'][-1]
    duration = es['duration']
    degree = es['degree']
    
    out = ''
    if deltadegree == 'lower': out = out + '\\'
    if deltadegree == 'raise': out = out + '/'
    deltaRegister = prevregister - register
    while deltaRegister < -1:
      deltaRegister += 1
      out = out + '/'
    while deltaRegister > 1:
      deltaRegister -= 1
      out = out + '\\'
    pitch = scale.get_name_for_degree(degree)
    out = out + ' ' + pitch + str(duration)
    return out
  #@+node:peckj.20140116082214.4162: *6* interpret_rest_event
  def interpret_rest_event(self, event):
    es = event.notestate
    d = es['duration']
    return 'S%s' % d
  #@+node:peckj.20140116082214.4163: *6* interpret_meta_event
  def interpret_meta_event(self, event):
    return event.message
  #@+node:peckj.20140123152153.4527: *6* interpret_macro_def_event
  def interpret_macro_def_event(self, event):
    return event.message
  #@+node:peckj.20140117095507.5635: *6* interpret_exception_event
  def interpret_exception_event(self, event):
    return event.exception.message
  #@+node:peckj.20131219081918.4280: *4* run_script
  def run_script(self, script):
    with open(script, 'r') as f:
      for line in f:
        self.interpret_line(line)
  #@-others
#@+node:peckj.20131219081918.4273: ** class HistoryCompleter
class HistoryCompleter(object):
  #@+others
  #@+node:peckj.20131219081918.4274: *3* __init__
  def __init__(self):
    self.matches = []
    return
  #@+node:peckj.20131219081918.4275: *3* complete
  def complete(self, text, state):
    response = None
    if state == 0:
      history_values = self.get_history_items()
      if text:
        self.matches = sorted(h for h in history_values if h and h.startswith(text))
      else:
        self.matches = []
    try:
      response = self.matches[state]
    except IndexError:
      response = None
    return response
  #@+node:peckj.20131219081918.4291: *3* get_history_items
  def get_history_items(self):
    return [readline.get_history_item(i) for i in xrange(1, readline.get_current_history_length() + 1)]
  #@-others
#@-others
#@-leo
