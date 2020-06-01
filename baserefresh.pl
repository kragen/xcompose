#!/usr/bin/perl -n
my $last;

# The whole "base" file format took shape kind of sloppily, just getting a
# list of likely-looking characters and all, which is why it's sort of a
# mess.  It also didn't really have good ways of updating it with new
# emoji.  This file is _part_ of such a solution: it takes in a "base" file
# and adds the "<MM>" line after just those "#-" lines which are not
# followed by a line that starts with "##" or with NO #-signs.

BEGIN {binmode(STDOUT, ":utf8");
       binmode(STDIN, ":utf8");
}

while (/^#- /) {
    $last = $_;
    print;
    $_ = <>;
    if (/^[^#]/ or /^##/) {
        last;
    }
    $last = substr($last, 3);
    @_ = split /;/, $last;
    printf qq(<MM> \{%s\} :  "%s"   U%s\t# %s\n), lc($_[1]),chr(hex($_[0])), $_[0], $_[1];
}
print;

