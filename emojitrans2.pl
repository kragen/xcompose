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
);

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
    s({([][[:alnum:] _+:;%@>=`<,.^\$+#()?&!/|'"\\~*{}♫-]+)})(splitup($1))e;
    if (length($1) > 7) {
	$_=$hold;
	s/^<M([M_])>/### <M$1>/;
    }
}
