# Sql::Textify

## NAME

Sql::Textify - Runs SQL queries and get the result in text format (markdown, html)

## VERSION

Version 0.01

## SYNOPSIS

    use Sql::Textify 'textify';
    my $text = textify( $sql );

    use Sql::Textify 'textify';
    my $text = textify( $sql, {
        conn => 'dbi:connection:string',
        username => 'username',
        password => 'password',
        format => 'markdown',
    } );

    use Sql::Textify;
    my $t = Sql::Textify->new;
    my $text = $t->textify( $sql );

    use Sql::Textify;
    my $t = Sql::Textify->new(
        conn => 'dbi:connection:string',
        username => 'username',
            password => 'password',
        format => 'markdown',
    );
    my $text = $t->textify( $sql );

## SYNTAX

This module executes SQL queries and produces text output (markdown,
html). Connection details, username and password can be specified in a
C-style multiline comment inside the SQL query:

    /*
        conn="dbi:SQLite:dbname=test.sqlite3"
        username="myusername"
        password="mypassword"
    */
    select * fom gardens;

or they can be specified using the constructor:

    my $t = new Sql::Textify(
        conn => 'dbi:SQLite:dbname=test.sqlite3',
        username => 'myusername',
        password => 'mypassword'
    );
    my $text = $t->textify('select * from gardens');

multiple queries can be separated by ; and also
insert/update/create/etc. queries are supported. If the query doesn't
return any row the string 0 rows will be returned.

## OPTIONS

Sql::Textify supports a number of options to its processor which
control the behaviour of the output document.

The options for the processor are:

### format

markdown (default), html

### layout

table (default), record

### conn

Specify the DBI connection string.

### username

Specify the database username.

### password

Specify the database password.

### maxwidth

Set a maximum width for the columns when in markdown format mode. If
any column contains a string longer than maxwidth it will be cropped.

## METHODS

### new

Sql::Textify constructor, see OPTIONS sections for more information.

### textify

The main function as far as the outside world is concerned. See the
SYNTAX for details on use.

## AUTHOR

Federico, Thiella, <fthiella at gmail.com>

## BUGS

Please report any bugs or feature requests to bug-sql-textify at
rt.cpan.org, or through the web interface at
http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Sql-Textify. I will be
notified, and then you'll automatically be notified of progress on your
bug as I make changes.

## SUPPORT

You can find documentation for this module with the perldoc command.

perldoc Sql::Textify

You can also look for information at:

* RT: CPAN's request tracker (report bugs here)

http://rt.cpan.org/NoAuth/Bugs.html?Dist=Sql-Textify

* AnnoCPAN: Annotated CPAN documentation

http://annocpan.org/dist/Sql-Textify

* CPAN Ratings

http://cpanratings.perl.org/d/Sql-Textify

* Search CPAN

http://search.cpan.org/dist/Sql-Textify/

## ACKNOWLEDGEMENTS

## LICENSE AND COPYRIGHT

Copyright 2017 Federico, Thiella.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

http://www.perlfoundation.org/artistic_license_2_0

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by
the Package. If you institute patent litigation (including a
cross-claim or counterclaim) against any party alleging that the
Package constitutes direct or contributory patent infringement, then
this Artistic License to you shall terminate on the date that such
litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

