#!/usr/bin/perl -w
# Author: Thomas Thiel
# Program name: primer3_in.pl
# Description: creates a PRIMER3 input file based on SSR search results
#############################################################################

# We modified this script for better compatibility with primer3 v2.3.6 and changed 
# parameters optimised for the M13-primer system by:
# - Including default values from the Primer3 online tool

open (IN,"<$ARGV[0]") || die ("\nError: Couldn't open misa.pl results file (*.misa) !\n\n");

my $filename = $ARGV[0];
$filename =~ s/\.misa//;
open (SRC,"<$filename") || die ("\nError: Couldn't open source file containing original FASTA sequences !\n\n");
open (OUT,">$filename.p3in");

undef $/;
$in = <IN>;
study $in;

$/= ">";

my $count;
while (<SRC>)
{
  next unless (my ($id,$seq) = /(.*?)\n(.*)/s);
  $seq =~ s/[\d\s>]//g;#remove digits, spaces, line breaks,...
  while ($in =~ /$id\t(\d+)\t\S+\t\S+\t(\d+)\t(\d+)/g)
  {
    my ($ssr_nr,$size,$start) = ($1,$2,$3);
    $count++;

    print OUT "SEQUENCE_ID=$id"."_$ssr_nr\nSEQUENCE_TEMPLATE=$seq\n";
    print OUT "TARGET=",$start,",",$size,"\n";			
    print OUT "PRIMER_THERMODYNAMIC_PARAMETERS_PATH=primer3_config/\n"; 
    print OUT "PRIMER_MAX_END_STABILITY=9\n";                   #
    print OUT "PRIMER_OPT_SIZE=20\n";
    print OUT "PRIMER_MIN_SIZE=18\n";
    print OUT "PRIMER_MAX_SIZE=23\n";
    print OUT "PRIMER_PAIR_MAX_LIBRARY_MISPRIMING=20\n";
    print OUT "PRIMER_MAX_LIBRARY_MISPRIMING=12\n";
    print OUT "SEQUENCE_PRIMER_PAIR_OK_REGION_LIST=",$start-100, ",100,",$start+100, ",100;\n" ;
 
    
    ########################################
    # Adding parameters from the online tool
    # Primer3 WWW
    ########################################
    
    print OUT "PRIMER_FIRST_BASE_INDEX=1\n"; 			# Index of first base in input sequence
    print OUT "PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT=1\n";	# If 1, primer3 will use thermodynamic models to calculate propensity to form hairpins
    print OUT "PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT=0\n";	# If 1, prospensity of oligos to anneal to undesirred sites in the template is calculated
    print OUT "PRIMER_PICK_LEFT_PRIMER=1\n";			# If 1, left primer will be designed
    print OUT "PRIMER_PICK_INTERNAL_OLIGO=0\n";
    print OUT "PRIMER_PICK_RIGHT_PRIMER=1\n";
    print OUT "PRIMER_LIBERAL_BASE=1\n";
    print OUT "PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS=0\n";
    print OUT "PRIMER_LOWERCASE_MASKING=0\n";
    print OUT "PRIMER_PICK_ANYWAY=1\n";				
    print OUT "PRIMER_EXPLAIN_FLAG=1\n";			# statistics are presented
    print OUT "PRIMER_TASK=generic\n";
    print OUT "PRIMER_MIN_QUALITY=0\n";
    print OUT "PRIMER_MIN_END_QUALITY=0\n";
    print OUT "PRIMER_QUALITY_RANGE_MIN=0\n";
    print OUT "PRIMER_QUALITY_RANGE_MAX=100\n";
    print OUT "PRIMER_MIN_TM=57.0\n";
    print OUT "PRIMER_OPT_TM=59.0\n";
    print OUT "PRIMER_MAX_TM=62.0\n";
    print OUT "PRIMER_PAIR_MAX_DIFF_TM=5.0\n";			# Maximum temperature difference between primers
    print OUT "PRIMER_TM_FORMULA=1\n";
    print OUT "PRIMER_PRODUCT_MIN_TM=-1000000.0\n";
    print OUT "PRIMER_PRODUCT_OPT_TM=0.0\n";
    print OUT "PRIMER_PRODUCT_MAX_TM=1000000.0\n";
    print OUT "PRIMER_MIN_GC=30.0\n";				# GC-content
    print OUT "PRIMER_OPT_GC_PERCENT=50.0\n";
    print OUT "PRIMER_MAX_GC=70.0\n";
    print OUT "PRIMER_PRODUCT_SIZE_RANGE=50-250 100-300 301-400 401-500 501-600 601-700 701-850 851-1000\n"; # List of product sizes, only if first is not successful, it will try others
    print OUT "PRIMER_NUM_RETURN=1\n";				# Number of primer pairs
 #   print OUT "PRIMER_MAX_LIBRARY_MISPRIMING=12.00\n";
 #    print OUT "PRIMER_PAIR_MAX_LIBRARY_MISPRIMING=20.00\n";
    print OUT "PRIMER_MAX_TEMPLATE_MISPRIMING_TH=40.00\n";
    print OUT "PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH=70.00\n";
    print OUT "PRIMER_MAX_SELF_ANY_TH=45.0\n";
    print OUT "PRIMER_MAX_SELF_END_TH=35.0\n";
    print OUT "PRIMER_PAIR_MAX_COMPL_ANY_TH=45.0\n";
    print OUT "PRIMER_PAIR_MAX_COMPL_END_TH=35.0\n";
    print OUT "PRIMER_MAX_HAIRPIN_TH=24.0\n";
    print OUT "PRIMER_MAX_TEMPLATE_MISPRIMING=12.00\n";
    print OUT "PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING=24.00\n";
    print OUT "PRIMER_MAX_SELF_ANY=8.00\n";
    print OUT "PRIMER_MAX_SELF_END=3.00\n";
    print OUT "PRIMER_PAIR_MAX_COMPL_ANY=8.00\n";
    print OUT "PRIMER_PAIR_MAX_COMPL_END=3.00\n";
    print OUT "PRIMER_MAX_NS_ACCEPTED=0\n";
    print OUT "PRIMER_MAX_POLY_X=4\n";
    print OUT "PRIMER_INSIDE_PENALTY=-1.0\n";
    print OUT "PRIMER_OUTSIDE_PENALTY=0\n";
    print OUT "PRIMER_GC_CLAMP=0\n";
    print OUT "PRIMER_MAX_END_GC=5\n";
    print OUT "PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE=3\n";
    print OUT "PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE=3\n";
    print OUT "PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION=7\n";
    print OUT "PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION=4\n";
    print OUT "PRIMER_SALT_MONOVALENT=50.0\n";
    print OUT "PRIMER_SALT_CORRECTIONS=1\n";
    print OUT "PRIMER_SALT_DIVALENT=1.5\n";
    print OUT "PRIMER_DNTP_CONC=0.6\n";
    print OUT "PRIMER_DNA_CONC=50.0\n";
    print OUT "PRIMER_SEQUENCING_SPACING=500\n";
    print OUT "PRIMER_SEQUENCING_INTERVAL=250\n";
    print OUT "PRIMER_SEQUENCING_LEAD=50\n";
    print OUT "PRIMER_SEQUENCING_ACCURACY=20\n";
    print OUT "PRIMER_WT_SIZE_LT=1.0\n";
    print OUT "PRIMER_WT_SIZE_GT=1.0\n";
    print OUT "PRIMER_WT_TM_LT=1.0\n";
    print OUT "PRIMER_WT_TM_GT=1.0\n";
    print OUT "PRIMER_WT_GC_PERCENT_LT=0.0\n";
    print OUT "PRIMER_WT_GC_PERCENT_GT=0.0\n";
    print OUT "PRIMER_WT_SELF_ANY_TH=0.0\n";
    print OUT "PRIMER_WT_SELF_END_TH=0.0\n";
    print OUT "PRIMER_WT_HAIRPIN_TH=0.0\n";
    print OUT "PRIMER_WT_TEMPLATE_MISPRIMING_TH=0.0\n";
    print OUT "PRIMER_WT_SELF_ANY=0.0\n";
    print OUT "PRIMER_WT_SELF_END=0.0\n";
    print OUT "PRIMER_WT_TEMPLATE_MISPRIMING=0.0\n";
    print OUT "PRIMER_WT_NUM_NS=0.0\n";
    print OUT "PRIMER_WT_LIBRARY_MISPRIMING=0.0\n";
    print OUT "PRIMER_WT_SEQ_QUAL=0.0\n";
    print OUT "PRIMER_WT_END_QUAL=0.0\n";
    print OUT "PRIMER_WT_POS_PENALTY=0.0\n";
    print OUT "PRIMER_WT_END_STABILITY=0.0\n";
    print OUT "PRIMER_PAIR_WT_PRODUCT_SIZE_LT=0.0\n";
    print OUT "PRIMER_PAIR_WT_PRODUCT_SIZE_GT=0.0\n";
    print OUT "PRIMER_PAIR_WT_PRODUCT_TM_LT=0.0\n";
    print OUT "PRIMER_PAIR_WT_PRODUCT_TM_GT=0.0\n";
    print OUT "PRIMER_PAIR_WT_COMPL_ANY_TH=0.0\n";
    print OUT "PRIMER_PAIR_WT_COMPL_END_TH=0.0\n";
    print OUT "PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH=0.0\n";
    print OUT "PRIMER_PAIR_WT_COMPL_ANY=0.0\n";
    print OUT "PRIMER_PAIR_WT_COMPL_END=0.0\n";
    print OUT "PRIMER_PAIR_WT_TEMPLATE_MISPRIMING=0.0\n";
    print OUT "PRIMER_PAIR_WT_DIFF_TM=0.0\n";
    print OUT "PRIMER_PAIR_WT_LIBRARY_MISPRIMING=0.0\n";
    print OUT "PRIMER_PAIR_WT_PR_PENALTY=1.0\n";
    print OUT "PRIMER_PAIR_WT_IO_PENALTY=0.0\n";
    print OUT "PRIMER_INTERNAL_MIN_SIZE=18\n";
    print OUT "PRIMER_INTERNAL_OPT_SIZE=20\n";
    print OUT "PRIMER_INTERNAL_MAX_SIZE=27\n";
    print OUT "PRIMER_INTERNAL_MIN_TM=57.0\n";
    print OUT "PRIMER_INTERNAL_OPT_TM=60.0\n";
    print OUT "PRIMER_INTERNAL_MAX_TM=63.0\n";
    print OUT "PRIMER_INTERNAL_MIN_GC=20.0\n";
    print OUT "PRIMER_INTERNAL_OPT_GC_PERCENT=50.0\n";
    print OUT "PRIMER_INTERNAL_MAX_GC=80.0\n";
    print OUT "PRIMER_INTERNAL_MAX_SELF_ANY_TH=47.00\n";
    print OUT "PRIMER_INTERNAL_MAX_SELF_END_TH=47.00\n";
    print OUT "PRIMER_INTERNAL_MAX_HAIRPIN_TH=47.00\n";
    print OUT "PRIMER_INTERNAL_MAX_SELF_ANY=12.00\n";
    print OUT "PRIMER_INTERNAL_MAX_SELF_END=12.00\n";
    print OUT "PRIMER_INTERNAL_MIN_QUALITY=0\n";
    print OUT "PRIMER_INTERNAL_MAX_NS_ACCEPTED=0\n";
    print OUT "PRIMER_INTERNAL_MAX_POLY_X=5\n";
    print OUT "PRIMER_INTERNAL_MAX_LIBRARY_MISHYB=12.00\n";
    print OUT "PRIMER_INTERNAL_SALT_MONOVALENT=50.0\n";
    print OUT "PRIMER_INTERNAL_DNA_CONC=50.0\n";
    print OUT "PRIMER_INTERNAL_SALT_DIVALENT=1.5\n";
    print OUT "PRIMER_INTERNAL_DNTP_CONC=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_SIZE_LT=1.0\n";
    print OUT "PRIMER_INTERNAL_WT_SIZE_GT=1.0\n";
    print OUT "PRIMER_INTERNAL_WT_TM_LT=1.0\n";
    print OUT "PRIMER_INTERNAL_WT_TM_GT=1.0\n";
    print OUT "PRIMER_INTERNAL_WT_GC_PERCENT_LT=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_GC_PERCENT_GT=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_SELF_ANY_TH=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_SELF_END_TH=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_HAIRPIN_TH=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_SELF_ANY=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_SELF_END=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_NUM_NS=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_LIBRARY_MISHYB=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_SEQ_QUAL=0.0\n";
    print OUT "PRIMER_INTERNAL_WT_END_QUAL=0.0\n=\n";
 
  
    
  };
};
print "\n$count records created\n";  # remove . after created
