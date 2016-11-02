#!/usr/bin/perl
#
# Write and maintain shaarli configuration file
#

use strict;
use warnings;

use Digest::SHA1 qw( sha1_hex );
use UBOS::Utils  qw( saveFile slurpFile );
use POSIX;

my $dir      = $config->getResolve( 'appconfig.apache2.dir' );
my $dataDir  = "$dir/data";
my $confFile = "$dataDir/config.json.php";

if( 'deploy' eq $operation ) {
    my $apacheUname = $config->getResolve( 'apache2.uname' );
    my $apacheGname = $config->getResolve( 'apache2.gname' );

    my $login    = $config->getResolve( 'site.admin.userid' );
    my $password = $config->getResolve( 'site.admin.credential' );
    my $url      = $config->getResolve( 'site.protocol' )
                   . '://'
                   . $config->getResolve( 'site.hostname' )
                   . $config->getResolve( 'appconfig.context' )
                   . '/';
    my $title    = $config->getResolve( 'installable.customizationpoints.title.value' );
    my $timezone = $config->getResolve( 'installable.customizationpoints.timezone.value' );
    my $salt     = $config->getResolve( 'installable.customizationpoints.salt.value' );
    my $hash     = sha1_hex( $password . $login . $salt );
    
    my $confContent = <<END;
<?php /*
{
    "resource": {
        "data_dir": "data",
        "config": "data\/config.php",
        "datastore": "data\/datastore.php",
        "ban_file": "data\/ipbans.php",
        "updates": "data\/updates.txt",
        "log": "data\/log.txt",
        "update_check": "data\/lastupdatecheck.txt",
        "raintpl_tpl": "tpl\/",
        "raintpl_tmp": "tmp\/",
        "thumbnails_cache": "cache",
        "page_cache": "pagecache"
    },
    "security": {
        "ban_after": 4,
        "ban_duration": 1800,
        "session_protection_disabled": false,
        "open_shaarli": false
    },
    "general": {
        "header_link": "$url",
        "links_per_page": 20,
        "enabled_plugins": [
            "qrcode"
        ],
        "timezone": "$timezone",
        "title": "$title"
    },
    "updates": {
        "check_updates": false,
        "check_updates_branch": "stable",
        "check_updates_interval": 86400
    },
    "feed": {
        "rss_permalinks": true,
        "show_atom": true
    },
    "privacy": {
        "default_private_links": false,
        "hide_public_links": false,
        "hide_timestamps": false
    },
    "thumbnail": {
        "enable_thumbnails": true,
        "enable_localcache": true
    },
    "redirector": {
        "url": "",
        "encode_url": true
    },
    "plugins": [],
    "credentials": {
        "login": "$login",
        "salt": "$salt",
        "hash": "$hash"
    }
}
*/ ?>
END

    UBOS::Utils::saveFile( $confFile, $confContent, 0644, $apacheUname, $apacheGname );
}

if( 'undeploy' eq $operation ) {
    if( -e $confFile ) {
        UBOS::Utils::deleteFile( $confFile )
    }
}
1;
