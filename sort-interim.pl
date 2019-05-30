#!/usr/bin/env perl

my $this;
my %elts;

sub process {
    my $data = shift;
    my $key;

    $data =~ m@\s+U([[:xdigit:]]+)\s+@;
    $key=$1;
    if ($elts{$key}) {
	print STDERR "Warning: key $key found more than once.\n";
    }
    $elts{$key}=$data;
}

while (<>) {
    if (/(?:###\+)?<MM>/) {
	while (/(?:###\+)?<MM>/) {
	    $this .= $_;
	    $_ = <>;
	}
	process $this;
	$this='';
    }
    $this .= $_;
}

for $k (sort { hex($a) <=> hex($b) } keys %elts) {
    print $elts{$k};
}
