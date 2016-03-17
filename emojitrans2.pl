#!/usr/bin/perl -p
BEGIN { binmode(STDOUT, ":utf8");
	binmode(STDIN, ":utf8");

%specials = ('%' => 'percent',
	     '-' => 'minus',
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
    s/<MM>/<Multi_key> <Multi_key>/;
    s({([][[:alnum:] _+%@><,.^\$+#()!/-]+)})(splitup($1))e;
}
