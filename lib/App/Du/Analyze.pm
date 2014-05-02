package App::Du::Analyze;

use strict;
use warnings;

use autodie;

our $VERSION = '0.0.3';

use MooX qw/late/;

use Getopt::Long qw( GetOptionsFromArray );
use Pod::Usage;

use App::Du::Analyze::Filter;

has argv => (isa => 'ArrayRef', is => 'rw');

sub run
{
    my ($self) = @_;

    my $prefix = "";
    my $depth = 1;
    my $sort = 1;
    my $man = 0;
    my $help = 0;
    my $version = 0;

    my @argv = @{$self->argv};

    GetOptionsFromArray(
        \@argv,
        "prefix|p=s" => \$prefix,
        "depth|d=n" => \$depth,
        "sort" => \$sort,
        "help|h" => \$help,
        "man" => \$man,
        "version" => \$version,
    ) or pod2usage(2);

    if ($help)
    {
        pod2usage(1)
    }

    if ($man)
    {
        pod2usage(-verbose => 2);
    }

    if ($version)
    {
        print "analyze-du.pl version $VERSION\n";
        exit(0);
    }

    my $in_fh;

    my $filename;
    if (!defined ($filename = $ENV{ANALYZE_DU_INPUT_FN}))
    {
        $filename = shift(@argv);
    }

    if (!defined($filename))
    {
        $in_fh = \*STDIN;
    }
    else
    {
        open $in_fh, '<', $filename;
    }

    App::Du::Analyze::Filter->new(
        {
            prefix => $prefix,
            depth => $depth,
            should_sort => $sort,
        }
    )->filter($in_fh, \*STDOUT);

    if (defined($filename))
    {
        close($in_fh);
    }

    return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Du::Analyze - analyze the output of du and find the most space-consuming
directories.

=head1 VERSION

version 0.0.3

=head1 DESCRIPTION

This analyzes the output of C<\du .> looking for directories with a certain
prefix, a certain depth and possibly sorting the output by size. It aims to
aid in finding the most space-consuming components in the directory tree
on the disk.

=head1 NOTE

Everything here is subject to change. The API is for internal use.

=head1 METHODS

=head2 my $app = App::Du::Analyze->new({argv => \@ARGV})

The constructor. Accepts the @ARGV array as a parameter and parses it.

=head2 $app->run()

Runs the application.

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Du-Analyze or by email to
bug-app-du-analyze@rt.cpan.org.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc App::Du::Analyze

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<http://metacpan.org/release/App-Du-Analyze>

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/App-Du-Analyze>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Du-Analyze>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annotations of Perl module documentation.

L<http://annocpan.org/dist/App-Du-Analyze>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/App-Du-Analyze>

=item *

CPAN Forum

The CPAN Forum is a web forum for discussing Perl modules.

L<http://cpanforum.com/dist/App-Du-Analyze>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.perl.org/dist/overview/App-Du-Analyze>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/A/App-Du-Analyze>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=App-Du-Analyze>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=App::Du::Analyze>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-app-du-analyze at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Du-Analyze>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<http://github.com/shlomif/perl-App-Du-Analyze>

  git clone https://github.com/shlomif/perl-App-Du-Analyze.git

=cut
