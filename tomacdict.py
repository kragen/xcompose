#!/usr/bin/env python3

# Basically a form of treeprint that prints out in a format accessible as
# MacOS DefaultKeyBinding.dict file.

# Still buggy, see XXXXs below.  Result will want some hand-editing.

from readcompose import readcomposefiles
import re

HEXRE = re.compile("U[0-9A-F]{4}")

INDENT = 4
MULTI_KEY = '§'                 # Use this symbol instead of Multi_key

translate = {                   # Only non-obvious ones.
    # Ref https://gist.github.com/trusktr/1e5e516df4e8032cbc3d
    # Also see https://github.com/ttscoff/KeyBindings/blob/master/DefaultKeyBinding.dict
    # Symbols used by MacOS as modifier keys: ~^@$#
    # These must be escaped with a DOUBLE backslash.
    'minus' : '-',
    'underscore' : '_',
    'greater' : '>',
    'less' : '<',
    'comma' : ',',
    'period' : '.',
    'dollar' : '\\\\$',
    'exclam' : '!',
    'question' : '?',
    'plus' : '+',
    'slash' : '/',
    'numbersign' : '\\\\#',
    'at' : '\\\\@',
    'bar' : '|',
    'grave' : '`',
    'asciitilde' : '\\\\~',
    'asciicircum' : '\\\\^',
    'asterisk' : '*',
    'ampersand' : '&',
    'parenleft' : '(',
    'parenright' : ')',
    'bracketleft' : '[',
    'bracketright' : ']',
    'braceleft' : '{',
    'braceright' : '}',
    'apostrophe' : "'",
    'quotedbl' : '"',
    'backslash' : '\\\\',
    'colon' : ':',
    'semicolon' : ';',
    'percent' : '%',
    'equal' : '=',
    'space' : ' ',
    'Left' : '\\UF702',
    'Right' : '\\UF703',
    'Up' : '\\UF700',
    'Down' : '\\UF701',
    'BackSpace' : '\\U0008',
    'Home' : '\\UF729',
    'End' : '\\UF72B',
    'Prior' : '\\UF72C', # PageUp
    'Next' : '\\UF72D',  # PageDown
    'Return' : '\\U000A',
    'Delete' : '\\UF728',
    'Insert' : '\\UF727',

    'Multi_key' : MULTI_KEY,
}

def qv(ch):
    if ch == '"':
        return f'"\\{ch}"'
    else:
        return f'"{ch}"'

def bindingdict(data, indent):
    first = True
    print(" " * max(indent, 0) + "{")
    for key in sorted(data.keys()):
        value = data[key]
        # if first:
        #     first = False
        # else:
        #     print()
        ky = key
        if key in translate:
            ky = translate[key]
        # Doesn't handle things above UFFFF, but I don't know the right
        # syntax for that anyway.
        if HEXRE.fullmatch(ky):
            ky = "\\" + ky
        elif not (len(ky) == 1 or ky.startswith("\\")):
            # XXXX Can leave empty dictionaries if all entries are weird!
            # (this turns out not to be a problem, but is still suboptimal)
            continue            # Skip weird.
        print(" " * max(indent+INDENT, 0) + qv(ky) + " = ", end="")
        if isinstance(value, dict):
            bindingdict(value, abs(indent + INDENT))
        else:
            print(f'  ("insertText:", {qv(value)});')
    print(" " * max(indent, 0) + "};")

dd = readcomposefiles()
bindingdict(dd, 0)

# XXXX Don't forget to remove the semicolon after the close-brace
# on the last line!!!
