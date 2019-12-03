*&---------------------------------------------------------------------*
*& Report SAPFZPM_MRSWRKSNAP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zpm_mrswrksnaptop                       .    " Global Data

INCLUDE zpm_mrswrksnapf01.

START-OF-SELECTION.
  PERFORM save_snapshot.
