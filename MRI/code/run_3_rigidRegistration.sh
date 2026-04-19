#!/bin/bash
####################################################################################################################################
# run_3_rigidRegistration.sh
#
# Performs rigid registration of preprocessed brain images to a resolution-matched MNI152 template
# using ANTs. The estimated transform is also applied to manual segmentations. Supports three
# datasets, selected at runtime via a command-line argument.
#
# Usage: ./run_3_rigidRegistration.sh <dataset> <subjectsFile> <preprocessedDir> <segmentationDir> <outputDir>
# Available datasets: 0p5, 0p7, 1p0
####################################################################################################################################

set -e

if [ $# -lt 5 ]; then
    echo "Usage: $0 <dataset> <subjectsFile> <preprocessedDir> <segmentationDir> <outputDir>"
    echo "Available datasets: 0p5, 0p7, 1p0"
    exit 1
fi

#assign positional arguments
dataset=$1
subjects_file=$2
preprocessed_dir=$3
segmentation_dir=$4
output_dir=$5

#select resolution-matched MNI template based on dataset
case "$dataset" in
    "0p5")
        template=<MNI152_0.5mm_skullstripped>
        ;;
    "0p7")
        template=<MNI152_0.7mm_skullstripped>
        ;;
    "1p0")
        template=<MNI152_1.0mm_skullstripped>
        ;;
    *)
        echo "Error: Unknown dataset '$dataset'"
        echo "Available datasets: 0p5, 0p7, 1p0"
        exit 1
        ;;
esac

mkdir -p "$output_dir"

if [ ! -f "$subjects_file" ]; then
    echo "Error: Subject list not found: $subjects_file"
    exit 1
fi

echo "Starting rigid alignment for dataset: $dataset"

#iterate over subjects
while read -r subject; do
    [[ -z "$subject" || "$subject" =~ ^# ]] && continue

    #add BIDS sub- prefix if absent
    [[ ! "$subject" =~ ^sub- ]] && subject="sub-$subject"

    echo "Processing subject: $subject"

    subject_output_dir="$output_dir/$subject"
    mkdir -p "$subject_output_dir"

    #set input paths
    input_image="${preprocessed_dir}/$dataset/$subject/${subject}_brain.nii.gz"
    segmentation="${segmentation_dir}/$dataset/$subject/${subject}_segmentation_manual.nii.gz"

    if [ ! -f "$input_image" ]; then
        echo "Warning: Input image not found for $subject. Skipping."
        continue
    fi

    output_prefix="${subject_output_dir}/${subject}_rigid"
    final_output="${subject_output_dir}/${subject}_rigid.nii.gz"
    final_seg_output="${subject_output_dir}/${subject}_segmentation_rigid.nii.gz"

    #rigid registration to MNI template
    antsRegistrationSyN.sh -d 3 \
        -n 20 \
        -t r \
        -f "$template" \
        -m "$input_image" \
        -o "$output_prefix"

    #rename warped output
    if [ -f "${output_prefix}Warped.nii.gz" ]; then
        mv "${output_prefix}Warped.nii.gz" "$final_output"
    else
        echo "Warning: Warped output not created for $subject. Skipping."
        continue
    fi

    transform_file="${output_prefix}0GenericAffine.mat"
    if [ ! -f "$transform_file" ]; then
        echo "Warning: Transform file not found for $subject. Skipping."
        continue
    fi

    #apply transform to manual segmentation
    if [ -f "$segmentation" ]; then
        antsApplyTransforms -d 3 \
            -i "$segmentation" \
            -r "$template" \
            -o "$final_seg_output" \
            -n GenericLabel \
            -t "$transform_file"
    else
        echo "Warning: Segmentation not found for $subject."
    fi

    echo "Completed: $subject"
    echo "--------------------------------------------"

done < "$subjects_file"

echo "Rigid alignment complete for dataset: $dataset"