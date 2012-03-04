#!/usr/bin/env bash

CP=lib/jfugue.jar:lib/processing.jar:classes/.

echo "Running sire..."
if [[ $OSTYPE == linux-gnu ]]; then
  java -cp $CP SIRE
elif [[ $OSTYPE == cygwin ]]; then
  java -cp `cygpath -wp $CP` SIRE
else 
  echo "Unknown platform."
fi
echo "Done."
