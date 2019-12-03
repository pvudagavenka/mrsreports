*&---------------------------------------------------------------------*
*& Include ZPM_MRSWRKCOMPTOP                        - Report SAPFZPM_MRSWRKCOMP
*&---------------------------------------------------------------------*
REPORT sapfzpm_mrswrkcomp.

CONSTANTS:
  g_err_msg TYPE sy-msgty VALUE 'E'.

TABLES: aufk, afih, crhd.

SELECTION-SCREEN SKIP.
PARAMETERS:
  p_iwerk TYPE werks_d OBLIGATORY,
  p_snpty TYPE zpmde_snap_type AS LISTBOX VISIBLE LENGTH 18
               OBLIGATORY DEFAULT '1'.
SELECT-OPTIONS:
    s_perio FOR sy-datum NO-EXTENSION OBLIGATORY.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
SELECT-OPTIONS:
  s_auart FOR aufk-auart,
  s_ilart FOR afih-ilart,
  s_priok FOR afih-priok.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS:
  p_hpln TYPE crhh-werks,
  p_hier TYPE cr_hname MATCHCODE OBJECT crhm,
  p_node TYPE arbpl    MATCHCODE OBJECT ash_cram
                       MODIF ID zz1.

SELECT-OPTIONS:
 s_wkctr FOR crhd-arbpl MATCHCODE OBJECT ash_cram
                        MODIF ID zz2.
SELECTION-SCREEN END OF BLOCK b2.

**********************************************************************
* Data Declarations
**********************************************************************

DATA: g_ui_layout   TYPE REF TO zcl_pm_mrsrep_uimgr,
      g_wrkcmpl_obj TYPE REF TO zcl_pm_mrswrk_compliance,
      g_ok_code     TYPE        sy-ucomm.

at SELECTION-SCREEN on s_perio.
  PERFORM validate_selperio.

AT SELECTION-SCREEN.
  PERFORM validate_wrkhier.

AT SELECTION-SCREEN OUTPUT.
  PERFORM selscrn_pbo.
