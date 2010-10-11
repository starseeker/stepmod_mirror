package Desig_info;

use strict;
use Date_info;
use Utils;

my $date_pattern = "[0-9]{4}(:?[0-9]{2})?";

sub new {
    my ($class, $designator) = @_;
    my $self;

    $designator = Utils::trim($designator);
    $self = {};
    if ($designator =~ m|(ISO)(?:/(TS))? ([-0-9]+)(?:[:]([-0-9]*))?(?:\((E)\))?|) {
	my $organization = $1;
	my $deliverable_type = $2;
	my $standard_part_str = $3;
	my $date_str = $4;
	my $language= $5;
	$self->{_designator} = $designator;
	$self->{_organization} = $organization;
	$self->{_deliverable_type} = $deliverable_type;
	if ($standard_part_str =~ m|([0-9]*)(?:[-]([0-9]*))|) {
	    my $standard_number_str = $1;
	    my $part_number_str = $2;
	    $self->{_standard_number} = int($standard_number_str);
	    $self->{_part_number} = int($part_number_str);
	}
	$self->{_date_str} = $date_str;
	if ($date_str) {
	    $self->{_date_info} = new Date_info($date_str);
	}
	$self->{_language} = $7;
    }
    else {
	print "Did not match 1.\n";
    }
    bless $self, $class;
    return $self;
}

sub print {
    my ($self) = @_;

    print "designator = $self->{_designator}\n";
    print "organization = $self->{_organization}\n";
    print "deliverable_type = $self->{_deliverable_type}\n";
    print "standard_number = $self->{_standard_number}\n";
    print "part_number = $self->{_part_number}\n";
    print "date_str = $self->{_date_str}\n";
    if ($self->{_date_info}) {
	$self->{_date_info}->print();
    }
    print "language = $self->{_language}\n";
}

1;
