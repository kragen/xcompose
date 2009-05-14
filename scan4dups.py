#!/bin/py

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
            if listing.has_key(name):
                dupsfound.append(name)
            startpos+=m.end()
        if startpos<=0:
            continue
        m=re.match(r'[^"]*"(.+)"',line)
        if not m:
            # shouldn't happen, but just in case
            listing[name]='???'
            print "couldn't make sense of line: "+line
        else:
            listing[name]=m.group(1)
        for i in dupsfound:
            if listing[name]==listing[i]:
                msg="Redundant definition: "
            else:
                msg="Prefix conflict found: "
            print msg+"(%s )[%s] vs (%s )[%s]"% \
                (name, listing[name], i, listing[i])
except StopIteration:
    print "hit end"
    pass
print "Done."
    
