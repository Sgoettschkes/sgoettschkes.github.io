use v5.12;
use warnings;
use utf8;
my $uname = 'sgoettschkes';
my ($curr_month, $curr_year) = (gmtime)[4,5];
$curr_year  += 1900;
$curr_month += 1;
 
my %projects;
for my $year (2010..$curr_year) {
    for my $month (1..12) {
        last if $year == $curr_year && $month > $curr_month;
        my $from = sprintf '%4d-%02d-01', $year, $month;
        my $to   = sprintf '%4d-%02d-01', $month == 12 ? ($year + 1, 1) : ($year, $month + 1);
        my $res = `curl 'https://github.com/$uname?tab=contributions&from=$from&to=$to' | grep 'class="title"'`;
        while ($res =~ /href="([^"?]+)/g) {
            my (undef, $user, $repo, $type) = split m{/} => $1;
            $projects{"$user/$repo/$type"}++;
        }
    }
}
 
say "$projects{$_}: $_" for sort keys %projects;
