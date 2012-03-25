#!/usr/bin/env bash

IN="./lang/ -i ./repl/ -i ./modules/ -i ./"
OUT=./docs/naturaldocs
PROJ=./docs/naturaldocs/naturaldocs-project
FORMAT=HTML

## Run naturaldocs
naturaldocs -i $IN -o $FORMAT $OUT -p $PROJ