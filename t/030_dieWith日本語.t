# The same issue is available with `die`
use Test::More 0.98 tests => 3;
use Encode qw(is_utf8 encode_utf8 decode_utf8);
use lib 'lib';

local $SIG{__DIE__} = sub {
    use utf8;
    $_[0] =~ /(.+) at (.+) line (\d+)\.$/;
    return pass("plain text '$1' was died at $2 line $3.") unless is_utf8($1);
    my ( $str, $path, $line ) = ( $1, $2, $3 );
    if ( $_[0] =~ qr/^宣言/ ) {
        BAIL_OUT "code is broken" if $_[0] =~ /^\x{5BA3}\x{8A00}\x{3042}\x{308A}$/;

        pass encode_utf8 "decoded text '$str' was died at $path line $line.";

        # above cause mojibake, and below is strange
        pass encode_utf8 "decoded text '$str' was died at " . decode_utf8($path) . " line $line.";
    } else {
        my $encoded = encode_utf8 $_[0];
        fail "it's an unexpected dying: $encoded";
    }
};

no utf8;    # Of course it defaults no, but declare it explicitly
use strict;
use warnings;

my $ascii = 'no utf8';
my $plain = '宣言なし';

subtest 'Before use utf8' => \&plainTest;

subtest 'Inside of utf8' => sub {
    plan tests => 5;
    use utf8;
    my $decoded = '宣言あり';
    eval { die $ascii }   or pass("$ascii is an ASCII");
    eval { die $decoded } or pass("pass to die with decoded strings");
};

subtest 'after use utf8' => \&plainTest;

done_testing;

sub plainTest {
    plan tests => 4;
    eval { die $ascii } or pass("$ascii is an ASCII");
    eval { die $plain } or pass("$plain is a plain");
}
