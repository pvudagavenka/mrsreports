*&---------------------------------------------------------------------*
*& Report SAPFZPM_MRSPLNKPI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zpm_mrsplnkpitop                        .    " Global Data
INCLUDE zpm_mrsplnkpio01.
INCLUDE zpm_mrsplnkpii01.
INCLUDE zpm_mrsplnkpif01.

INITIALIZATION.
  PERFORM init.

START-OF-SELECTION.
  PERFORM display_output.
