#!/usr/bin/perl
#
# shaarli insists on a writable home directory.
#
# Copyright (C) 2014 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;

use UBOS::Utils;
use POSIX;


if( 'deploy' eq $operation ) {
    my $dir      = $config->getResolve( 'appconfig.apache2.dir' );
    
    my $apacheUname = $config->getResolve( 'apache2.uname' );
    my $apacheGname = $config->getResolve( 'apache2.gname' );

    my $apacheUid = UBOS::Utils::getUid( $apacheUname );
    my $apacheGid = UBOS::Utils::getGid( $apacheGname );
    
    chown $apacheUid, $apacheGid, $dir;
}

1;
