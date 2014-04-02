#@+leo-ver=5-thin
#@+node:peckj.20131219081918.4285: * @file parser.py
#@@language python

#@+<< imports >>
#@+node:peckj.20131219081918.4286: ** << imports >>
import silica.core.sglobals as sg
from silica.core.silicaevent import SilicaEvent
from silica.core.errors import SilicaNameError, SilicaGroupError, SilicaInternalError, SilicaSyntaxError
#@-<< imports >>

#@+others
#@+node:peckj.20131219081918.4288: ** class Parser
class Parser(object):
  #@+others
  #@+node:peckj.20131222154620.7072: *3* __init__
  def __init__(self):
    self.fn_table = {'primitive': self.run_primitive,
                     'metacommand': self.run_metacommand,
                     'macro': self.run_macro}
    self.mcmode = False
    self.notestate = None
  #@+node:peckj.20131222154620.7092: *3* reset_parsing_state
  def reset_parsing_state(self):
    self.mcmode = False
    self.notestate = None
  #@+node:peckj.20131221180451.4203: *3* parse_line
  def parse_line(self, string, reset=True):
    if reset: self.reset_parsing_state()
    #@+<< metacommand mode >>
    #@+node:peckj.20140318084140.4613: *4* << metacommand mode >>
    if string.startswith('-'):
      self.mcmode = True
    #@-<< metacommand mode >>
    self.notestate = sg.note.makestate() # to recover from errors without affecting note.statestack
    #@+<< macro definition >>
    #@+node:peckj.20140318084140.4611: *4* << macro definition >>
    if '>>' in string or '=' in string:
      # define macro!
      event = self.define_macro(string)
      return [event]
    #@-<< macro definition >>
    #@+<< mode definition >>
    #@+node:peckj.20140318084140.4612: *4* << mode definition >>
    if '!!' in string: ## STUB
      # define mode!
      return []
    #@-<< mode definition >>
    #@+<< auto invariance mode >>
    #@+node:peckj.20140318084140.4614: *4* << auto invariance mode >>
    if sg.auto_invariance:
      string = ' '.join(['pushstate', string, 'popstate'])
    #@-<< auto invariance mode >>
    
    toks = self.simplify_line(string)
    if len(toks) == 1 and type(toks[0]) is SilicaEvent:
      return toks
    out = []
    #@+<< interpret tokens >>
    #@+node:peckj.20140318084140.4615: *4* << interpret tokens >>
    for tok in toks:
      # should all be primitives + metacommands by now...
      try:
        element, etype = sg.get_token(tok)
        if element is not None and etype is not None:
          v = self.fn_table[etype](element)
          if v is not None:
            # v may be a list, in which case, append them all separately
            if hasattr(v, '__iter__') and not isinstance(v, basestring):
              for e in v: out.append(e)
            else: out.append(v)
          else:
            raise SilicaInternalError('No fn_table type defined in parser for type %s' % etype)
        else:
          raise SilicaNameError('No token named %s exists in the current namespace' % tok)
      except Exception as e:
        sg.note.applystate(self.notestate) # exception occurred, the notestate must be reset
        return [SilicaEvent('exception', exception=e)] # only return the exception!
    #@-<< interpret tokens >>
    #@+<< groups balanced >>
    #@+node:peckj.20140318084140.4616: *4* << groups balanced >>
    if self.groups_are_balanced(out):
      return out

    else:
      e = SilicaGroupError('Groups are unbalanced.')
      sg.note.applystate(self.notestate)
      return [SilicaEvent('exception', exception=e)]
    #@-<< groups balanced >>
    return out
  #@+node:peckj.20140108090613.4237: *4* groups_are_balanced
  def groups_are_balanced(self, out):
    pushtypes = ['begingroup']
    poptypes = ['endgroup']
    
    stack = []
    for event in out:
      if event.eventtype in pushtypes: stack.append(event.eventtype)
      if event.eventtype in poptypes:
        if len(stack) > 0 and stack[-1] == pushtypes[poptypes.index(event.eventtype)]: 
          stack.pop()
        else: # trying to pop before a push!
          return False 
    return len(stack) == 0
  #@+node:peckj.20140318084140.4608: *4* simplify_line
  def simplify_line(self, line):
    ''' line: string
        returns: list
    '''
    changed = True
    depth = 0
    
    toks = line.split()
    try:
      while changed and depth < sg.max_recursive_depth:
        changed = False
        depth += 1
        toks,changed = self.group_args(toks,changed)
        toks,changed = self.simplify_factors(toks,changed)
        toks,changed = self.simplify_expansions(toks,changed)
        #if sg.debug: sg.trace('changed = %s (toks = %s)' % (changed, toks))
    except Exception as e:
      return [SilicaEvent('exception', exception=e)]
      
    if depth >= sg.max_recursive_depth:
      e = SilicaInternalError('Infinite loop detected, bailing out.')
      return [SilicaEvent('exception', exception=e)]
    
    #if sg.debug: sg.trace('line: %s' % toks)
    return toks
  #@+node:peckj.20140318084140.4609: *5* simplify_factors
  def simplify_factors(self, toks, changed):
    toks2 = []
    changed = changed
    #if sg.debug: sg.trace('simplify_factors: %s' % toks)
    for tok in toks:
      if tok[0].isdigit():
        ## ugly as shit, and hacky as hell
        ## (perhaps the one time Io is better than python...)
        num = ''
        token = ''
        for i in range(len(tok)):
          if tok[i].isdigit():
            num = num + tok[i]
          else:
            token = tok[i:]
            break
        num = int(num)
        for i in range(num):
          toks2.append(token)
        changed = True
      elif '+' in tok:
        before,after = tok.split('+',1)
        toks2.append(before)
        toks2.append(after)
        changed = True  
      else:
        toks2.append(tok)
    return toks2,changed
  #@+node:peckj.20140319080806.4519: *5* group_args
  def group_args(self, toks, changed):
    toks2 = []
    changed = changed
    
    ## still unhandled:
    ## ensuring , delimited arguments
    
    curtok = ''
    level = 0
    for tok in toks:
      #if sg.debug: sg.trace("group_args: curtok = %s   level = %s" % (curtok, level))
      if '(' in tok or level > 0:
        curtok = curtok + tok
        level += tok.count('(')
        level -= tok.count(')')
        if level == 0:
          toks2.append(curtok)
          curtok = ''
        continue
      toks2.append(tok)
    
    if level != 0:
      e = SilicaSyntaxError('Syntax error in call: unbounded arglist.')
      raise e
    
    return toks2,changed
  #@+node:peckj.20140318084140.4610: *5* simplify_expansions
  def simplify_expansions(self, toks, changed):
    toks2 = []
    changed = changed
    for tok in toks:
      n = tok
      arglist = None
      if '(' in tok:
        n,args = tok.split('(',1)
        args = args[:-1]
        level = 0
        curarg = ''
        arglist = []
        for ch in args:
          if ch == ',' and level == 0:
            arglist.append(curarg.strip())
            curarg = ''
            continue
          curarg = curarg + ch
          if ch == '(':
            level += 1
            continue
          if ch == ')':
            level -= 1
            continue
        arglist.append(curarg.strip())
        #if sg.debug: sg.trace('arglist: %s' % arglist)
      
      element, etype = sg.get_token(n)
      if element is not None and etype == 'macro':
        v = self.run_macro(element, arglist).split()
        for e in v: toks2.append(e)
        changed = True
      elif etype == 'metacommand':
        v = [self.run_metacommand(element, arglist)]
        #if sg.debug: sg.trace('meta: %s' % v)
        return v,False # short circut
      else:
        toks2.append(tok)
      #if sg.debug: sg.trace('toks2: %s' % toks2)
    return toks2,changed
  #@+node:peckj.20131222154620.7073: *3* run_primitive
  def run_primitive(self, p, arglist=None):
    if self.mcmode:
      return None
    return p.execute()
  #@+node:peckj.20140106180202.4630: *3* run_macro
  def run_macro(self, m, arglist=None):
    if self.mcmode:
      return None
    #return self.parse_line(m.expand(), reset=False)
    return m.expand(arglist)
  #@+node:peckj.20131222154620.7090: *3* run_metacommand
  def run_metacommand(self, m, arglist=None):
    if self.mcmode:
      return m.execute(arglist)
    else:
      return None
  #@+node:peckj.20140123152153.4522: *3* define_macro
  def define_macro(self, string):
    # = is syntactic sugar for >> begingroup ... endgroup
    splitter = '>>'
    if '=' in string:
      splitter = '='
    vals = string.split(splitter, 1)
    signature = vals[0].strip()
    if len(vals) == 2:
      body = vals[1].strip()

    if len(body) == 0:
      ex = SilicaSyntaxError('Syntax error in macro definition: macro has no body.')
      return SilicaEvent('exception', exception=ex)

    vals = signature.split('(',1)
    name = vals[0].strip().upper()
    
    if not self.valid_name(name):
      ex = SilicaNameError('The name %s is invalid in this context.' % name)
      return SilicaEvent('exception', exception=ex)
    
    args = None
    if len(vals) == 2:
      arglist = vals[1].strip()
      if len(arglist) > 0:
        if arglist[-1] != ')':
            ex = SilicaSyntaxError('Syntax error in macro definition: unbounded arglist.')
            return SilicaEvent('exception', exception=ex)
        else:
          arglist = arglist[:-1]
          arglist = arglist.split(',')
          args = [a.strip() for a in arglist]
    
    if splitter == '=':
      body = 'begingroup ' + body + ' endgroup'
    sg.new_macro(name, body, args)
    return SilicaEvent('macro_def', message='Macro %s defined.' % name)
  #@+node:peckj.20140123152153.4523: *4* valid_name # stub
  def valid_name(self, name):
    forbidden_chars = ['(', ')', ':', '=', '+', '-', ',', '>>']
    for c in forbidden_chars:
      if c in name:
        return False
    element, etype = sg.get_token(name)
    if element and etype in ['primitive', 'metacommand', 'transform']:
      return False
    return True
  #@-others
#@-others
#@-leo
