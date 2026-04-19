## MRI preprocessing code

The `code/` directory contains shell scripts used to preprocess the three in vivo MRI datasets.
Scripts are written in bash and call external tools including [MPRAGEise](https://github.com/srikash/MPRAGEise),
FreeSurfer, ANTs, and AFNI. All datasets were processed through the same pipeline.

Scripts accept dataset as a command-line argument (`0p5`, `0p7`, or `1p0`),
corresponding to the three acquisition resolutions (0.5 mm, 0.7 mm, and 1.0 mm isotropic).

| Script | Description |
| --- | --- |
| `mpragise.sh` | Removes background noise from MP2RAGE UNI images, producing MPRAGE-like images |
| `brainmask.sh` | Performs brain extraction and iterative bias field correction |
| `rigid_registration.sh` | Rigid registration to a resolution-matched MNI152 template |
| `nonlinear_registration.sh` | Full SyN registration to MNI152 template |

All claustrum segmentations were performed manually on preprocessed images (skull-stripped and
bias field corrected) in each subject's native space. The three runs from the 0.5mm dataset
were registered and averaged prior to segmentation, using ANTs. For all datasets, registration
to MNI152 was performed subsequently, with segmentation masks carried into template space via
the estimated transforms.
