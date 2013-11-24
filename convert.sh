#!/bin/sh

INPUT=at_gc_tradi.ov2
OUTPUT=at_gc_tradi.csv

gpsbabel -i tomtom -f $INPUT -o csv,style=navigon.style -F $OUTPUT
