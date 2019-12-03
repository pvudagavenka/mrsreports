*&---------------------------------------------------------------------*
*& Include          ZPM_MRSAVAILF01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CHECK_DATE_RANGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_date_range .
  IF s_perio[] IS INITIAL.
    RETURN.
  ENDIF.
  TRY .
      zcl_pm_mrs_availability=>check_date_range(
                                EXPORTING i_availability = p_avail
                                          i_begda = s_perio[ 1 ]-low
                                          i_endda = s_perio[ 1 ]-high ).
    CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc).
      MESSAGE lo_exc->get_text( ) TYPE 'E'.
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
      CLEAR g_mrs_avail.
      g_mrs_avail = NEW zcl_pm_mrs_availability( i_rng_tatyp = s_tatyp[]
                i_rng_respn = s_veran[] i_rng_catg = s_verwe[]
                i_rng_kokrs = s_kokrs[] i_rng_werks = s_werks[]
                i_rng_arbpl = s_arbpl[] i_rng_perio = s_perio[]
                i_availability = p_avail ).
      g_mrs_avail->filter_workcenter_selection( ).
    CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc).
      MESSAGE lo_exc->get_text( ) TYPE 'E'.
  ENDTRY.

  CLEAR g_ui_layout.
  CALL SCREEN 900.
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
      IF p_avail EQ abap_true.
        SET TITLEBAR 'T01' WITH TEXT-003
         g_mrs_avail->g_rep_begda g_mrs_avail->g_rep_endda.
      ELSE.
        SET TITLEBAR 'T01' WITH TEXT-004
         g_mrs_avail->g_rep_begda g_mrs_avail->g_rep_endda.
      ENDIF.

      CHECK g_ui_layout IS NOT BOUND.
      g_ui_layout = NEW #(
                      i_container_name = 'G_CC_AVAILSUMM'
                      i_repid = sy-repid i_dynnr = sy-dynnr
                      i_splitter = abap_false ).
*
      g_ui_layout->display_avail_summary(
        EXPORTING i_avail = p_avail i_mrs_avail = g_mrs_avail ).
    CATCH zcx_pm_mrs_repmgr.
  ENDTRY.
ENDFORM.
