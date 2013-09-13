#!/usr/bin/perl 
#
use strict;
use warnings;
use diagnostics;
use IO::Handle;

sub event($$);
sub update($);

my $line;
my $time;
my $prog;
my $text;
my $client;
my $current_time = 0;
my $step         = 300;
my %sum = (rejected     => 0,
           sent         => 0,
           bounced      => 0,
           deferred     => 0,
       	   expired      => 0,
           received     => 0,
           virus        => 0,
           spam         => 0);

while (defined($line = <STDIN>)) {
	($time, $prog, $text) = ($line =~ m/(\d+)\s+(\S+)\s+(.*)/x);

	if ($prog =~ /^postfix/) {
		if ($text =~ /reject:/) {
			event($time, "rejected");
		}
		elsif ($text =~ /status=sent/) {
			if (($text !~ /\brelay=[^\s\[]*\[127\.0\.0\.1\]/) and ($text !~ /spamtrap\@.+/)) {
				event($time, "sent");
			}
		}
		elsif ($text =~ /status=bounced/) {
			event($time, "bounced");
		}		
		elsif ($text =~ /status=deferred/) {
			event($time, "deferred");
		}
		elsif ($text =~ /status=expired/) {
			event($time, "expired");
		}
		elsif ($text =~ /^[0-9A-F]+: client=(\S+)/) {
			$client = $1;
			if ($client !~ /\[127\.0\.0\.1\]$/) {
				event($time, "received");
			}
		}
	}
	elsif ($prog =~ /^amavis/) {
		if ($text =~ /Virus/) {
			event($time, "virus");
		}
		elsif ($text =~ /Blocked SPAM/) {
			event($time, "spam");
		}
	}
}

sub event($$) {
	my ($time, $type) = @_;
	update($time) and $sum{$type}++;
}

sub update($) {
	my $time = shift;
	my $m = $time - $time % $step;
	
	if ($m == $current_time) {
		return 1;
	}
	elsif ($m < $current_time)  {
		return 0;
	}
	else {
		`echo $sum{rejected} > /var/tmp/mailrejected`;
		`echo $sum{sent} > /var/tmp/mailsent`;
		`echo $sum{bounced} > /var/tmp/mailbounced`;
		`echo $sum{deferred} > /var/tmp/maildeferred`;
		`echo $sum{expired} > /var/tmp/mailexpired`;
		`echo $sum{received} > /var/tmp/mailreceived`;
		`echo $sum{virus} > /var/tmp/mailvirus`;
		`echo $sum{spam} > /var/tmp/mailspam`;
		
		$current_time   = $m;
               	$sum{rejected}  = 0;
		$sum{sent}      = 0;
		$sum{bounced}   = 0;
		$sum{deferred}  = 0;
                $sum{expired}   = 0;
                $sum{received}  = 0;
                $sum{virus}     = 0;
                $sum{spam}      = 0;
		
		return 1;
	}
}