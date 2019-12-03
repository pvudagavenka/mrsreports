*&---------------------------------------------------------------------*
*& Include ZPM_MRSPLNKPITOP                         - Report SAPFZPM_MRSPLNKPI
*&---------------------------------------------------------------------*
REPORT sapfzpm_mrsplnkpi.


CONSTANTS:
  g_err_msg TYPE sy-msgty VALUE 'E'.

TABLES: aufk, afih, afko, crhd, tj30t, afvc.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS:
p_iwerk TYPE werks_d OBLIGATORY.

SELECT-OPTIONS:
  s_perio FOR afko-gstrs OBLIGATORY,
  s_auart FOR aufk-auart,
  s_aufnr FOR aufk-aufnr,
  s_ustat FOR tj30t-txt04 MATCHCODE OBJECT i_status_usr,
  s_ilart FOR afih-ilart,
  s_priok FOR afih-priok,
  s_arbpl FOR crhd-arbpl,
  s_steus FOR afvc-steus.
SELECTION-SCREEN END OF BLOCK b1.


**********************************************************************
* Data Declarations
**********************************************************************

DATA: g_ui_layout_ila  TYPE REF TO zcl_pm_mrsrep_uimgr,
      g_ui_layout_wct  TYPE REF TO zcl_pm_mrsrep_uimgr,
      g_ui_layout_oper TYPE REF TO zcl_pm_mrsrep_uimgr,
      g_wrk_kpi        TYPE REF TO zcl_pm_mrswrk_kpi,
      g_ok_code        TYPE        sy-ucomm,
      g_sel_oprlst     TYPE        zcl_pm_mrswrk_kpi=>ty_t_operkpi,
      g_subscr         TYPE        sy-dynnr VALUE 900.
