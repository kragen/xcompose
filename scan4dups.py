#!/bin/py

import sys
import re

class node(dict):
    name=""
    parent=None

# Top of tree:
top=node()

def name2leaf(ending):
    rv=""
    p=ending
    while p is not None:
        rv=p.name+" "+rv
        p=p.parent
    return rv

try:
    while True:
        line=sys.stdin.next()
        # print "((%s))"%line
        startpos=0
        ptr=top
        dupsfound=[]
        lastAdded=None
        while True:
            m=re.match("\s*<(\w+)>",line[startpos:])
            if not m:
                break
            word=m.group(1)
            # print "found word: %s"%word
            # Now, there is a prefix conflict if: (a) I am about to add an
            # element to an otherwise empty (i.e. terminal) directory (a
            # leaf), or (b) At the end of this element, the dictionary I
            # end on is *not* empty (i.e. NOT a leaf).  We check (a) here,
            # and (b) after the loop.
            #
            # Waitasec, it's okay if I'm adding to a leaf *if I just added
            # that leaf*!
            if not ptr.keys() and ptr!=lastAdded and ptr!=top:
                dupsfound.append(name2leaf(ptr))
            try:
                next=ptr[word]
            except KeyError:
                next=node()
                next.parent=ptr
                next.name=word
                lastAdded=next
                ptr[word]=next
            ptr=next
            startpos+=m.end()
        if startpos!=0:                 # Skip if the line had nothing.
            if ptr.keys():              # Dup if the end is NOT a leaf.
                dupsfound.append(name2leaf(ptr))
            mystring=name2leaf(ptr)
            # print "processed: (%s)"%mystring
            for i in dupsfound:
                print "Prefix conflict found: (%s) vs (%s)"%(mystring, i)
except StopIteration:
    print "hit end"
    pass
print "Done."
    
