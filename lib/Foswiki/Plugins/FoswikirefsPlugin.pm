# See the bottom of the file for description, copyright and license information
package Foswiki::Plugins::FoswikirefsPlugin;

use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION = '1.0';
our $RELEASE = '1.0';

our $SHORTDESCRIPTION = 'Display subversion rev, and git refs on Github';

our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 2.3 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between ',
            __PACKAGE__, ' and Plugins.pm' );
        return 0;
    }

    Foswiki::Func::registerTagHandler( 'REV2REF', \&_REV2REF );
    Foswiki::Func::registerTagHandler( 'GITREF',  \&_GITREF );

    # Plugin correctly initialized
    return 1;
}

sub _GITREF {

    #my ( $session, $params, $topic, $web, $topicObject ) = @_;

    my @p = split( ':', $_[1]->{_DEFAULT}, 3 );

    unshift @p, 'distro'  if ( scalar @p eq 1 );
    unshift @p, 'foswiki' if ( scalar @p eq 2 );

    return "[[https://github.com/$p[0]/$p[1]/commit/$p[2]][$p[1]:$p[2]]]";

}

sub _REV2REF {

    #my ( $session, $params, $topic, $web, $topicObject ) = @_;

    require Foswiki::Plugins::FoswikirefsPlugin::RefTable;

    my $rev = $_[1]->{_DEFAULT};
    return "Invalid svn rev" unless $rev =~ m/^[0-9]{1,5}$/;
    my $refmap = Foswiki::Plugins::FoswikirefsPlugin::RefTable::mapRev($rev);
    return "Rev $rev not found" unless defined $refmap;

    my @refs =
      split( /~/, $refmap );

    my $resp;

    foreach my $ref (@refs) {
        $resp .= "%GITREF{$ref}% ";
    }
    chop $resp;
    return $resp;
}

1;
__END__

Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2014 George Clark and Foswiki Contributors.
All Rights Reserved. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

For licensing info read LICENSE file in the Foswiki root.

Author: George Clark

