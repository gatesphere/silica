#@+leo-ver=5-thin
#@+node:peckj.20131218082219.4105: * @file Globals.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131218082219.4106: ** << imports >>
#@-<< imports >>
#@+<< declarations >>
#@+node:peckj.20131218082219.4107: ** << declarations >>
pitchnames = ['C', 'V', 'D', 'W', 'E', 'F', 'X', 'G', 'Y', 'A', 'Z', 'B']
#@-<< declarations >>

#@+others
#@+node:peckj.20131218082219.4108: ** lookup methods
#@+node:peckj.20131218082219.4109: *3* get_mode
#@+node:peckj.20131218082219.4110: *3* get_scale
def get_scale(name):
  ## dummy implementation for now
  import silica.core.Scale as Scale
  import silica.core.Mode as Mode
  major = Mode('MAJOR', [2,2,1,2,2,2,1])
  cmajor = Scale('C-MAJOR', major, 'C')
  return cmajor
#@+node:peckj.20131218082219.4111: *3* get_instrument
#@+node:peckj.20131218082219.4112: *3* get_namespace
#@+node:peckj.20131218082219.4113: *3* get_token
#@+node:peckj.20131218082219.4114: *3* load_module
#@+node:peckj.20131218082219.4121: ** lookup tables
#@-others
#@-leo
