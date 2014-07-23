#!/usr/bin/perl
#
# shaarli insists on a writable home directory.
#

use strict;

use IndieBox::Utils;
use POSIX;


if( 'install' eq $operation ) {
    my $dir      = $config->getResolve( 'appconfig.apache2.dir' );
    
    my $apacheUname = $config->getResolve( 'apache2.uname' );
    my $apacheGname = $config->getResolve( 'apache2.gname' );

    my $apacheUid = IndieBox::Utils::getUid( $apacheUname );
    my $apacheGid = IndieBox::Utils::getGid( $apacheGname );
    
    chown $apacheUid, $apacheGid, $dir;
}

1;
