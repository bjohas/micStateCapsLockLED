#!/usr/bin/perl
use warnings;
use strict;
use open IO => ':encoding(UTF-8)', ':std';
use utf8;
use feature qw{ say };
use 5.18.2;
my $home = $ENV{HOME};
use Getopt::Long;
my $led = "";
my $monitor = "";
GetOptions (
    "led" => \$led,
    "monitor" => \$monitor,
    ) or die("Error in command line arguments\n");

if ($led) {
    $SIG{'INT'} = sub {	
	print "Bye LED.\n";
	&setLED("off");
	exit;
    };
    my $login = (getpwuid $>);
    die "must run with sudo" if $login ne 'root';
    say "LED STARTED";
    $| = 1;
    while (<STDIN>) {
	s/\n//;
	if ($_ eq "on" || $_ eq "off") {
	    &setLED($_);
	};
    };
    say "LED STOPPED";
} elsif ($monitor) {
    my $login = (getpwuid $>);
    die "must NOT run with sudo" if $login eq 'root';
    open F, "dbus-monitor \"path=/org/gnome/Shell,interface=org.gnome.Shell,member=ShowOSD\" |";
    my $s = "off";
    $| = 1;
    say &initialMicState();
    while (<F>) {
	$s = "on"  if m/"microphone-sensitivity-low-symbolic"/;
	$s = "off" if m/"microphone-sensitivity-muted-symbolic"/;
	say $s if m/"Internal Microphone"/;
    };
    close F;
} else {
    system "$0 --monitor | sudo $0 --led";
};

exit();

sub initialMicState {
    my $out =`pacmd list-sources | grep mute`;
    if ($out =~ m/muted\: yes/) {
	return "off";
    } elsif ($out =~ m/muted\: no/) {
	return "on";
    };
};

sub setLED {
    if ($_[0] eq "on") {
	say "mic on";
	system "echo 1 | sudo tee '/sys/class/leds/input3::capslock/brightness'";
    } else {
	say "mic off";
	system "echo 0 | sudo tee '/sys/class/leds/input3::capslock/brightness'";
    };
};



