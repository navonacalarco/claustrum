# Claustrum Project

This repo contains the claustrum segmentation we made of BigBrain, as well as the atlas we made at 0.5mm isotropic.

The files are as follows:

```markdown
| FileName                                        | Resolution (μm) | Type          | Hemisphere | Description |
|-------------------------------------------------|-----------------|---------------|------------|-------------|
| BigBrain/bigbrain_100um_CROPPED-LEFT.nii.gz     | 100             | intensity     | left       | cropped image underlying left segmentation               |
| BigBrain/bigbrain_100um_CROPPED-RIGHT.nii.gz    | 100             | intensity     | right      | cropped image underlying right segmentation              |
| BigBrain/claustrumSeg_LEFT.nii.gz               | 100             | segmentation  | left       | manual segmentation, left hemisphere, cropped            |
| BigBrain/claustrumSeg_RIGHT.nii.gz              | 100             | segmentation  | right      | manual segmentation, right hemisphere, cropped           |
| BigBrain/claustrumSeg_combined_uncropped.nii.gz | 100             | segmentation  | combined   | combined segmentations, in complete BigBrain dimensions  |
| atlas/mni_icbm152_t1_tal_nlin_sym_09b.nii.gz    | 500             | intensity     | combined   | MNI template                                             |
| atlas/claustrum_prob_weighted.nii.gz            | 500             | segmentaiton  | combined   | cross-modality atlas in MNI space; see description below |
```

The atlas was made from the following segmentations:

```markdown
| N | Dataset     | Resolution (μm) | Modality   | Ex vivo / In vivo | Segmenter | Subject ID |
|--------|-------------|-----------------|------------|-------------------|-----------|------------|
| 1      | BigBrain    | 100             | Histology  | Ex vivo           | us        | 1          |
| 1      | Edlow       | 100             | MRI        | Ex vivo           | Mauri     | 13         |
| 1      | Lusebrink   | 250             | MRI        | In vivo           | Mauri     | 16         |
| 10     | Montreal    | 500             | MRI        | In vivo           | us        | all 10     |
```


