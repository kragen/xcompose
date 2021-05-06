#!/usr/bin/env -S perl -p
use feature 'unicode_strings';
use utf8;
BEGIN { binmode(STDOUT, ":utf8");
	binmode(STDIN, ":utf8");

%specials = ('%' => 'percent',
	     '-' => 'minus',
	     '_' => 'underscore',
	     '>' => 'greater',
	     '<' => 'less',
	     ',' => 'comma',
	     '.' => 'period',
	     '$' => 'dollar',
	     '!' => 'exclam',
	     '?' => 'question',
	     '+' => 'plus',
	     '/' => 'slash',
	     '#' => 'numbersign',
	     '@' => 'at',
	     '|' => 'bar',
	     '`' => 'grave',
	     '~' => 'asciitilde',
	     '^' => 'asciicircum',
	     '(' => 'parenleft',
	     ')' => 'parenright',
	     '[' => 'bracketleft',
	     ']' => 'bracketright',
	     '{' => 'braceleft',
	     '}' => 'braceright',
	      # Not strictly necessary:
	     '❴' => 'braceleft',
	     '❵' => 'braceright',
	     "'" => 'apostrophe',
	     '"' => 'quotedbl',
	     '\\' => 'backslash',
	     ':' => 'colon',
	     ';' => 'semicolon',
	     '=' => 'equal',
	     ' ' => 'space',
	     '*' => 'asterisk',
             '&' => 'ampersand',
	     '♫' => 'Multi_key',
             '←' => 'Left',
             '→' => 'Right',
             '↑' => 'Up',
             '↓' => 'Down',
             '⇐' => 'BackSpace',
             '⇤' => 'Home',
             '⇥' => 'End',
             '⇑' => 'Prior',    # PageUp
             '⇓' => 'Next',     # PageDown
             '↵' => 'Return',
             '∇' => 'Delete',   # Del, get it?
             '˅' => 'Insert',   # it'll do.
             '˃' => 'Control_R',
             '˂' => 'Control_L',
             # Function-keys? ¹ ²..ˣ ᵉ ᵗ?
);

        $specials = join "", keys %specials;
        # Because of reasons
        $specials =~ s/[]\\-]/\\$&/g;
        $RE = qr{([[:alnum:]$specials]+)};

sub splitup {
    my $arg=shift;
    local $_;
    my @out;
    my $rv;
    return "\{$arg\}" if length($arg) > 7;
    @out=split //, $arg;
    $rv="";
    for (@out) {
	$_ = $specials{$_} // $_;
	$rv .= " <$_>";
    }
    return $rv;
}

}

unless (/^#/) {
    my $hold=$_;
    s/<M_>/<Multi_key>/;
    s/<MM>/<Multi_key> <Multi_key>/;
    s({($RE)})(splitup($1))e;
    if (length($1) > 7) {
	$_=$hold;
	s/^<M([M_])>/### <M$1>/;
    }
}
