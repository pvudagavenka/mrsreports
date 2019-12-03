*&---------------------------------------------------------------------*
*& Include ZPM_MRSWRKSNAPTOP                        - Report SAPFZPM_MRSWRKSNAP
*&---------------------------------------------------------------------*
REPORT sapfzpm_mrswrksnap.

CONSTANTS: g_fld_endda TYPE fieldnam VALUE 'P_ENDDA',
           g_err_msg   TYPE sy-msgty VALUE 'E',
           g_schd_stat TYPE tj30t-txt04 VALUE 'FSCH'.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:
    p_begda TYPE begda OBLIGATORY,
    p_endda TYPE endda,
    p_sntyp TYPE zpmde_snap_type AS LISTBOX
                 VISIBLE LENGTH 18 OBLIGATORY DEFAULT '1',
    p_stat  TYPE tj30t-txt04 OBLIGATORY DEFAULT g_schd_stat.
  SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_ins TYPE boole_d RADIOBUTTON GROUP gr1 DEFAULT 'X',
              p_del TYPE boole_d RADIOBUTTON GROUP gr1.
  SELECTION-SCREEN END OF BLOCK b2.


AT SELECTION-SCREEN ON p_begda.
  PERFORM check_snapshot_dates.

AT SELECTION-SCREEN.
  PERFORM check_consistency.

AT SELECTION-SCREEN OUTPUT.
  PERFORM screen_output.
