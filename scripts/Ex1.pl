use Bio::Perl;
use Bio::SeqIO;

my $numArgs = $#ARGV + 1;

my $genbank_name = "NM_001302688.1.gb";
if ($numArgs > 0){
  $genbank_name = @ARGV[0];
}

my $gb_file = "../data/$genbank_name";


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
