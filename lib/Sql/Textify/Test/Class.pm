package Sql::Textify::Test::Class;

use Test::Class::Most;
use strict;
use warnings;
use Sql::Textify;
use File::Temp;

sub records_for_tests {
  my ($self) = shift;

  my $test_ref = [
  # Simple Recordset
    {
      name => 'Simple Recordset',
      data => {
        fields => ['one', 'two'],
        rows => [
          ['first', 'second']
        ],
      },
      results => [
        {
          format => ['markdown', 'table'],
          text => '
one   | two   
------|-------
first | second
',
        },
        {
          format => ['markdown', 'record'],
          text => '# Record 1

Column | Value 
-------|-------
one    | first 
two    | second

',
        },
        {
          format => ['html', 'table'],
          text => '<table>
<thead>
  <th>one</th>
  <th>two</th>
</thead>
<tbody>
<tr>
  <td>first</td>
  <td>second</td>
</tr>
</tbody>
</table>

',
        },
        {
          format => ['html', 'record'],
          text => '<h1>Record 1</h1>

<table>
<tr>
  <th>one</th>
  <td>first</td>
</tr>
<tr>
  <th>two</th>
  <td>second</td>
</tr>
</table>

',
      }
      ]
    },
  #
  # More Lines
  #
    {
      name => 'More Lines',
      data => {
        fields => ['one', 'two'],
        rows => [
          ['first', 'second'],
          ['the loneliness of the long distance runner', 'long row']
        ],
      },
      results => [
        {
          format => ['markdown', 'table'],
          text => '
one                                        | two     
-------------------------------------------|---------
first                                      | second  
the loneliness of the long distance runner | long row
',
        },
        {
          format => ['markdown', 'record'],
          text => '# Record 1

Column | Value 
-------|-------
one    | first 
two    | second

# Record 2

Column | Value                                     
-------|-------------------------------------------
one    | the loneliness of the long distance runner
two    | long row                                  

',
        },
        {
          format => ['html', 'table'],
          text => '<table>
<thead>
  <th>one</th>
  <th>two</th>
</thead>
<tbody>
<tr>
  <td>first</td>
  <td>second</td>
</tr>
<tr>
  <td>the loneliness of the long distance runner</td>
  <td>long row</td>
</tr>
</tbody>
</table>

',
        },
        {
          format => ['html', 'record'],
          text => '<h1>Record 1</h1>

<table>
<tr>
  <th>one</th>
  <td>first</td>
</tr>
<tr>
  <th>two</th>
  <td>second</td>
</tr>
</table>

<h1>Record 2</h1>

<table>
<tr>
  <th>one</th>
  <td>the loneliness of the long distance runner</td>
</tr>
<tr>
  <th>two</th>
  <td>long row</td>
</tr>
</table>

',
      }
      ]
    },

  #
  # Quote Markdown and Html
  #
    {
      name => 'Quote Markdown and Html',
      data => {
        fields => ['column\'with"quotes|spaces and pipes', 'column<html>'],
        rows => [
          ['quotes \'"|space', '<h1></h1>'],
        ],
      },
      results => [
        { # there's not a standard way to quote markdown text
          # stackedit ignores html tags but interpreters correctly the quoted pipes .. markdown here ignores everyting
          format => ['markdown', 'table'],
          text => '
column\'with"quotes\|spaces and pipes | column<html>
-------------------------------------|-------------
quotes \'"\|space                     | <h1></h1>   
',
        },
        {
          format => ['html', 'table'],
          text => '<table>
<thead>
  <th>column&#39;with&quot;quotes|spaces and pipes</th>
  <th>column&lt;html&gt;</th>
</thead>
<tbody>
<tr>
  <td>quotes &#39;&quot;|space</td>
  <td>&lt;h1&gt;&lt;/h1&gt;</td>
</tr>
</tbody>
</table>

',
        },
      ]
    },
  ];

  return $test_ref;
}

sub content_for_tests {
    my ($self, $want) = @_;

    my $simple_src = <<SIMPLE;
/*
  conn="dbi:SQLite:dbname=tmp/samples.db"
  username="username"
  password="password"
*/
select 'first' as one, 'second' as two
SIMPLE

    my $simple_markdown = <<SIMPLE_MARKDOWN;

one   | two   
------|-------
first | second
SIMPLE_MARKDOWN

    my $simple_markdown_record = <<SIMPLE_MARKDOWN_RECORD;
# Record 1

Column | Value 
-------|-------
one    | first 
two    | second

SIMPLE_MARKDOWN_RECORD

    my $simple_html = <<SIMPLE_HTML;
<table>
<thead>
  <th>one</th>
  <th>two</th>
</thead>
<tbody>
<tr>
  <td>first</td>
  <td>second</td>
</tr>
</tbody>
</table>

SIMPLE_HTML

    my $simple_html_record = <<SIMPLE_HTML_RECORD;
<h1>Record 1</h1>

<table>
<tr>
  <th>one</th>
  <td>first</td>
</tr>
<tr>
  <th>two</th>
  <td>second</td>
</tr>
</table>

SIMPLE_HTML_RECORD

    my $max_src = <<SETWIDTH;
/*
  conn="dbi:SQLite:dbname=tmp/samples.db"
  username="username"
  password="password"
  maxwidth="1"
*/
select 'first' as one, 'second' as two
SETWIDTH

    my $max_markdown = <<SETWIDTH_MARKDOWN;

o | t
--|--
f | s
SETWIDTH_MARKDOWN

    my $max_markdown_record = <<SETWIDTH_MARKDOWN_RECORD;
# Record 1

C | V
--|--
o | f
t | s

SETWIDTH_MARKDOWN_RECORD

    my $create_src = <<CREATE;
/*
  conn="dbi:SQLite:dbname=tmp/samples.db"
  username="username"
  password="password"
  maxwidth="1"
*/
drop table if exists test;

create table test (
  id int,
  description text
);

insert into test values
(1, 'first row'),
(2, 'second row'),
(3, 'third row');
CREATE


    my $create_markdown = <<CREATE_MARKDOWN;
0 rows
0 rows
0 rows
CREATE_MARKDOWN

	my $dir = File::Temp::tempdir( CLEANUP => 1 );

	$simple_src =~ s/\btmp\b/$dir/;
	$max_src =~ s/\btmp\b/$dir/;
	$create_src =~ s/\btmp\b/$dir/;

    return $simple_src               if $want eq 'simple';
    return $simple_markdown          if $want eq 'simple-markdown';
    return $simple_markdown_record   if $want eq 'simple-markdown-record';
    return $simple_html              if $want eq 'simple-html';
    return $simple_html_record       if $want eq 'simple-html-record';
    return $max_src                  if $want eq 'max';
    return $max_markdown             if $want eq 'max-markdown';
    return $max_markdown_record      if $want eq 'max-markdown-record';
    return $create_src               if $want eq 'create';
    return $create_markdown          if $want eq 'create-markdown';
    die "No content for '$want'";
}

1;