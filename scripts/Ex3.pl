use Bio::Perl;
use Bio::SeqIO;
use Bio::SearchIO;
use Bio::DB::Fasta;

# El siguiente código toma como input el archivo blast generado en el ejercicicio 2.
# Luego, toma el nombre de las primeras 10 secuencias con mayor score en el alineamiento.
# Luego busca la correspondiente secuenias en la base de datos swissprot y las
# escribe en un archivo fasta, en el que también esta presente la Apoliprotein, nuestra
# proteina de referencia.

my $blast_report_name = "blast_report_orf0.out";
my $fasta_protein_name = "procesed_protein_orf0.fas";
my $numArgs = $#ARGV + 1;
if ($numArgs > 0){
  $blast_report_name = @ARGV[0];
  $fasta_protein_name = @ARGV[1];
}
my $blast_filename = "../data/exercise2_out/$blast_report_name";
my $db = Bio::DB::Fasta->new('/Users/emiliotylson/ncbi-blast/ncbi-blast-2.6.0+/data/swissprot');
my $fasta_aminoacid_file = "../data/exercise1_out/$fasta_protein_name";
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

#De la página https://www.ebi.ac.uk/Tools/msa/ que ofrece diferentes alternativas
# para realizar el secuenciamiente, usamos T-Coffe. En dicha applicación subimos
#el archivo generado por el código anterior, el cual genera un archivo fasta con
#las 10 secuencia con más similares obteneidas por BLAST sobre Apoliprotein. La
#alineación gennera un archivo que esta subido en ../data/exercise3_out/msa.out.
