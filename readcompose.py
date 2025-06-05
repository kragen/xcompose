import fileinput
import re


def processline(line):
    name = []
    comments = ''
    startpos=0
    while True:
        m=re.match("\\s*<(\\w+)>",line[startpos:])
        if not m:
            break
        word=m.group(1)
        name.append(str(word))
        startpos+=m.end()
    if startpos<=0:
        return line             # lousy iterator.
    m=re.match(r'[^"]*"(.+?)"',line)
    if not m:
        # shouldn't happen, but just in case
        val=u'???'
        print("couldn't make sense of line: "+line)
    else:
        val=str(m.group(1))
    return (tuple(name), val)

def readcomposefiles():
    """Read compose files into a dictionary tree.  Uses fileinput, so
    filenames should be in sys.argv[1:], and takes stdin if there are none.
    Ignores prefix conflicts, etc.
    """
    listing={}
    linecount=0
    comments=""

    for line in fileinput.input():
        linecount+=1
        #line=line.decode('utf-8')
        startpos=0
        name=[]
        dupsfound=[]
        # while True:
        #     m=re.match("\s*<(\w+)>",line[startpos:])
        #     if not m:
        #         break
        #     word=m.group(1)
        #     name.append(str(word))
        #     startpos+=m.end()
        # if startpos<=0:
        #     comments+=line
        #     continue
        # m=re.match(r'[^"]*"(.+?)"',line)
        # if not m:
        #     # shouldn't happen, but just in case
        #     val=u'???'
        #     print("couldn't make sense of line: "+line)
        # else:
        #     val=str(m.group(1))
        xx = processline(line)  # bad way to do this!
        if type(xx) == tuple:
            name, val = xx
        else:
            comments += xx
            continue
        cur=listing
        for elt in name[:-1]:
            if type(cur)==dict:
                if not elt in cur:
                    cur[elt]={}
                cur=cur[elt]        # This will fail for prefix conflicts
            else:
                break           # prefix conflict
        # Presumably by now we're at the end, pointing to an empty dict.
        if type(cur)==dict:
            cur[name[-1]]=(val)
            comments=""
            inline=""
        else:
            # fail.  Prefix conflict.  Let's ignore it.
            pass
    return listing

def flattendict(dct, prefixes=None, rv=None):
    """Take nested dict and return flattened version"""
    if rv is None:
        rv={}
    if prefixes is None:
        prefixes=[]
    for (k, v) in dct.items():
        if isinstance(v, dict):
            flattendict(v, prefixes+[k], rv)
        else:
            rv[tuple(prefixes+[k])]=v
    return rv

def invertdict(flatdict):
    """Invert a (flat) dictionary.  For multiple keys with the same value, one
    of them wins.  Last, probably."""
    rv={}
    for k, v in flatdict.items():
        rv[v] = k
    return rv
