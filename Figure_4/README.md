Scripts and intermediary data files used to generate Figure 4.

## Download of Medaka 3´ UTR sequence##

From Ensemble BioMart (see 'Screenshot_download_medaka_3pUTR_sequences.png' for settings). File saved as 'Medaka_3p_UTRs.fa.gz'. Then:

``gunzip Medaka_3p_UTRs.fa.gz``


## Predicting deltaG for predicted target site##

For each TargetScan-predicted target site:
``./Module_binding_stability_analysis.pl Medaka_3p_UTRs.fa TargetScan_predicted_targets_at_stage_EV.csv UUCCUAUGCAUAUACUUCUUU > Predicted_stabilities_EV_TargetScan_predicted.dat;Rscript R_commands_binding_stability Predicted_stabilities_EV_TargetScan_predicted.dat``

For TargetScan-predicted target sites on differentially-expressed genes at early vitellogenesis:
``./Module_binding_stability_analysis.pl Medaka_3p_UTRs.fa Differentially_expressed_TargetScan_predicted_targets_at_stage_EV.csv UUCCUAUGCAUAUACUUCUUU > Predicted_stabilities_EV_differentially_expressed_TargetScan_predicted.dat;Rscript R_commands_binding_stability Predicted_stabilities_EV_differentially_expressed_TargetScan_predicted.dat``

For the final list of 8 candidate targets:
``head -1 Predicted_stabilities_EV_differentially_expressed_TargetScan_predicted.dat > Predicted_stabilities_final_8_candidates.dat;for g in ENSORLG00000022471 ENSORLG00000000991 ENSORLG00000024729 ENSORLG00000006370 ENSORLG00000026596 ENSORLG00000019685 ENSORLG00000010960 ENSORLG00000005995;do grep -w $g Predicted_stabilities_EV_differentially_expressed_TargetScan_predicted.dat ;done >> Predicted_stabilities_final_8_candidates.dat;Rscript R_commands_binding_stability Predicted_stabilities_final_8_candidates.dat``
