#@+leo-ver=5-thin
#@+node:peckj.20140819145303.4095: * @file modules/debug.py
#@@language python

#@+<< imports >>
#@+node:peckj.20140819145303.4096: ** << imports >>
import silica.core.sglobals as sg
#@-<< imports >>

#@+others
#@+node:peckj.20140819145303.4097: ** metacommands
def metacommands():
  from silica.core.silicaevent import SilicaEvent
  from silica.core.errors import SilicaSyntaxError
  #@+others
  #@+node:peckj.20140819145303.4101: *3* -debug
  def toggledebug(sg, arglist):
    sg.toggle_debug()
    if sg.debug:
      msg = 'Debugging output enabled.'
    else:
      msg = 'Debugging output disabled.'
    return SilicaEvent('meta', message=msg)
  sg.new_metacommand('-debug', 'Toggle debugging output.', toggledebug)
  #@-others
#@+node:peckj.20140819145303.4098: ** run
def run():
  metacommands()
  return True
#@-others
#@-leo
