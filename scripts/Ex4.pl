
use Bio::Perl;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::DB::Fasta;

my $blast_report_name = "blast_report_orf0.out";
my $pattern = "A4";
my $output_name = "hits";
my $numArgs = $#ARGV + 1;

if ($numArgs > 0){
  $blast_report_name = @ARGV[0];
  $pattern = @ARGV[1];
  $output_name = @ARGV[2];
}

my $blast_filename = "../data/exercise2_out/$blast_report_name";
my $blast_report = Bio::SearchIO->new('-format' => 'blast', '-file' => $blast_filename);

my $output_filename_fasta = "../data/exercise4_out/$output_name.fas";
my $output_report = Bio::SeqIO->new('-format' => 'fasta', '-file' => ">$output_filename_fasta");
my $output_filename_matches = "../data/exercise4_out/$output_name.out";
open(my $output_match, ">", $output_filename_matches);

my $db = Bio::DB::Fasta->new('/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/data/swissprot');

while( $result = $blast_report->next_result ) {
      while ( $hit = $result->next_hit ){
      my $prot_description = $hit->description;
      #print "Hit description\t", index($prot_description, $pattern),"           ", $prot_description, "\n";
      if (my $idx = index($prot_description, $pattern) > 0 ){
        $prot_name = $hit->name;
        my $seq = $db->get_Seq_by_id($prot_name);
        $output_report->write_seq($seq);
        print $output_match "Match protein $prot_name Index = $idx Pattern = $pattern \nDescription = $prot_description\n\n\n";
      }


    }
}

close $output_match;
