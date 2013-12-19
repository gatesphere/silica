#!/usr/bin/env python
#@+leo-ver=5-thin
#@+node:peckj.20131219081918.4175: * @file ../silicaTester.py
#@@first
#@@language python

#@+<< imports >>
#@+node:peckj.20131219081918.4176: ** << imports >>
#import silica.core.sglobals as sglobals
#sg = sglobals
import silica.core.sglobals as sg
from silica.core.note import Note
#@-<< imports >>

#@+others
#@+node:peckj.20131219081918.4177: ** main
def main():
  # create C-MAJOR scale
  sg.new_mode('MAJOR', [2,2,1,2,2,2,1])
  sg.new_scale('C-MAJOR', sg.get_mode('MAJOR'), 'C')

  # create note and play around with it  
  n = Note()
  print n.play()
  print n.rest()
  for i in range(20):
    n.rp()
    #print n.play()
  print n.play()
  for i in range(20):
    n.lp()
    #print n.play()
  print n.play()
  for i in range(20):
    n.cp()
    print n.play()
#@-others

if __name__=='__main__':
  main()
#@-leo
