#!/usr/bin/perl -n

BEGIN {binmode(STDOUT, ":utf8");}

print "#- $_";
@_=split /;/;
printf qq(<MM> \{%s\} :  "%s"   U%s\t# %s\n), lc($_[1]),chr(hex($_[0])), $_[0], $_[1];


