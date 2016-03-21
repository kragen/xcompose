#!/usr/bin/env python

import sys
import re


listing={}

try:
    while True:
        line=sys.stdin.next()
        # print "((%s))"%line
        startpos=0
        name=''
        dupsfound=[]
        while True:
            m=re.match("\s*<(\w+)>",line[startpos:])
            if not m:
                break
            word=m.group(1)
            name+=' '+word
            startpos+=m.end()
        if startpos<=0:
            continue
        m=re.match(r'[^"]*"(.+)"',line)
        if not m:
            # shouldn't happen, but just in case
            val='???'
            print "couldn't make sense of line: "+line
        else:
            val=m.group(1)
        if listing.has_key(name):
            if val != listing[name]:
                print "Exact conflict found: (%s )[%s][%s]"%(name, 
                                                             listing[name], val)
            else:   # It's easier to read if lines have different indentations
                print "\tRedundant definition: (%s )[%s]"%(name, val)
        else:
            listing[name]=val
except StopIteration:
    print "hit end"
# NOW check for prefix conflicts:
print "Checking prefixes."
for key in listing.keys():
    # print "Key: (%s)"%key
    pref=''
    # Careful when splitting.  The key always starts with a space.
    for word in key.split(" ")[:-1]: # chop the last one; that'll always match.
        # Skip the empty first entry
        if not word:
            continue
        pref+=" "+word
        # print "checking (%s)"%pref
        if listing.has_key(pref):
            print "Prefix conflict found: " \
                "(%s )[%s] vs (%s )[%s]"%(pref, listing[pref],
                                          key, listing[key])

    
