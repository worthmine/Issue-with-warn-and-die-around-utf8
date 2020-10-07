use usw;
use Test::More 0.98;
use lib 'lib';

my @libs = qw(
    ASCII::Plain
    ASCII::で
    日本語::Plain
    日本語::で
);

use_ok $_ for @libs;

for (@libs) {
    my $class = new_ok($_);
    $class->セイ( ref $class, '::やー' );

}

done_testing;
