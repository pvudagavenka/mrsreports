*&---------------------------------------------------------------------*
*& Report SAPFZPM_MRSWRKCOMP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zpm_mrswrkcomptop                       .    " Global Data

INCLUDE zpm_mrswrkcompo01.                       " PBO-Modules
INCLUDE zpm_mrswrkcompi01.                       " PAI-Modules
INCLUDE zpm_mrswrkcompf01.                       " FORM-Routines

START-OF-SELECTION.
  PERFORM display_output.
