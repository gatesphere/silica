#@+leo-ver=5-thin
#@+node:peckj.20130604112211.2150: * @file runSilica.py
#@@language python

#@+<< imports >>
#@+node:peckj.20140307080519.11092: ** << imports >>
import sys
import optparse
#@-<< imports >>

#@+others
#@+node:peckj.20130604112211.4471: ** run
# run silica
def run():
  usage = 'usage: %prog [options] [script]'
  argv = sys.argv[1:]
  opt_parser = optparse.OptionParser(usage=usage)
  #@+<< handle command-line options >>
  #@+node:peckj.20140307080519.11093: *3* << handle command-line options >>
  # command line options
  opt_parser.add_option('-s', '--silent', action='store_true', 
          dest='silent', default=False, help='suppress textual output')
  opt_parser.add_option('-d', '--debug', action='store_true',
          dest='debug', default=False, help='enable debugging [slow, only for developers]')
  opt_parser.add_option('--no-autoexec', action='store_true', 
          dest='no_autoexec', default=False, 
          help='do not execute the silica autoexec file')
  opt_parser.add_option('-m', '--module', action='append', type='string', 
          dest='module', default=[], help='load the given module automatically')
  opt_parser.add_option('-v', '--version', action='store_true',
          dest='version', default=False, help='display version info and exit')
  #@-<< handle command-line options >>
  (opts, args) = opt_parser.parse_args(argv)  
  
  # sanity check
  if len(args) > 1:
    opt_parser.print_help()
    sys.exit(0)
  
  # main logic
  import silica.core.sglobals as sg
  
  # version?
  if opts.version:
    print 'silica version: %s' % sg.silica_version
    print 'Jacob Peck <gatesphere@gmail.com>'
    print 'http://suspended-chord.info/'
    sys.exit(0)
  
  # continue on my merry way...  
  sg.initialize(opts.debug)
  
  # load modules
  for m in opts.module:
    sg.load_module(m)
  
  # silent?
  sg.repl.silent = opts.silent
  
  # get autoexec
  autoexec = None
  if not opts.no_autoexec:
    autoexec = sg.get_autoexec()
  
  # get script
  script = None
  if len(args) == 1:
    script = args[0]
  
  sg.repl.run(autoexec=autoexec, script=script)
#@-others
#@-leo
