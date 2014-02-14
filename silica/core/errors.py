#@+leo-ver=5-thin
#@+node:peckj.20140117095507.5636: * @file errors.py
#@@language python

#@+<< imports >>
#@+node:peckj.20140117095507.5637: ** << imports >>
#@-<< imports >>

#@+others
#@+node:peckj.20140117095507.5638: ** class SilicaSyntaxError
class SilicaSyntaxError(Exception):
  pass
#@+node:peckj.20140117095507.5639: ** class SilicaAlphabetError
class SilicaAlphabetError(Exception):
  pass
#@+node:peckj.20140123152153.4525: ** class SilicaNameError
class SilicaNameError(Exception):
  pass
#@+node:peckj.20140214082311.4227: ** class SilicaGroupError
class SilicaGroupError(Exception):
  pass
#@+node:peckj.20140214082311.4236: ** class SilicaInternalError
class SilicaInternalError(Exception):
  pass
#@-others
#@-leo
