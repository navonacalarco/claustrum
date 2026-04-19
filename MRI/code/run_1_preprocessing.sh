#!/bin/bash
####################################################################################################################################
# run_1_preprocessing.sh
#
# Applies background noise removal to MP2RAGE UNI images using MPRAGEise (github.com/srikash/MPRAGEise),
# converting them to MPRAGE-like images suitable for downstream processing. Iterates over subjects and sessions
# in BIDS-formatted input data, operating on defaced INV2 and UNI T1 maps.
#
# Usage: ./run_1_preprocessing.sh <inputDir> <outputDir> <subjectsFile> [numSessions]
####################################################################################################################################

#check for required arguments
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <inputDir> <outputDir> <subjectsFile> [numSessions]"
    exit 1
fi

#assign positional arguments
input_dir=$1
output_dir=$2
subjects_file=$3
num_sessions=${4:-1}

#validate inputs
if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory '$input_dir' does not exist."
    exit 1
fi

if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir" || exit 1
fi

if [ ! -f "$subjects_file" ]; then
    echo "Error: Subjects file '$subjects_file' does not exist."
    exit 1
fi

#if multiple sessions, validate all expected data files exist
if [ "$num_sessions" -gt 1 ]; then
    while read -r subject_id; do
        for (( session=1; session<=$num_sessions; session++ )); do
            session_formatted=$(printf "%02d" $session)
            data_file="${input_dir}/sub-${subject_id}/ses-${session_formatted}/anat/sub-${subject_id}_ses-${session_formatted}_acq-inv2_T1map_defaced.nii.gz"
            if [ ! -f "$data_file" ]; then
                echo "Error: Data not found for subject $subject_id, session $session_formatted."
                exit 1
            fi
        done
    done < "$subjects_file"
fi

subject_count=$(grep -cve '^\s*$' "$subjects_file")
echo "Running for ${subject_count} subjects"

cd "$output_dir"

#iterate over subjects
while read -r subject_id; do
    [[ -z "$subject_id" || "$subject_id" =~ ^# ]] && continue

    #iterate over sessions
    for (( session=1; session<=$num_sessions; session++ )); do
        session_formatted=$(printf "%02d" $session)

        #apply MPRAGEise
        MPRAGEise \
            -i "${input_dir}/sub-${subject_id}/ses-${session_formatted}/anat/sub-${subject_id}_ses-${session_formatted}_acq-inv2_T1map_defaced.nii.gz" \
            -u "${input_dir}/sub-${subject_id}/ses-${session_formatted}/anat/sub-${subject_id}_ses-${session_formatted}_acq-uni_T1map_defaced.nii.gz"
    done

done < "$subjects_file"