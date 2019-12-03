*&---------------------------------------------------------------------*
*& Report SAPFZPM_MRSAVAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


INCLUDE zpm_mrsavailtop                        .    " Global Data
INCLUDE zpm_mrsavailo01.
INCLUDE zpm_mrsavaili01.
INCLUDE zpm_mrsavailf01.

START-OF-SELECTION.
  PERFORM display_output.
