# -*-Perl-*-
## Bioperl Test Harness Script for Modules


use strict;
BEGIN {
    eval { require Test::More; };
    if( $@ ) {
        use lib 't/lib';
    }
    use Test::More;
    use vars qw($NTESTS);
    $NTESTS = 21;
    plan tests => $NTESTS;
    use_ok('Bio::Tools::Genomewise');
}

my $inputfilename= Bio::Root::IO->catfile("t","data","genomewise.out");
my $parser = Bio::Tools::Genomewise->new(-file => $inputfilename);
my @gene;
while (my $gene= $parser->next_prediction){
    push @gene, $gene;
}
my @t = $gene[0]->transcripts;
my @e = $t[0]->exons;

is ($t[0]->source_tag, 'genomewise');
is ($e[0]->source_tag, 'genomewise');
is ($t[0]->primary_tag, 'transcript');
is ($e[0]->primary_tag, 'exon');

is (scalar($t[0]->exons), 5);
is ($t[0]->start, 4761);
is ($t[0]->end, 6713);
is ($e[0]->start,4761);
is ($e[0]->end, 4874);
my ($phase) = $e[0]->each_tag_value('phase');
is ($phase,0);

open(FH,$inputfilename);
$parser = Bio::Tools::Genomewise->new(-fh=>\*FH);
while (my $gene= $parser->next_prediction){
    push @gene, $gene;
}
@t = $gene[1]->transcripts;
@e = $t[0]->exons;

is ($t[0]->source_tag, 'genomewise');
is ($e[0]->source_tag, 'genomewise');
is ($t[0]->primary_tag, 'transcript');
is ($e[0]->primary_tag, 'exon');

is (scalar($t[0]->exons), 3);
is ($t[0]->start, 9862);
is ($t[0]->end, 10316);
is ($e[1]->start,10024);
is ($e[1]->end, 10211);

($phase) = $e[2]->each_tag_value('phase');
is ($phase,2);

