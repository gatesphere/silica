#@+leo-ver=5-thin
#@+node:peckj.20130604112211.2150: * @file runSilica.py
#@@language python
#@+others
#@+node:peckj.20130604112211.4471: ** run
# run silica
def run():
  import silica.core.sglobals as sg
  sg.initialize()
  print 'Welcome to silica'
  print 'This is version: %s' % sg.silica_version
  sg.repl.run()
#@-others
#@-leo
