use strict;
use warnings;
use vars qw($VERSION %IRSSI);

use Irssi;
use Irssi::Irc;
%IRSSI = (
	authors => 'Bjorn Stange',
	contact => 'bjorn248@gmail.com',
	name => 'findsix',
	description => 'Find which nickname is six among the current idlers of #drive-in',
);
my @six;
my $windowitem;
sub find_six {
	my ($data, $server, $witem) = @_;
	$windowitem = $witem;
	$witem->command("MSG ".$witem->{name}." Searching for Sixmsj in the channel...");
	$server->redirect_event("who", 1, "#drive-in", 0, "", { "event 352" => "redir who", "event 315" => "end stuff", "" => "event empty" });
	$server->send_raw("WHO #drive-in");
}

sub check_six {
	my @out = @_;
	my @who = split(/\s+/, $out[1]);
	my $mask = $who[3];
	if ($mask =~ m/98brov/ || $mask =~ m/qimmtt/ || $who[2] =~ m/james/i) {
		push(@six, $who[5]);
	}
}

sub finish {
	my $length = scalar(@six);
	if ($length == 0) {
		$windowitem->command("MSG ".$windowitem->{name}." Sixmsj not found...");
	}
	else {		
		$windowitem->command("MSG ".$windowitem->{name}." Sixmsj detected :O");
		$windowitem->command("MSG ".$windowitem->{name}." Sixmsj is: @six");
		undef(@six);
	}
}

Irssi::signal_add('redir who', 'check_six');
Irssi::command_bind('findsix', 'find_six');
Irssi::signal_add('end stuff', 'finish');
