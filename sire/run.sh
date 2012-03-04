#!/usr/bin/env bash

CP=lib/jfugue.jar:lib/processing.jar:classes/.

echo "Running sire..."
java -cp $CP SIRE
echo "Done."
