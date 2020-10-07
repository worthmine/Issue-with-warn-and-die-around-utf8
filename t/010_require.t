use usw;
use Test::More 0.98;
use Encode qw(encode_utf8 decode_utf8);
use lib 'lib';

my @libs = qw(
    ASCII::Plain
    ASCII::で
    日本語::Plain
    日本語::で
);

note 'start to require';
eval "require $_" || warn $@ for @libs;             # there is no warnings;
note $_ for sort keys %INC;                         # it seems they succeed to be required;
note 'end to require';

#require_ok($_) for @libs;                           # last two fail, why?
#require_ok( encode_utf8 $_) for @libs;              # other than first one fail, why?

require_ok($_) for map { _getPath($_) } @libs;    # pass

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
