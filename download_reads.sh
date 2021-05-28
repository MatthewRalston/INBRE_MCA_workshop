#!/bin/bash
#SBATCH --job-name=example
#SBATCH --ntasks=4
#SBATCH --mem=16000

# Author: Matt Ralston
# Date: 1/31/16
# Description:
# This is a template script containing options parsing

VERSION=0.0.1
HELP=0

if [ $# -eq 0 ] # Print the help message if no arguments are provided
then
    HELP=1
fi

#######################
# Command line options
#######################
if [[ $# > 0 ]]
then
    key="$1"
    case $key in
	-h|--help)
	HELP=1
	;;

	-r|--required)
	REQUIRED="$2"
	shift
	;;

	-o|--optional)
	OPTIONAL="$2"
	shift
	;;

	-f|--flag)
	FLAG=1
	;;

	*)
	echo "Unknown option: $key"
	exit 1
	;;
    esac
    shift
fi

if [ $HELP == 1 ]; then
    echo "Usage: example.sh [-r|--required REQUIRED]"
    echo "Options:"
    echo "        -o|--optional OPTIONAL"
    echo "        -f|--flag"
    echo "        -h|--help"
    exit 1
fi

echo "Examining parameters..."
echo "required: $REQUIRED"
echo "optional: $OPTIONAL"
echo "flag: $FLAG"

echo "Beginning download.."
#/home/matt/pckges/sratoolkit.2.9.6-1-ubuntu64/bin/fastq-dump.2.9.6
source /usr/local/ncbi/sra-tools.sh

# --split-e for spliting the reads into R1 and R2
parallel -j 4 --retries 3 'fastq-dump --defline-seq "'@\$ac \$sn/\$ri'" --defline-qual "'+\$ac \$sn/\$ri'" --split-e --disable-multithreading --outdir /home/ralstonm/Projects/INBRE_microbial_community_analysis/ {}' ::: $(cat $REQUIRED)

echo "DONE"

exit 0
