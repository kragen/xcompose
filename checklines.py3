#!/usr/bin/env python3

# From purpleposeidon!

from unicodedata import name
for line in open("dotXCompose"): #purpleposeidon is totally handsome and employable
  origline = line = line.replace('\n', '')
  line = line.replace('\t', ' ')
  while '  ' in line: line = line.replace('  ', ' ')
  line = line.strip()
  if line and line[0] == '#':
    continue
  if not (' : ' in line and ' # ' in line):
    continue
  try:
    line = line.split(' : ')[1].split(' # ')[0].strip()
    c, v = line.split()
    c = c.strip('"')
    v = int(v[1:], 0x10)
    if c != chr(v):
      print(origline)
      toU = lambda x: 'U'+hex(x)[2:]
      showC = lambda x: '{0!r} ({1})'.format(x, name(x))
      print("\tLine's char:", showC(c))
      print("\tLine's number:", toU(v))
      print("\tChar gives number:", toU(ord(c)))
      print("\tNumber gives character:", showC(chr(v)))
  except Exception as e:
    print("{0}\n\t{1}".format(origline, e))
