#!/usr/bin/env python
#@+leo-ver=5-thin
#@+node:peckj.20140124085532.3990: * @file toy_code/funcparserlibtest.py
#@@first
#@@language python

#@+<< imports >>
#@+node:peckj.20140124085532.3991: ** << imports >>
from tokenize import generate_tokens
from StringIO import StringIO
from pprint import pformat
import operator, token
from funcparserlib.parser import some, a, many, skip, finished, maybe, with_forward_decls
#@-<< imports >>

#@+others
#@+node:peckj.20140124085532.4000: ** lexing
#@+node:peckj.20140124085532.3994: *3* class Token
class Token(object):
  #@+others
  #@+node:peckj.20140124085532.3995: *4* __init__
  def __init__(self, code, value, start=(0,0), stop=(0,0), line=''):
    self.code = code
    self.value = value
    self.start = start
    self.stop = stop
    self.line = line
  #@+node:peckj.20140124085532.3996: *4* type
  @property
  def type(self):
    return token.tok_name[self.code]
  #@+node:peckj.20140124085532.3997: *4* __unicode__
  def __unicode__(self):
    pos = '-'.join('%d,%d' % x for x in [self.start, self.stop])
    return "%s %s '%s'" % (pos, self.type, self.value)
  #@+node:peckj.20140124085532.3998: *4* __repr__
  def __repr__(self):
    return 'Token(%r, %r, %r, %r, %r' % (
      self.code, self.value, self.start, self.stop, self.line)
  #@+node:peckj.20140124085532.3999: *4* __eq__
  def __eq__(self, other):
    return (self.code, self.value) == (other.code, other.value)
  #@-others
#@+node:peckj.20140124085532.4001: *3* tokenize
def tokenize(s):
  'str -> [Token]'
  return list(Token(*t) for t in generate_tokens(StringIO(s).readline)
    if t[0] not in [token.NEWLINE])
#@+node:peckj.20140124085532.4002: ** parsing
#@+node:peckj.20140124085532.4004: *3* helpers
#@+node:peckj.20140124085532.4006: *4* tokval
tokval = lambda tok: tok.value
#@+node:peckj.20140124085532.4009: *4* unarg
unarg = lambda f: lambda x: f(*x)
#@+node:peckj.20140124085532.4005: *4* make_number and negate
def make_number(s):
  try:
    return int(s)
  except ValueError:
    return float(s)

#negate = lambda n: n * -1
def negate(n):
  return n[1] * -1
#@+node:peckj.20140124085532.4010: *4* makeop
op = lambda s: a(Token(token.OP, s)) >> tokval
op_ = lambda s: skip(op(s))
const = lambda x: lambda _: x
makeop = lambda s, f: op(s) >> const(f)
#@+node:peckj.20140124085532.4008: *4* eval_expr
def eval_expr(z, list):
  return reduce(lambda s, (f, x): f(s, x), list, z)

f = unarg(eval_expr)
#@+node:peckj.20140124085532.4003: *3* grammar
posnumber = (
  some(lambda tok: tok.type == 'NUMBER')
  >> tokval 
  >> make_number)

add = makeop('+', operator.add)
sub = makeop('-', operator.sub)
mul = makeop('*', operator.mul)
div = makeop('/', operator.div)
pow = makeop('**', operator.pow)

negnumber = (sub + posnumber) >> negate
number = posnumber | negnumber

mul_op = mul | div
add_op = add | sub

primary = with_forward_decls(lambda: number | (op_('(') + expr + op_(')')))
factor = primary + many(pow + primary) >> f
term = factor + many(mul_op + factor) >> f
expr = term + many(add_op + term) >> f

endmark = a(Token(token.ENDMARKER, ''))
end = skip(endmark + finished)
toplevel = maybe(expr) + end
#@+node:peckj.20140124085532.4012: *3* parse
def parse(tokens):
  return toplevel.parse(tokens)

parse_and_run = lambda x: parse(tokenize(x))
#@+node:peckj.20140124085532.3993: ** main
def main():
  prompt = '> '
  cmd = None
  while True:
    cmd = raw_input(prompt)
    if cmd == 'quit': break
    try:
      print parse_and_run(cmd)
    except Exception as e:
      print e
  
#@-others

if __name__=='__main__':
  main()
#@-leo
