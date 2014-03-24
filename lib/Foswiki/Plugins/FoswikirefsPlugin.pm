package Foswiki::Plugins::FoswikirefsPlugin;

# Always use strict to enforce variable scoping
use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION = '0.1';
our $RELEASE = '0.1';

# One line description of the module
our $SHORTDESCRIPTION =
  'Convert Foswiki Subversion rev numbers to git hashrefs';

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

    # Plugin correctly initialized
    return 1;
}

sub _REV2REF {
    my ( $session, $params, $topic, $web, $topicObject ) = @_;

    require Foswiki::Plugins::FoswikirefsPlugin::RefTable;

    my $rev = $_[1]->{_DEFAULT};
    return "Invalid svn rev" unless $rev =~ m/^[0-9]{1,5}$/;
    return Foswiki::Plugins::FoswikirefsPlugin::RefTable::mapRev($rev);
    return "Rev $rev not found";
}

1;

