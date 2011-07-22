#!/usr/bin/env python

import sys
import re

"""
This program slurps in a .XCompose file on standard input (or several
concatenated together, since it won't follow includes) and outputs the
compose sequences in an S-expression-like syntax, showing the prefix tree
of sequences.  This should bring together some of the groups that use a
prefix-character, like * for the Greek alphabet and # for musical symbols.
And scatter other related things far and wide.  But it might be fun to look
at.

Prefix conflicts (in which you have a compose sequence that is the proper
prefix of another) and exact conflicts (in which you have a compose
sequence listed two with two different translations) cannot be handled
gracefully in this notation, and they are not handled gracefully by this
program.  The tie is not broken in a consistent or predictable fashion,
etc: this is a case of GIGO.  Deal with it.
"""

def showdict(data, indent):
    for (key, value) in data.iteritems():
        print " "*indent + "("+key,
        if type(value)==dict:
            print ""
            showdict(value, indent+4)
        else:
            print "    "+value+")"
        

listing={}

try:
    while True:
        line=sys.stdin.next()
        # print "((%s))"%line
        startpos=0
        name=[]
        dupsfound=[]
        while True:
            m=re.match("\s*<(\w+)>",line[startpos:])
            if not m:
                break
            word=m.group(1)
            name.append(word)
            startpos+=m.end()
        if startpos<=0:
            continue
        m=re.match(r'[^"]*"(.+?)"',line)
        if not m:
            # shouldn't happen, but just in case
            val='???'
            print "couldn't make sense of line: "+line
        else:
            val=m.group(1)
        cur=listing
        for elt in name[:-1]:
            if type(cur)==dict:
                if not cur.has_key(elt):
                    cur[elt]={}
                cur=cur[elt]        # This will fail for prefix conflicts
            else:
                break           # prefix conflict
        # Presumably by now we're at the end, pointing to an empty dict.
        if type(cur)==dict:
            cur[name[-1]]=val
        else:
            # fail.  Prefix conflict.  Let's ignore it.
            pass
except StopIteration:
    print "hit end"

showdict(listing,0)

    
