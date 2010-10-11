package Foreword;

use strict;
use Cancel_and_replace;
use Desig_info;
use Utils;

my $desig_pattern = "ISO(?:/TS)? [-0-9:]+";
my $ordinal_pattern = "first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth";

sub new {
    my ($class, $content, $source_file_path, $designator) = @_;
    my $self;

    $self = {};
    $self->{_content} = $content;
    $self->{_source_file_path} = $source_file_path;
    $self->{_designator} = $designator;

    bless $self, $class;

    $self->parse();

    return $self;
}

sub parse {
    my ($self) = @_;

    my $content = $self->{_content};

    if ($content =~ m|(This [a-z]+ edition[^.]*[.])|) {
	my $sentence = $1;
	my $cancel_and_replace = new Cancel_and_replace($sentence);
	$self->{_cancel_and_replace} = $cancel_and_replace;
    }
    else {
	print "Warning: cancel-and-replace sentence not found.\n";
    }
}

sub check {
    my ($self) = @_;
    my $ret = 1;

    my $cancel_and_replace = $self->{_cancel_and_replace};
    if ($cancel_and_replace) {
	$ret = $cancel_and_replace->check();
    }
    return $ret;
}

sub print {
    my ($self) = @_;

    print "source_file_path = $self->{_source_file_path}\n";
    print "designator = $self->{_designator}\n";
}

1;
