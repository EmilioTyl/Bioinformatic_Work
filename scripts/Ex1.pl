use Bio::Perl;
use Bio::SeqIO;


# El trabajo se decide en enfocar en la Apolipoprotein, proteina relacionada con
# el Alzehimer (https://www.ncbi.nlm.nih.gov/nuccore/NM_001302688.1?report=genbank).
# El siguiente cofigo toma el archivo genbank del ARN mensajero, y realiza la
# transcripción de la proteina medientae los 6 posibles marcos de lecura (orf).

# De todos los marcos de lecturas realizados, el orf 0 es el que genera la
#proteina con menos caracteres de finalización intermedios (sólo posee estos
#al final de la secuencia). Por lo que se estima que este marco de lectura sería
# el correcto. No obstante en el siguiente ejercico donde se realizara el BLAST
#frente a una base de datos d eproteinas, se podrá estimar de mejor manera cuál
# es el marco de lectura correcto .


my $numArgs = $#ARGV + 1;
my $gb_file = "../data/NM_001302688.1.gb";
if ($numArgs > 0){
  $gb_file = @ARGV[0];
}



my $dna_seqio_object = Bio::SeqIO->new(-file => $gb_file, -format => "genbank");
my $seq_object = $dna_seqio_object->next_seq();
my $reverse_seq_object = $seq_object->revcom;

for(my $orf=0; $orf< 3; $orf++){

  my $fasta_out = "../data/exercise1_out/procesed_protein_orf$orf.fas";
  generateProteinFasta($seq_object->translate(-frame => $orf), $fasta_out);

  $fasta_out = "../data/exercise1_out/procesed_protein_reverse_orf$orf.fas";
  generateProteinFasta($reverse_seq_object->translate(-frame => $orf), $fasta_out);

}

sub generateProteinFasta
{
    # arguments
    my ($protein, $fasta_path) = @_;
    my $protein_seq_out = Bio::SeqIO->new( -file   => ">$fasta_path", -format => "fasta");
    $protein_seq_out->write_seq($protein);
}
