package Utils;

sub text_to_number {
    my ($txt) = @_;
    if ($txt eq "first") {
	return 1;
    }
    elsif ($txt eq "second") {
	return 2;
    }
    elsif ($txt eq "third") {
	return 3;
    }
    elsif ($txt eq "fourth") {
	return 4;
    }
    elsif ($txt eq "fifth") {
	return 5;
    }
    elsif ($txt eq "sixth") {
	return 6;
    }
    elsif ($txt eq "seventh") {
	return 7;
    }
    elsif ($txt eq "eighth") {
	return 8;
    }
    elsif ($txt eq "ninth") {
	return 9;
    }
    elsif ($txt eq "tenth") {
	return 10;
    }
    else {
	return $txt;
    }
}

sub is_html {
    my ($file_path) = @_;
    if ($file_path =~ m/\.htm$/) {
	return 1;
    }
    return 0;
}

sub my_normalize {
    my ($source_dir_uri, $original_link) = @_;
    my $uri = URI->new_abs($original_link,$source_dir_uri);
    my $modified_link = $uri->rel($source_dir_uri);
    return $modified_link;
}

sub my_denormalize {
    my ($source_dir_uri, $original_link) = @_;
    my $modified_link = $original_link;
    if (!($modified_link =~ m|^http:|)) {
	if ($source_dir_uri =~ m|/sys$|) {
	    $modified_link =~ s|^(\w)|../sys/\1|;
	}
	else {
	    $modified_link =~ s|^([A-Za-z0-9])|./\1|;
	    if ($modified_link =~ s|^\.\./sys|./sys|) {
	    }
	    else {
		$modified_link =~ s|^\.\./(\w)|../../../data/modules/\1|;
	    }
	}
    }
    return $modified_link;
}

sub trim($)
{
    my ($string) = @_;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

1;
