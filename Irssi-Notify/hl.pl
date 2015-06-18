use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
use Config;
%IRSSI = (
    authors => 'Bjorn Stange',
    contact => 'bjorn248@gmail.com',
    name => 'hl',
    description => 'Create a notification using osascript (yosemite and up I believe) or libnotify (specifically notify-send) if your nickname is used in the channel chat or if you recieve a private message.',
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
        `osascript -e 'display notification "$msg" with title "PM from $nick at $time"'`;
    }
    else {
        `notify-send "PM:  $time : $nick: $msg"`;
    }
}

sub highlight {
        my ($dest, $text, $stripped) = @_;
        if ($dest->{level} & MSGLEVEL_HILIGHT) {
        my @date = split(/\s+/,`date`);
        my $time = $date[3];
        if ($isMac) {
            `osascript -e 'display notification "$stripped" with title "$dest->{target}:  $time"'`;
        }
        else {
            `notify-send "$dest->{target}:  $time : $stripped"`;
        }
    }
}

Irssi::signal_add('message private', 'priv_msg');
Irssi::signal_add("print text", "highlight");
