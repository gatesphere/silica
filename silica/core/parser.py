#@+leo-ver=5-thin
#@+node:peckj.20131219081918.4285: * @file parser.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131219081918.4286: ** << imports >>
import silica.core.sglobals as sg
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131219081918.4287: ** << declarations >>
#@-<< declarations >>

#@+others
#@+node:peckj.20131219081918.4288: ** class Parser
class Parser(object):
  def parse_line(self, string):
    if '-exit' in string.lower():
      sg.exit = True
    return 'parser received: %s' % string
#@-others
#@-leo
