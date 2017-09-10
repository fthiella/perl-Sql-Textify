package Sql::Textify::t::Textify;

use Test::Class::Most parent => 'Sql::Textify::Test::Class';

sub test_basic_class_format : Tests {
	my $self = shift;

	my $t = new Sql::Textify;

    ok( defined $t,               'new() returned something' );
    ok( $t->isa('Sql::Textify'),  "and it's the right class" );
    is( $t->{format}, 'markdown', 'default format markdown'  );

    # test formats

    my @formats = (
      	{ format => 'markdown', valid => 1 },
    	{ format => 'html',     valid => 1 },
    	{ format => 'json',     valid => 0 }
    );

    foreach my $f (@formats) {

    	if ($f->{valid}) {
	    	my $t = new Sql::Textify(format => $f->{format});
    		is( $t->{format}, $f->{format}, "format $f->{format}");
    		} else {
    			dies_ok {
    				new Sql::Textify(format => $f->{format});
    			} 'dies on invalid format';
    		}
    }

}

sub test_sql_settings : Tests {
	my $self = shift;
	my $t = new Sql::Textify;

	my $sql = $self->content_for_tests('simple');
	$t->textify($sql);
	like( $t->{conn},   qr|dbi:SQLite:dbname=(.*?)/samples\.db|, 'got correct connection string');
	is( $t->{format},   'markdown', 'still got markdown format');
	is( $t->{username}, 'username', 'got correct username');
	is( $t->{password}, 'password', 'got correct password');
	is( $t->{maxwidth}, undef,      'max width correctly undefined');
}

sub test_queries : Tests {
    my $self = shift;
    my $t = new Sql::Textify;

    my $tests = $self->records_for_tests;

    foreach my $test (@{ $tests }) {

        foreach my $result (@{ $test->{results} }) {
            $t->{format} = $result->{format}[0];
            $t->{layout} = $result->{format}[1];

            is( $t->_Do_Format($test->{data}), $result->{text}, "Test name=$test->{name}, format=$result->{format}[0], layout=$result->{format}[1]");
        }
    }
}

1;
