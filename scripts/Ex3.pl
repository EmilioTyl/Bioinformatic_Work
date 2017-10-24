use Bio::Perl;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::DB::Fasta;
BEGIN {$ENV{PATH} = '$ENV{PATH}:/Users/emiliotylson/muscle/bin'; }
BEGIN {$ENV{MUSCLEDIR} = '/Users/emiliotylson/muscle/bin'; }
use Bio::Tools::Run::Alignment::Muscle;



my $blast_report_name = "blast_report.out";
my $numArgs = $#ARGV + 1;
if ($numArgs > 0){
  $blast_report_name = @ARGV[0];
}
my $blast_filename = "../data/exercise2_out/$blast_report_name";
my $db = Bio::DB::Fasta->new('/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/data/swissprot');
my $fasta_aminoacid_file = "../data/exercise1_out/procesed_protein_orf2.fas";
my $fasta_top_10_name = "../data/exercise3_out/top10_matches.fas";

my @seqs = ();
my $blast_report = Bio::SearchIO->new('-format' => 'blast', '-file' => $blast_filename);
my $top_10 = Bio::SeqIO->new(-file => ">$fasta_top_10_name", -format => 'fasta');

while( $result = $blast_report->next_result ) {
    for(my $i=0; $i< 10; $i++){
      $hit = $result->next_hit;
      $prot_name = $hit->name;
      print "Hit\t", $prot_name, "\n";
      my $seq = $db->get_Seq_by_id($prot_name);

      $top_10->write_seq($seq);
    }
}
my $seq_in = Bio::SeqIO->new (-file =>$fasta_aminoacid_file, -format => 'Fasta');
my $query_in = $seq_in->next_seq();
$top_10->write_seq($query_in);

my $t = Bio::SeqIO->new(-file => "$fasta_top_10_name", -format => 'fasta');
while( $s = $t->next_seq() ){
  push @seqs, $s;
}

#https://www.ebi.ac.uk/Tools/msa/
#@params = ('ktuple' => 2, 'matrix' => 'BLOSUM');
#$aligner = Bio::Tools::Run::Alignment::Muscle->new(@params);

#print "@seqs.\n";
#$fas_seqs_ref = @seqs;
#$res = $aligner->align(\@seqs); # $aln is a SimpleAlign object.
