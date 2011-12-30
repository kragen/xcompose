#!/usr/bin/env python3

# From purpleposeidon!

from unicodedata import name
import re
import sys

for line in sys.stdin:
  line=line.strip()
  if not line or line[0]=="#":
    continue
  match=re.match(r'\s*(.*):\s*"(.*?)"\s*(\S*)\s*(#.*)?', line)
  if not match:
    print("({0})".format(line))
    continue
  (keystrokes, char, num, comments)=match.groups()
  nummatch=re.match(r'U([0-9A-Fa-f]+)', num)
  if not nummatch:
    print("Number not parsed: {0}".format(line))
    continue
  x=int(nummatch.group(1),0x10)
  c=chr(x)
  try:
    if c != char:
      print(line)
      print("\tLine's char: {0} ({1})".format(char, name(char)))
      print("\tLine's number: {0:X}".format(x))
      print("\tChar gives number: {0:X}".format(ord(char)))
      print("\tNumber gives character: {0} ({1})".format(c, name(c)))
  except Exception as e:
    print("{0}\n\t{1}".format(line, e))
