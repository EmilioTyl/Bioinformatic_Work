use Bio::Perl;
use Bio::SeqIO;
use Bio::Tools::Run::RemoteBlast;

my $numArgs = $#ARGV + 1;
my $fasta_aminoacid_file = "../data/exercise1_out/msa.fas";
my $blast_report_name = "blast_report.out";
#if ($numArgs > 0){
#  $fasta_aminoacid_file = @ARGV[0];
#  $blast_report_name = @ARGV[1];
#}
my $out_filename = "../data/exercise2_out/$blast_report_name";

$prog = "tblastx";
$db = "nr";
$e_val = "1e-10";


my $remote_blast = Bio::Tools::Run::RemoteBlast->new ( -prog => 'blastp',-data => 'ecoli',-expect => '1e-10' );
$r = $remote_blast->submit_blast($fasta_aminoacid_file);
while (@rids = $remote_blast->each_rid ) {
    foreach $rid ( @rids ) {
      $rc = $remote_blast->retrieve_blast($rid);
      if( !ref($rc) ) {
          if( $rc < 0 ) {
            $remote_blast->remove_rid($rid);
          }
          print STDERR "TIME";
          sleep 5;
      } else {
        print STDERR "GOOD";
        $remote_blast->save_output($out_filename);
        $remote_blast->remove_rid($rid);
      }
    }
  }
