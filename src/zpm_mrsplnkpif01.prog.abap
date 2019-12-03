*----------------------------------------------------------------------*
***INCLUDE ZPM_MRSPLNKPIF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form PAI_900
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pai_900 .
  CASE g_ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'BYILA' OR 'BACK_OP'.
      LEAVE TO SCREEN 0.
    WHEN 'BYWCTR'.
      CALL SCREEN 901.
    WHEN 'WKOPR'.
      PERFORM display_operlist USING 'W'.
    WHEN 'ILAOPR'.
      PERFORM display_operlist USING 'I'.
    WHEN OTHERS.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_900
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_900.
  TRY .
      CHECK g_ui_layout_ila IS NOT BOUND.
      g_ui_layout_ila = NEW #(
                      i_container_name = 'G_CC_ILAKPI'
                      i_repid = sy-repid i_dynnr = sy-dynnr
                       ).

      g_ui_layout_ila->display_plnkpi_output(
      EXPORTING i_plnkpi = g_wrk_kpi i_kpisel = 'I' ).
    CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc).
      MESSAGE lo_exc->get_text( ) TYPE g_err_msg.
  ENDTRY.
ENDFORM.
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
      CLEAR g_wrk_kpi.
      g_wrk_kpi = NEW zcl_pm_mrswrk_kpi(
          i_rng_auart = s_auart[] i_rng_arbpl = s_arbpl[]
          i_rng_priok = s_priok[] i_rng_ilart = s_ilart[]
          i_rng_perio = s_perio[] i_rng_aufnr = s_aufnr[]
          i_iwerk = p_iwerk i_rng_ustat = s_ustat[]
          i_rng_steus = s_steus[] ).

      g_wrk_kpi->get_oper_kpi( ).
    CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc).
      MESSAGE lo_exc->get_text( ) TYPE g_err_msg.
  ENDTRY.
  CLEAR: g_ui_layout_ila, g_ui_layout_wct, g_ui_layout_oper.
  CALL SCREEN 900.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_901
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_901 .
  TRY .
      CHECK g_ui_layout_wct IS NOT BOUND.
      g_ui_layout_wct = NEW #(
                  i_container_name = 'G_CC_WCTRKPI'
                  i_repid = sy-repid i_dynnr = sy-dynnr
                   ).

      g_ui_layout_wct->display_plnkpi_output(
      EXPORTING i_plnkpi = g_wrk_kpi i_kpisel = 'W' ).
    CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc).
      MESSAGE lo_exc->get_text( ) TYPE g_err_msg.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PBO_903
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_903 .

  TRY .
      IF g_ui_layout_oper IS NOT BOUND.
        g_ui_layout_oper = NEW #(
                    i_container_name = 'G_CC_OPERLIST'
                    i_repid = sy-repid i_dynnr = sy-dynnr
                     ).
      ENDIF.

      g_ui_layout_oper->display_plnkpi_output(
      EXPORTING i_plnkpi = g_wrk_kpi i_kpisel = 'O'
        i_disp_operkpi = g_sel_oprlst ).
    CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc).
      MESSAGE lo_exc->get_text( ) TYPE g_err_msg.
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_OPERLIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_operlist USING i_kpisel .
  REFRESH: g_sel_oprlst.
  TRY .
      CASE i_kpisel.
        WHEN 'I'.
          IF g_ui_layout_ila->g_alv_ilakpi IS BOUND.
            g_ui_layout_ila->g_alv_ilakpi->get_selected_rows(
            IMPORTING et_index_rows = DATA(lt_selrow) ).

            g_sel_oprlst = g_wrk_kpi->g_operwrk_kpi[].
            DELETE g_sel_oprlst WHERE ilart NE
         g_ui_layout_ila->g_disp_ilakpi[ lt_selrow[
         1 ]-index ]-ilart.
          ENDIF.

        WHEN 'W'.
          IF g_ui_layout_wct->g_alv_wctrkpi IS BOUND.
            g_ui_layout_wct->g_alv_wctrkpi->get_selected_rows(
            IMPORTING et_index_rows = lt_selrow ).

            g_sel_oprlst = g_wrk_kpi->g_operwrk_kpi[].
            DELETE g_sel_oprlst WHERE workcenter NE
         g_ui_layout_wct->g_disp_wkctrkpi[
         lt_selrow[ 1 ]-index ]-workcenter.
          ENDIF.

        WHEN OTHERS.
          MESSAGE s028(zpmmc_mrswrk).
      ENDCASE.
      CALL SCREEN 903.
    CATCH cx_sy_itab_line_not_found.
      MESSAGE s028(zpmmc_mrswrk).
  ENDTRY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init .
  DATA: p_obtyp TYPE jsto-obtyp.
  p_obtyp = 'ORI'.
  EXPORT p_obtyp TO MEMORY ID 'PM_OBTYP'.
ENDFORM.
