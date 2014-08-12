# See the bottom of the file for description, copyright and license information
package FoswikirefsPluginTests;

# SMELL: this test suite was retro-fitted to an existing plugin, and
# does *not* test spam removal from topics. It *only* tests the
# registration handlers and removeUser REST handler.

use FoswikiFnTestCase;
our @ISA = qw( FoswikiFnTestCase );

use strict;
use Error (':try');

sub new {
    my $self = shift()->SUPER::new(@_);
    return $self;
}

sub set_up {
    my $this = shift;
    $this->SUPER::set_up();

}

sub loadExtraConfig {
    my $this = shift;
    $this->SUPER::loadExtraConfig();
    $Foswiki::cfg{Plugins}{FoswikirefsPlugin}{Enabled} = 1;
    $Foswiki::cfg{Plugins}{FoswikirefsPlugin}{Module} =
      'Foswiki::Plugins::FoswikirefsPlugin';
}

sub tear_down {
    my $this = shift;
    $this->SUPER::tear_down();
}

sub test_GITREF {
    my $this = shift;

    my $t = Foswiki::Func::expandCommonVariables("%GITREF{123412341234}%");
    $this->assert_equals(
'[[https://github.com/foswiki/core/commit/123412341234][core:123412341234]]',
        $t
    );

    $t = Foswiki::Func::expandCommonVariables(
        "%GITREF{FoswikiprefsPlugin:123412341234}%");
    $this->assert_equals(
'[[https://github.com/foswiki/FoswikiprefsPlugin/commit/123412341234][FoswikiprefsPlugin:123412341234]]',
        $t
    );

    $t = Foswiki::Func::expandCommonVariables(
        "%GITREF{foobar:experimental:123412341234}%");
    $this->assert_equals(
'[[https://github.com/foobar/experimental/commit/123412341234][experimental:123412341234]]',
        $t
    );
}

sub test_REF2REF {
    my $this = shift;

    my $t = Foswiki::Func::expandCommonVariables("%REV2REF{0}%");
    $this->assert_equals( 'Rev 0 not found', $t );
    $t = Foswiki::Func::expandCommonVariables("%REV2REF{12}%");
    $this->assert_equals( 'Rev 12 not found', $t );
    $t = Foswiki::Func::expandCommonVariables("%REV2REF{-1}%");
    $this->assert_equals( 'Invalid svn rev', $t );
    $t = Foswiki::Func::expandCommonVariables("%REV2REF{a1}%");
    $this->assert_equals( 'Invalid svn rev', $t );
    $t = Foswiki::Func::expandCommonVariables("%REV2REF{123534}%");
    $this->assert_equals( 'Invalid svn rev', $t );

    $t = Foswiki::Func::expandCommonVariables("%REV2REF{15}%");
    $this->assert_equals(
'[[https://github.com/foswiki/FastCGIEngineContrib/commit/e2de71d92065][FastCGIEngineContrib:e2de71d92065]] [[https://github.com/foswiki/UnitTestContrib/commit/31615cdcf42b][UnitTestContrib:31615cdcf42b]]',
        $t
    );

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
