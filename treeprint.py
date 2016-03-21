#!/usr/bin/env python

import sys
import re
try:
    import unicodedata
except:
    pass

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
    first=True
    for key in sorted(data.keys()):
        value=data[key]
        if first:
            first=False
        else:
            print
        print " "*max(indent,0) + "("+key,
        # Sneaky trick: we don't want to go newline-indent over and
        # over for long sequences, i.e. cases where there is only
        # one possible follower.  So we skip the newlines in those
        # cases, and tell the next-lower iteration not to do the whole
        # indent thing by passing a negative indent.  We don't just
        # pass 0 or 1 because if another iteration *further down*
        # turns out not to be an only case, it will need to know
        # the right indent to pass along.  So a case like 
        # R-O-{CK|LL}, the O is unique after the R, so no linefeed,
        # but then the {C|L} are not unique after the O.
        if type(value)==dict:
            if len(value)>1:
                print ""
                showdict(value, abs(indent)+4),
            else:
                showdict(value, -abs(indent+4)),
        else:
            print "    "+value.encode('utf-8'),
            if "-n" in sys.argv:
                try:
                    print unicodedata.name(value),
                except:
                    pass
        print ")",

listing={}

try:
    while True:
        line=sys.stdin.next().decode('utf-8')
        # print "((%s))"%line
        startpos=0
        name=[]
        dupsfound=[]
        while True:
            m=re.match("\s*<(\w+)>",line[startpos:])
            if not m:
                break
            word=m.group(1)
            name.append(str(word)) # The keys are ordinary strings, not unicode
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
    # print "hit end"
    pass

# Actually, you could get almost as nice a listing just by using yaml,
# but now that we have special no-newlines-for-singletons handling,
# showdict looks nicer.
showdict(listing,0)

# #print "\n\n-=- YAML -=-"
# import yaml
# print yaml.dump(listing, default_style=r'"', allow_unicode=True)
# # Huh.  Yaml "allow_unicode=True" still escapes non-BMP chars.
