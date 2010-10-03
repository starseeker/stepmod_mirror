package Date_info;

sub new {
    my ($class, $date_str) = @_;
    my $self;

    $date_str = $date_str.trim;
    $self = {};
    if ($date_str =~ m|([0-9]+)(?:-([0-9]+)(?:-([0-9]+))?)?|) {
	$self->{_date_str} = $date_str;
	$self->{_year} = int($1);
	$self->{_month} = int($2);
	$self->{_day} = int($3);
    }
    else {
	print "Did not match 2.\n";
    }
    bless $self, $class;
    return $self;
}

sub matches_year {
    my ($self, $compared_date_info) = @_;
    my $my_year = $self->{_year};
    my $compared_year = $compared_date_info->{_year};
    if ($my_year != $compared_year) {
	return 0;
    }

    return 1;
}

sub matches_year_month {
    my ($self, $compared_date_info) = @_;

    if (!matches_year($self, $compared_date_info)) {
	return 0;
    }

    my $my_month = $self->{_month};
    my $compared_month = $compared_date_info->{_month};
    if ($my_month != $compared_month) {
	return 0;
    }

    return 1;
}

sub print {
    my ($self) = @_;

    print "year = $self->{_year}\n";
    print "month = $self->{_month}\n";
    print "day = $self->{_day}\n";
}

1;
