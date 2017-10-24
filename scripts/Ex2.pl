use Bio::Perl;
use Bio::SeqIO;
use Bio::Tools::Run::RemoteBlast;
use Bio::Tools::Run::StandAloneBlast;
use Bio::Tools::Run::StandAloneBlastPlus;


my $numArgs = $#ARGV + 1;
my $fasta_aminoacid_file = "../data/exercise1_out/procesed_protein_orf2.fas";
my $blast_report_name = "blast_report.out";
my $remote = 0;
if ($numArgs > 0){
  $fasta_aminoacid_file = @ARGV[0];
  $blast_report_name = @ARGV[1];
  $remote = @ARGV[2];
}
my $out_filename = "../data/exercise2_out/$blast_report_name";


if ($remote == 1){
  my @params = ( '-prog' => 'blastp', '-data' => 'swissprot', '-expect' => '0.01', '-readmethod' => 'SearchIO' ,'-verbose' => '1');
  my $remote_blast = Bio::Tools::Run::RemoteBlast->new(@params);
  #$remote_blast->set_url_base("https://blast.ncbi.nlm.nih.gov/Blast.cgi");
  #$remote_blast->set_url_base("https://www.ncbi.nlm.nih.gov/blast/Blast.cgi");
  $r = $remote_blast->submit_blast($fasta_aminoacid_file);

  while (@rids = $remote_blast->each_rid ) {
      print( "REMOTE.\n");
      foreach $rid ( @rids ) {
        $rc = $remote_blast->retrieve_blast($rid);
        if( !ref($rc) ) {
            if( $rc < 0 ) {
              $remote_blast->remove_rid($rid);
            }
            print  "TIME OUT.\n";
            sleep 5;
        } else {
          print  "SUCCESFULL BLAST QUERY.\n";
          $remote_blast->save_output($out_filename);
          $remote_blast->remove_rid($rid);
        }
      }
    }
}else{

  print("LOCAL.\n");
  print("$fasta_aminoacid_file\n");
  print("$out_filename\n");

  my $seq_in = Bio::SeqIO->new (-file =>$fasta_aminoacid_file, -format => 'Fasta');
  my $query_in = $seq_in->next_seq();

  #@params = ('program' => 'blastp',
  #          'database' => '/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/data/swissprot',
  #          'outfile' => $out_filename, '_READMETHOD' => 'Blast');

  #my $local_blast = Bio::Tools::Run::StandAloneBlast->new(-db_name => '/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/data/swissprot',
  #                                                        -dbtype => 'prot');
  #$local_blast->blastp(-query =>"gkjgkjgk", -outfile => $out_filename);

  #
  $factory = Bio::Tools::Run::StandAloneBlastPlus->new(
		-db_name => '/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/data/swissprot',
		-prog_dir => '/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/bin');
  $r = $factory->blastp(-query => $fasta_aminoacid_file, -outfile => $out_filename, -method_args => [ '-evalue' => 0.01 ]);

  #@params = ('program' => 'blastp',
  #          'database' => '/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/data/swissprot',
  #          'outfile' => $out_filename, '_READMETHOD' => 'Blast');
  #$local_blast = Bio::Tools::Run::StandAloneBlast->new(@params); #-db_name => '/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/data/swissprot',
		                                                    #-prog_dir => '/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/bin');
  #my $blast_report = $local_blast->blastp($query_in);
  #print $balst_report;

  print("DONE");

}
