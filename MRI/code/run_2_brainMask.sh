#!/bin/bash
####################################################################################################################################
# run_2_brainMask.sh
#
# Performs brain masking/skull stripping and iterative bias field correction on MPRAGEised MP2RAGE images.
# Uses FreeSurfer's mri_synthstrip for brain extraction and ANTs N4BiasFieldCorrection.
#
# Usage: ./run_2_brainMask.sh <inputDir> <outputDir> <subjectsFile>
####################################################################################################################################

#check for required arguments
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <inputDir> <outputDir> <subjectsFile>"
    exit 1
fi

#assign positional arguments
input_dir=$1
output_dir=$2
subjects_file=$3

#validate inputs
if [ ! -f "$subjects_file" ]; then
    echo "Error: Subjects file not found at $subjects_file"
    exit 1
fi

if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory '$input_dir' does not exist."
    exit 1
fi

if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir" || exit 1
fi

#iterate over subjects
while IFS= read -r subject_id || [[ -n "$subject_id" ]]; do
    [[ -z "$subject_id" || "$subject_id" =~ ^# ]] && continue
    subject_id=$(echo "$subject_id" | xargs)

    mkdir -p "${output_dir}/sub-${subject_id}"

    echo "----------------------------------------------------------------"
    echo "Processing subject ${subject_id}"
    echo "----------------------------------------------------------------"

    #brain extraction
    mri_synthstrip \
        -i "${input_dir}/sub-${subject_id}_MPRAGEised.nii.gz" \
        -o "${output_dir}/sub-${subject_id}/sub-${subject_id}_brain.nii.gz" \
        -m "${output_dir}/sub-${subject_id}/sub-${subject_id}_brainmask.nii.gz"

    #check mask was created before proceeding
    if [ ! -f "${output_dir}/sub-${subject_id}/sub-${subject_id}_brainmask.nii.gz" ]; then
        echo "Error: Brain mask not created for subject ${subject_id}. Skipping."
        continue
    fi

    #initial bias field correction pass
    N4BiasFieldCorrection \
        -d 3 -r 1 \
        -i "${input_dir}/sub-${subject_id}_MPRAGEised.nii.gz" \
        -o "${output_dir}/sub-${subject_id}/sub-${subject_id}_N4.nii.gz" \
        -x "${output_dir}/sub-${subject_id}/sub-${subject_id}_brainmask.nii.gz"

    #iterative bias field correction
    for iteration in {0..3}; do
        N4BiasFieldCorrection \
            -d 3 -r 1 \
            -i "${output_dir}/sub-${subject_id}/sub-${subject_id}_N4.nii.gz" \
            -o "${output_dir}/sub-${subject_id}/sub-${subject_id}_N4.nii.gz" \
            -x "${output_dir}/sub-${subject_id}/sub-${subject_id}_brainmask.nii.gz"
    done

    echo "Processing complete for subject ${subject_id}."

done < "$subjects_file"

echo "All subjects processed."