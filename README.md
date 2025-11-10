# Claustrum Project

This repo contains the claustrum segmentation we made of BigBrain, as well as the atlas we made at 0.5mm isotropic.

The files are as follows:

<div style="overflow-x: auto;">
<table>
<thead>
<tr>
<th style="min-width: 400px;">FileName</th>
<th style="min-width: 120px;">Resolution (μm)</th>
<th style="min-width: 120px;">Type</th>
<th style="min-width: 120px;">Hemisphere</th>
<th style="min-width: 400px;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="white-space: nowrap;">BigBrain/bigbrain_100um_CROPPED-LEFT.nii.gz</td>
<td style="white-space: nowrap;">100</td>
<td style="white-space: nowrap;">intensity</td>
<td style="white-space: nowrap;">left</td>
<td style="white-space: nowrap;">cropped image underlying left segmentation</td>
</tr>
<tr>
<td style="white-space: nowrap;">BigBrain/bigbrain_100um_CROPPED-RIGHT.nii.gz</td>
<td style="white-space: nowrap;">100</td>
<td style="white-space: nowrap;">intensity</td>
<td style="white-space: nowrap;">right</td>
<td style="white-space: nowrap;">cropped image underlying right segmentation</td>
</tr>
<tr>
<td style="white-space: nowrap;">BigBrain/claustrumSeg_LEFT.nii.gz</td>
<td style="white-space: nowrap;">100</td>
<td style="white-space: nowrap;">segmentation</td>
<td style="white-space: nowrap;">left</td>
<td style="white-space: nowrap;">manual segmentation, left hemisphere, cropped</td>
</tr>
<tr>
<td style="white-space: nowrap;">BigBrain/claustrumSeg_RIGHT.nii.gz</td>
<td style="white-space: nowrap;">100</td>
<td style="white-space: nowrap;">segmentation</td>
<td style="white-space: nowrap;">right</td>
<td style="white-space: nowrap;">manual segmentation, right hemisphere, cropped</td>
</tr>
<tr>
<td style="white-space: nowrap;">BigBrain/claustrumSeg_combined_uncropped.nii.gz</td>
<td style="white-space: nowrap;">100</td>
<td style="white-space: nowrap;">segmentation</td>
<td style="white-space: nowrap;">combined</td>
<td style="white-space: nowrap;">combined segmentations, in complete BigBrain dimensions; overlay on intensity image available via <a href="https://drive.google.com/file/d/1jtjtr1lUzmPFR3D8_4fZX9FfqX2B-Koj/view?usp=sharing">GoogleDrive link</a></td>
</tr>
<tr>
<td style="white-space: nowrap;">atlas/mni_icbm152_t1_tal_nlin_sym_09b_SKULLSTRIPPED_0.5mm_iso.nii.gz</td>
<td style="white-space: nowrap;">500</td>
<td style="white-space: nowrap;">intensity</td>
<td style="white-space: nowrap;">combined</td>
<td style="white-space: nowrap;">MNI template</td>
</tr>
<tr>
<td style="white-space: nowrap;">atlas/claustrum_prob_weighted.nii.gz</td>
<td style="white-space: nowrap;">500</td>
<td style="white-space: nowrap;">segmentation</td>
<td style="white-space: nowrap;">combined</td>
<td style="white-space: nowrap;">Cross-modality atlas in MNI space; see description below</td>
</tr>
</tbody>
</table>
</div>

The atlas was made from the following segmentations:

```markdown
| N | Dataset     | Resolution (μm) | Modality   | Ex vivo / In vivo | Segmenter | Subject ID |
|--------|-------------|-----------------|------------|-------------------|-----------|------------|
| 1      | BigBrain    | 100             | Histology  | Ex vivo           | us        | 1          |
| 1      | Edlow       | 100             | MRI        | Ex vivo           | Mauri     | 13         |
| 1      | Lusebrink   | 250             | MRI        | In vivo           | Mauri     | 16         |
| 10     | Montreal    | 500             | MRI        | In vivo           | us        | all 10     |



