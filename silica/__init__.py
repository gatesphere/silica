#@+leo-ver=5-thin
#@+node:peckj.20130604112211.2146: * @file __init__.py
#@@language python
# this file makes the silica directory into a package

# the function allows the following code to work:
#
#    import silica
#    silica.run()

def run(*args, **kwargs):
  import silica.core.runSilica as runSilica
  runSilica.run()
#@-leo
