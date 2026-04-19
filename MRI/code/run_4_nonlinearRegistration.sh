#!/bin/bash
####################################################################################################################################
# run_4_nonlinearRegistration.sh
#
# Performs nonlinear registration of preprocessed brain images to a resolution-matched MNI152 template
# using ANTs. Registration proceeds in three stages: rigid initialisation, full SyN registration,
# and transform application to manual segmentations. Supports three datasets selected at runtime.
#
# Usage: ./run_4_nonlinearRegistration.sh <dataset> <subjectsFile> <preprocessedDir> <segmentationDir> <outputDir>
# Available datasets: 0p5, 0p7, 1p0
####################################################################################################################################

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

#select resolution-matched MNI template and brainmask based on dataset
case "$dataset" in
    "0p5")
        mni_brain=<MNI152_0.5mm_skullstripped>
        mni_brainmask=<MNI152_0.5mm_brainmask>
        ;;
    "0p7")
        mni_brain=<MNI152_0.7mm_skullstripped>
        mni_brainmask=<MNI152_0.7mm_brainmask>
        ;;
    "1p0")
        mni_brain=<MNI152_1.0mm_skullstripped>
        mni_brainmask=<MNI152_1.0mm_brainmask>
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

echo "Starting nonlinear registration for dataset: $dataset"

#iterate over subjects
while read -r subject_id_raw; do
    [[ -z "$subject_id_raw" || "$subject_id_raw" =~ ^# ]] && continue

    subject_id="sub-${subject_id_raw}"
    echo "Processing subject: $subject_id"

    subject_output_dir="$output_dir/$subject_id"
    mkdir -p "$subject_output_dir"

    #set input paths
    subject_brain="${preprocessed_dir}/$dataset/$subject_id/${subject_id}_brain.nii.gz"
    subject_brainmask="${preprocessed_dir}/$dataset/$subject_id/${subject_id}_brainmask.nii.gz"
    subject_segmentation="${segmentation_dir}/$dataset/$subject_id/${subject_id}_segmentation_manual.nii.gz"

    if [ ! -f "$subject_brain" ] || [ ! -f "$subject_brainmask" ] || [ ! -f "$subject_segmentation" ]; then
        echo "Warning: One or more input files not found for $subject_id. Skipping."
        continue
    fi

    init_prefix="${subject_output_dir}/${subject_id}_initialisation_"
    stage_prefix="${subject_output_dir}/${subject_id}_3stage_"
    seg_output="${subject_output_dir}/${subject_id}_segmentation_manual_3stage.nii.gz"

    #step 1: rigid initialisation
    antsRegistrationSyNQuick.sh \
        -d 3 \
        -n 20 \
        -p f \
        -j 1 \
        -e 13 \
        -f "$mni_brain" \
        -m "$subject_brain" \
        -o "$init_prefix" \
        -t r

    #step 2: full SyN registration using initialisation and brain masks
    antsRegistrationSyN.sh \
        -d 3 \
        -n 20 \
        -t s \
        -p f \
        -j 1 \
        -e 13 \
        -x "$mni_brainmask","$subject_brainmask" \
        -i "${init_prefix}0GenericAffine.mat" \
        -f "$mni_brain" \
        -m "$subject_brain" \
        -o "$stage_prefix"

    #step 3: apply transforms to manual segmentation
    antsApplyTransforms \
        -d 3 \
        -n GenericLabel \
        -t "${stage_prefix}1Warp.nii.gz" \
        -t "${stage_prefix}0GenericAffine.mat" \
        -r "$mni_brain" \
        -i "$subject_segmentation" \
        -o "$seg_output"

    echo "Completed: $subject_id"
    echo "--------------------------------------------"

done < "$subjects_file"

echo "Nonlinear registration complete for dataset: $dataset"