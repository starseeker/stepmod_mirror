package Cancel_and_replace;

use strict;
use Desig_info;
use Utils;

my $desig_pattern = "ISO(?:/TS)? [-0-9:]+";
my $ordinal_pattern = "first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth";

sub new {
    my ($class, $sentence, $source_file_path, $designator) = @_;
    my $self;

    $self = {};
    $self->{_sentence} = $sentence;

    bless $self, $class;

    $self->parse();

    return $self;
}

sub parse {
    my ($self) = @_;

    my $sentence = $self->{_sentence};

    if ($sentence =~ m|This ($ordinal_pattern) edition of ($desig_pattern) cancels and replaces the ($ordinal_pattern) edition \(($desig_pattern)\), of which it constitutes a technical revision.|) {
	print "current edition = $1\n";
	$self->{_current_edition} = Utils::text_to_number($1);
	print "current desig = $2\n";
	$self->{_current_desig} = $2;
	$self->{_current_desig_info} = new Desig_info($2);
	print "previous edition = $3\n";
	$self->{_previous_edition} = Utils::text_to_number($3);
	print "previous desig = $4\n";
	$self->{_previous_desig} = $4;
	$self->{_previous_desig_info} = new Desig_info($4);
    }
    else {
	print "Warning: cancel-and-replace sentence incorrect syntax.\n";
	print "sentence = $sentence\n";
    }
}

sub check {
    my ($self) = @_;
    my $ret = 1;

    my $current_desig_info = $self->{_current_desig_info};

    if ($current_desig_info->{_organization} ne "ISO") {
	print "Warning: current organization not \"ISO\".\n";
    }
    if ($current_desig_info->{_deliverable_type} ne "TS") {
	print "Warning: current deliverable type not \"TS\".\n";
    }
    if ($current_desig_info->{_standard_number} ne 10303) {
	print "Warning: current standard number not 10303.\n";
    }
    
    my $previous_desig_info = $self->{_previous_desig_info};

    if ($previous_desig_info->{_organization} ne "ISO") {
	print "Warning: previous organization not \"ISO\".\n";
    }
    if ($previous_desig_info->{_deliverable_type} ne "TS") {
	print "Warning: previous deliverable type not \"TS\".\n";
    }
    if ($previous_desig_info->{_standard_number} ne 10303) {
	print "Warning: previous standard number not 10303.\n";
    }
    my $date_info = $previous_desig_info->{_date_info};
    if (!$date_info || !$date_info->{_year} || $date_info->{_year} == 0) {
	print "Error: previous publication year missing.\n";
	$ret = 0;
    }
    
    my $current_part_number = $current_desig_info->{_part_number};
    my $previous_part_number = $previous_desig_info->{_part_number};
    if ($current_part_number != $previous_part_number) {
	print "Warning: current part number $current_part_number not equal to previous $previous_part_number.\n";
    }
    return $ret;
}

sub print {
    my ($self) = @_;

    print "sentence = $self->{_sentence}\n";
    print "current_edition = $self->{_current_edition}\n";
    print "current_desig = $self->{_current_desig}\n";
    if ($self->{_current_desig_info}) {
	$self->{_current_desig_info}->print();
    }
    print "previous_edition = $self->{_previous_edition}\n";
    print "previous_desig = $self->{_previous_desig}\n";
    if ($self->{_previous_desig_info}) {
	$self->{_previous_desig_info}->print();
    }
}

1;
