use usw;
use Test::More 0.98;
use lib 'lib';

my @libs = qw(
    ASCII::Plain
    ASCII::で
    日本語::Plain
    日本語::で
);
require_ok($_) for map { _getPath($_) } @libs;

for (@libs) {
    my $class = new_ok($_);
    $class->セイ( ref $class, '::やー' );
}

done_testing;

sub _getPath {
    local $_ = shift;
    s!::!/!g;
    return "$_.pm";
}
