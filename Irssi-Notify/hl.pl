use strict;
use vars qw($VERSION %IRSSI);
use IPC::System::Simple qw(systemx);

use Irssi;
use Config;
%IRSSI = (
	authors => 'Bjorn Stange',
	contact => 'bjorn248@gmail.com',
	name => 'hl',
	description => 'Create a notification using growlnotify or libnotify (specifically notify-send) if your nickname is used in the channel chat or if you recieve a private message.',
);

my $isMac;

if ($Config{osname} =~ /darwin/) {
    $isMac = 1;
}
else {
    $isMac = 0;
}

sub priv_msg {
	my ($server, $msg, $nick, $address, $target) = @_;
	my @date = split(/\s+/,`date`);
	my $time = $date[3];
    if ($isMac) {
        systemx("growlnotify", ("-t", "PM from $nick at $time", "-m", $msg))
    }
    else {
        systemx("notify-send", ("PM:  $time : $nick: $msg"))
    }
}

sub highlight {
        my ($dest, $text, $stripped) = @_;
        if ($dest->{level} & MSGLEVEL_HILIGHT) {
		my @date = split(/\s+/,`date`);
		my $time = $date[3];
        if ($isMac) {
            systemx("growlnotify", ("-t", "$dest->{target}:  $time", "-m", $stripped))
        }
        else {
            systemx("notify-send", ("$dest->{target}:  $time : $stripped"))
        }
	}
}

Irssi::signal_add('message private', 'priv_msg');
Irssi::signal_add("print text", "highlight");
