#!/usr/bin/pkexec /usr/bin/perl
#
# ==========================================================================
#
# ZoneMinder Update Script, $Date$, $Revision$
# Copyright (C) 2001-2008 Philip Coombes
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# ==========================================================================
#
# This is a wrapper script that allows zoneminder to start and stop itself
# in a manner that keeps it in-sync with systemd.  This script is intended
# to be called internally by zoneminder and may not give the desired results
# if run from the command line.
#
use warnings;
use strict;
use bytes;
use ZoneMinder::Logger qw(:all);

my $command = $ARGV[0];

if ( (scalar(@ARGV) == 1) && ($command =~ /^(start|stop|restart)$/ )) {
	$command = $1;
} else {
	die(" USAGE: zmsystemctl.pl <start|stop|restart>\n");
}

my $path = qx(which systemctl);
chomp($path);

my $status = $? >> 8;
if ( !$path || $status ) {
	Fatal( "Unable to determine systemctl executable. Is systemd in use?" );
}

Info( "Redirecting command through systemctl\n" );
exec("$path $command zoneminder");

