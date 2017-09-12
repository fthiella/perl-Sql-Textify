#!/usr/bin/perl

=head1 NAME

sqltextify.pl - Shell interface to SQL::Textify, run a SQL query and get the result in text format (markdown, html, csv)

=head1 SYNOPSIS

    sqltextify.pl --sql=query.sql --conn="dbi:SQLite:dbname=test.sqlite3" --username=admin --password=pass

=head1 DESCRIPTION

I like text editors, I have fallen in love with Sublime Text,
and everything I write is in Markdown syntax!

This simple Perl sript executes SQL queries and produces
Markdown output. It can be easily integrated with Sublime Text
editor, but it can also be used at the command line.

=head1 LICENSE

This is released under the Artistic 
License. See L<perlartistic>.

=head1 AUTHOR

Federico Thiella - GitHub projects L<https://github.com/fthiella/>
or email L<mailto:fthiella@gmail.com>

=cut

use strict;
use warnings;
 
use DBI;
use File::Slurp;
use Getopt::Long;
use utf8;
use Sql::Textify;

our $VERSION = "0.01";
our $RELEASEDATE = "September 10th, 2017";

=head1 OPTIONS

sqltextify.pl supports a number of command line options which control
the behaviour of the output document.

The options are:

=over

=item source, s

source SQL file

=item conn, c

DBI connection string

=item username, u

Specify the database username.

=item password, p

Specify the database password.

=item maxwidth, mw

Set a maximum width for the columns when in markdown format mode. If any column contains
a string longer than maxwidth it will be cropped.

=item format, f

Output format (markdown default, html)

=item layout, l

Output layout (table default, record)

=back
=cut

# CLI Interface

sub do_help {
	print <<endhelp;
Usage: sqlbuild.pl [options]
       perl sqlbuild.pl [options]

Options:
  -s, --sql         source SQL file
  -c, --conn        specify DBI connection string
  -u, --username    specify username
  -p, --password    specify password
  -mw, --maxwidth   maximum width column for markdown (if unspecified get from actual data)
  -f, --format      output format (markdown -default- or html)
  -l, --layout      output layout (table -default- or record)
  -v, --version     show current version

Project GitHub page: https://github.com/fthiella/Sql-mk-builder
endhelp
}

sub do_version {
	print "sqltextify $VERSION ($RELEASEDATE)\n";
}

# added utf8 support
# FIXME: still need to verify if it's always working
use open ':std', ':encoding(UTF-8)';

# Get command line options
my $source;
my $version;
my $conn;
my $username;
my $password;
my $maxwidth;
my $format;
my $layout;
my $help;

GetOptions(
	'sql|s=s'      => \$source,
	'version|v'    => \$version,
	'conn|c=s'     => \$conn,
	'username|u=s' => \$username,
	'password|p=s' => \$password,
	'maxwidth|w=i' => \$maxwidth,
	'format|f=s'   => \$format,
	'layout|l=s'   => \$layout,
	'help|h'       => \$help,
);

if ($help)
{
	do_help;
	exit;
}

if ($version)
{
	do_version;
	exit;
}

die "Please specfy sql source with -s or -sql\n" unless ($source);

# read the input file
my $sql = read_file($source);

# FIXME: over simplified regex, and also need to decide which parameter has to take precedence, the command line or the C-comment?

unless ($conn)     { ($conn) = $sql =~ /conn=\"([^\""]*)\"\s/; }
unless ($username) { ($username) = $sql =~ /username=\"([^\""]*)\"\s/; }
unless ($password) { ($password) = $sql =~ /password=\"([^\""]*)\"\s/; }
unless ($maxwidth) { ($maxwidth) = $sql =~ /maxwidth=\"([^\""]*)\"\s/; }
unless ($format)   { ($format) = $sql =~ /format=\"([^\""]*)\"\s/; }
unless ($layout)   { ($layout) = $sql =~ /layout=\"([^\""]*)\"\s/; }

# default
unless ($format)   { $format = 'markdown'; }
unless ($layout)   { $layout = 'table';   }

my $dbh = DBI->connect($conn, $username, $password)
|| die $DBI::errstr;

# FIXME is foreach needed? textify will process multiple queries already

foreach my $sql_query (split /;\s*/, $sql) {
	# remove comments from sql_query (some drivers will remove automatically but other will throw an error)
	# (simple regex, it will work only on simplest cases, please see http://learn.perl.org/faq/perlfaq6.html#How-do-I-use-a-regular-expression-to-strip-C-style-comments-from-a-file)
	$sql_query =~ s/\/\*.*?\*\///gs;

	my $t = new Sql::Textify(
		conn => $conn,
		username => $username,
		password => $password,
		maxwidth => $maxwidth,
		format => $format,
		layout => $layout
	);

	print $t->textify($sql_query);
}

print "\n";
