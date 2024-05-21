#!/usr/bin/perl

use UUID::Pure;


my $uuid = uuidv7();
print "uuid v7: " . $uuid . "\n";

my $tms = uuid2tms($uuid);
print "time from uuid v7: " . scalar localtime(int($tms/1000)) . "\n";


my $uuidv8 = uuidv8('shard1');
print "uuid v8: " . $uuidv8 . "\n";

my $tmsv8 = uuid2tms($uuidv8);
print "time from uuid v8: " . scalar localtime(int($tmsv8/1000)) . "\n";

