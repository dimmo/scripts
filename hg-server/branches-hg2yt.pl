#!/usr/bin/perl
use strict;
$\=$/;

# Script to sync HG branches with YT enum bundle
# Works with YouTrack 6.5

####### Config #######
my $HG_REPO='/path/to/hg/repo';
my $YT_HOST='localhost';
my $YT_AUTH='LOGIN:PASSWORD';        # DO NOT COMMIT REAL CREDENTIALS !
my $YT_BUND='YT_BUNDLE_NAME';
######################

print scalar localtime;

my %hg = map { /^(.*?)\s+\d+:/; $1,1 } `hg -R $HG_REPO branches`;
my %yt = map { $_,1 } `curl --silent https://$YT_HOST/rest/admin/customfield/bundle/$YT_BUND -u $YT_AUTH` =~ m|<value[^>]*>(.*?)</value>|g;

print "HG: ", join",",sort keys %hg;
print "YT: ", join",",sort keys %yt;

for (sort keys %hg) {
        next if $yt{$_};
        print "Add to YT: $_";
        `curl --silent https://$YT_HOST/rest/admin/customfield/bundle/$YT_BUND/$_ -u $YT_AUTH -X PUT`;
}