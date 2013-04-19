use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
use Fcntl;

$VERSION = '0.0.3';
%IRSSI = (
		authors     => 'Thorsten Leemhuis',
		contact     => 'fedora@leemhuis.info',
		name        => 'fnotify',
		description => 'Write a notification to a file that shows who is talking to you in which channel.',
		url         => 'http://www.leemhuis.info/files/fnotify/',
		license     => 'GNU General Public License',
		changed     => '$Date: 2007-01-13 12:00:00 +0100 (Sat, 13 Jan 2007) $'
		);

#--------------------------------------------------------------------
# In parts based on knotify.pl 0.1.1 by Hugo Haas
# http://larve.net/people/hugo/2005/01/knotify.pl
# which is based on osd.pl 0.3.3 by Jeroen Coekaerts, Koenraad Heijlen
# http://www.irssi.org/scripts/scripts/osd.pl
#
# Other parts based on notify.pl from Luke Macken
# http://fedora.feedjack.org/user/918/
#
#--------------------------------------------------------------------

sub priv_msg {
	my ($server,$msg,$nick,$address,$target) = @_;
	filewrite("PM: $nick> $msg");
}

sub pub_msg {
	my ($server, $msg, $nick, $address, $target) = @_;
	if (($msg =~ /raylu/ || $msg =~ /\@raymond/) && $target ne '#github') {
		filewrite("$target: $nick> $msg");
	}
}

sub filewrite {
	my ($text) = @_;
	my $fifo = "/home/raylu/irssi";
	if (-p $fifo) {
		sysopen(FILE, $fifo, O_WRONLY | O_APPEND | O_NONBLOCK);
		print FILE $text . "\n";
		close(FILE);
	}
}

Irssi::signal_add_last("message private", "priv_msg");
Irssi::signal_add_last("message public", "pub_msg");
