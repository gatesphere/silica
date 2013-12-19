#@+leo-ver=5-thin
#@+node:peckj.20131219081918.4262: * @file ../toy_code/readlinetest.py
#@@language python

''' test readline on windows '''

import os

import readline ## actually 'pyreadline' installed by 'anyreadline'

HISTORY_FILENAME = '.readline_history'

def get_history_items():
  return [readline.get_history_item(i) for i in xrange(1, readline.get_current_history_length() + 1)]

class HistoryCompleter(object):
  def __init__(self):
    self.matches = []
    return
  def complete(self, text, state):
    response = None
    if state == 0:
      history_values = get_history_items()
      if text:
        self.matches = sorted(h for h in history_values if h and h.startswith(text))
      else:
        self.matches = []
    try:
      response = self.matches[state]
    except IndexError:
      response = None
    return response

def input_loop():
  if os.path.exists(HISTORY_FILENAME):
    readline.read_history_file(HISTORY_FILENAME)
  print 'Max history file length:', readline.get_history_length()
  print 'Startup history:', get_history_items()
  try:
    while True:
      line = raw_input('silica> ')
      if line == 'stop':
        break
      if line:
        print 'Adding %s to the history' % line
  finally:
    print 'Final history:', get_history_items()
    readline.write_history_file(HISTORY_FILENAME)

if __name__=='__main__':
  #readline.set_completer(HistoryCompleter().complete)
  readline.parse_and_bind('tab: complete')
  input_loop()
#@-leo
