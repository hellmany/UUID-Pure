package UUID::Pure;

use warnings;
use strict;
use Time::HiRes qw(gettimeofday);
use Math::BigInt;
use Digest::SHA qw(sha256_hex);
our $VERSION = '0.01';


use Exporter qw(import);
our @ISA = qw(Exporter);
our @EXPORT = qw(uuidv8 uuidv7 uuid2tms);
our @EXPORT_OK = qw(uuidv8 uuidv7 uuid2tms);


sub uuid2tms
{
	my $uuid = shift;
	$uuid =~ s/-//g;
	my $t = substr($uuid,1,11);
	return Math::BigInt->from_hex($t);
}



sub uuidv8
{
	my $data = shift || rand();

	my $hash = sha256_hex($data);
	my $time_ms = int(gettimeofday*1000);

	my $t_ms = Math::BigInt->new($time_ms);
	my $lpad = _lapd($t_ms->bfloor->to_hex,12,0) . '8';

	my $f = substr($hash,1,3) . '8';
	my $l = substr($hash,5,15);
	my $uuidv7_str = $lpad . $f .  $l;
	$uuidv7_str =~ /^(\w{8})(\w{4})(\w{4})(\w{4})(\w+)$/;
	my $uuidv7_formatted = $1 . "-" . $2 . "-" . $3 . "-" . $4 . "-" . $5;
	wantarray() ? return ($uuidv7_formatted,$time_ms) : $uuidv7_formatted;
}




sub uuidv7
{
	my $time = shift || gettimeofday;
	my $time_ms = int($time*1000);

	my $t_ms = Math::BigInt->new($time_ms);
	my $lpad = _lapd($t_ms->bfloor->to_hex,12,0) . '7';
  
  srand();
	my $uuid_str = gettimeofday . rand() . $$ . $time;
	my $sha256_hex = sha256_hex($uuid_str);

	my $f = substr($sha256_hex,0,3);
	my $s = Math::BigInt->new(8+int(rand()*3))->to_hex;
	my $l = substr($sha256_hex,3,15);
	my $uuidv7_str = $lpad . $f . $s . $l;
	$uuidv7_str =~ /^(\w{8})(\w{4})(\w{4})(\w{4})(\w+)$/;
	my $uuidv7_formatted = $1 . "-" . $2 . "-" . $3 . "-" . $4 . "-" . $5;
	wantarray() ? return ($uuidv7_formatted,$time_ms) : $uuidv7_formatted;
}

sub _lapd {
	my ($str, $len, $chr) = @_;
	$chr = " " unless (defined($chr));
	return substr(($chr x $len) . $str, -1 * $len, $len);
} 

__DATA__

=head1 NAME

UUID::Pure - Generate UUID v7/v8 and get timestamp in ms from it

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

   use UUID::Pure;

   my $uuid = uuidv7(); # gen uuid v7
   my $uuidv8 = uuidv8(); # gen uuid v8

   my $tms = uuid2tms($uuid); # get timestamp in ms from uuid v7/v8
   
	

