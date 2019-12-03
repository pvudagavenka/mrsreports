*----------------------------------------------------------------------*
***INCLUDE ZPM_MRSWRKCOMPF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DISPLAY_OUTPUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_output .

  TRY .
      CLEAR g_wrkcmpl_obj.
      g_wrkcmpl_obj = NEW zcl_pm_mrswrk_compliance(
          i_rng_auart = s_auart[] i_wrknode = p_node
          i_rng_priok = s_priok[] i_rng_ilart = s_ilart[]
          i_rng_arbpl = s_wkctr[] i_rng_perio = s_perio[]
          i_iwerk = p_iwerk i_snaptype = p_snpty
          i_wrkhier = p_hier i_hierplnt = p_hpln ).

      g_wrkcmpl_obj->get_work_compl_info( ).
    CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc).
      MESSAGE lo_exc->get_text( ) TYPE g_err_msg.
  ENDTRY.


  CLEAR g_ui_layout.
  CALL SCREEN 900.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELSCRN_PBO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM selscrn_pbo .

  LOOP AT SCREEN.
    IF screen-group1 EQ 'ZZ1'.
      screen-input = COND #( WHEN p_hier IS INITIAL THEN 0
                        WHEN p_hier IS NOT INITIAL THEN 1
                                ELSE screen-active ).
    ELSEIF screen-group1 EQ 'ZZ2'.
      screen-input = COND #( WHEN p_node IS NOT INITIAL THEN 0
                             WHEN p_node IS   INITIAL THEN 1
                              ELSE screen-input ).
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form VALIDATE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM validate_wrkhier .
  TRY .
      CALL METHOD zcl_pm_mrswrk_compliance=>validate_workctr_hier
        EXPORTING
          i_wrkhier = p_hier
          i_wrknode = p_node
          i_iwerk   = p_hpln.
    CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc) .
      MESSAGE lo_exc->get_text( ) TYPE g_err_msg.
  ENDTRY.

  IF p_hier IS INITIAL.
    CLEAR p_node.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_900
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_900 .

  SET PF-STATUS 'MAIN'.
  TRY .
      IF g_wrkcmpl_obj IS BOUND.
        SET TITLEBAR 'T01'
          WITH g_wrkcmpl_obj->g_rep_begda g_wrkcmpl_obj->g_rep_endda
               p_iwerk .
      ELSE.
        SET TITLEBAR 'T01'.
      ENDIF.

      CHECK g_ui_layout IS NOT BOUND.
      g_ui_layout = NEW #(
                      i_container_name = 'G_CC_WRKCTR_HIER'
                      i_repid = sy-repid i_dynnr = sy-dynnr
                      i_splitter = abap_true ).

      g_ui_layout->display_workcmpl_output(
        EXPORTING i_wrkcmpl_obj = g_wrkcmpl_obj ).
    CATCH zcx_pm_mrs_repmgr.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PAI_900
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pai_900 .
  CHECK g_ok_code EQ 'BACK'.   LEAVE PROGRAM.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form VALIDATE_SELPERIO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM validate_selperio .

  CHECK s_perio[] IS NOT INITIAL.
  IF s_perio[ 1 ]-low IS INITIAL.
    MESSAGE e021(zpmmc_mrswrk).
  ENDIF.

  IF s_perio[ 1 ]-high IS INITIAL.
    MESSAGE e022(zpmmc_mrswrk).
  ENDIF.

*      check if the date is start date of the week
  zcl_pm_mrs_snapshot=>get_first_last_dayofweek(
      EXPORTING i_date = s_perio[ 1 ]-low
      IMPORTING e_week_begda = DATA(lv_date_tmp) ).
  IF lv_date_tmp NE s_perio[ 1 ]-low.
    MESSAGE e008(zpmmc_mrswrk) WITH s_perio[ 1 ]-low.
  ENDIF.

  CLEAR lv_date_tmp.
  zcl_pm_mrs_snapshot=>get_first_last_dayofweek(
    EXPORTING i_date = s_perio[ 1 ]-high
    IMPORTING e_week_endda = lv_date_tmp ).
  IF s_perio[ 1 ]-high NE lv_date_tmp.
    MESSAGE e009(zpmmc_mrswrk) WITH s_perio[ 1 ]-high.
  ENDIF.
ENDFORM.
