*&---------------------------------------------------------------------*
*& Include          ZPM_MRSAVAILTOP
*&---------------------------------------------------------------------*
REPORT sapfzpm_mrsavail.

TABLES: crhd, crco, /mrss/c_bas_ta.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS:
    s_perio FOR sy-datum NO-EXTENSION OBLIGATORY,
    s_kokrs FOR crco-kokrs NO-EXTENSION NO INTERVALS OBLIGATORY,
    s_werks FOR crhd-werks,
    s_verwe FOR crhd-verwe,
    s_veran FOR crhd-veran,
    s_arbpl FOR crhd-arbpl,
    s_tatyp FOR /mrss/c_bas_ta-ta_type.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS: p_unavl TYPE boole_d RADIOBUTTON GROUP gr1
                                 USER-COMMAND ZZ1,
            p_avail TYPE boole_d RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK b2.

**********************************************************************
* Data Declarations
**********************************************************************
DATA: g_mrs_avail TYPE REF TO zcl_pm_mrs_availability,
      g_ui_layout TYPE REF TO zcl_pm_mrsrep_uimgr,
      g_ok_code   TYPE        sy-ucomm.

AT SELECTION-SCREEN.
  PERFORM check_date_range.
