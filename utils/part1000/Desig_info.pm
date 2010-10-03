package Desig_info;

use Date_info;

sub new {
    my ($class, $designation) = @_;
    my $self;

    $designation = $designation.trim;
    $self = {};
    if ($designation =~ m|(ISO)(?:/(TS))? +10303-([0-9]+):([0-9]+(?:-[0-9]+)?)(?:\((E)\))|) {
	$self->{_designation} = $designation;
	$self->{_organization} = $1;
	$self->{_deliverable_type} = $2;
	$self->{_part_number} = int($3);
	$self->{_date_str} = $4;
	$self->{_date_info} = new Date_info($4);
	$self->{_language} = $5;
    }
    else {
	print "Did not match 1.\n";
    }
    bless $self, $class;
    return $self;
}

sub print {
    my ($self) = @_;

    print "organization = $self->{_organization}\n";
    print "deliverable_type = $self->{_deliverable_type}\n";
    print "part_number = $self->{_part_number}\n";
    print "date_str = $self->{_date_str}\n";
    $self->{_date_info}->print();
    print "language = $self->{_language}\n";
}

1;
