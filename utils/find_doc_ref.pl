my %hash = ();
while ($line = <>) {
    if ($line =~ m|((ISO)(?:/(TS))? ([0-9]+)-([0-9]+))|) {
	$desig = $1;
	$org = $2;
	$type = $3;
	$std = $4;
	$part = $5;
	$key = make_key($org, $type, $std, $part);
	$hash{$key} = $desig;
    }
}
for my $key (sort keys %hash)
{
  print "$hash{$key}\n";
}

sub make_key {
    my ($org, $type, $std, $part) = @_;
    if ($type eq "") {
	$type = "IS";
    }
    $padded_std = sprintf("%0*s", 5, $std);
    $padded_part = sprintf("%0*s", 5, $part);
    return $org . "_" . $padded_std . "-" . $padded_part . "_" . $type;
}
