*----------------------------------------------------------------------*
***INCLUDE ZPM_MRSWRKSNAPF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CHECK_SNAPSHOT_DATES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_snapshot_dates .

*  IF  p_begda LE sy-datum.
*    MESSAGE e001(ZPMMC_MRSWRK) .
*  ENDIF.

*      check if the date is start date of the week
zcl_pm_mrs_snapshot=>get_first_last_dayofweek(
    EXPORTING i_date = p_begda
    IMPORTING e_week_begda = DATA(lv_date_tmp) ).
  IF p_begda NE lv_date_tmp.
    MESSAGE e002(zpmmc_mrswrk) WITH p_begda.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SCREEN_OUTPUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM screen_output .

  LOOP AT SCREEN.
    IF screen-name EQ g_fld_endda.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CHECK_OVERLAP_FORCRT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_overlap_forcrt .
  TRY.
  CALL METHOD zcl_pm_mrs_snapshot=>check_snapshot_dates_forcrt
    EXPORTING
      i_begda    = p_begda
      i_endda    = p_endda
      i_snaptype = p_sntyp
      .
   CATCH ZCX_PM_MRS_REPMGR INTO DATA(lo_exc) .
     MESSAGE lo_exc->get_text( ) TYPE g_err_msg.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_SNAPSHOT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_snapshot .
  TRY.
    IF p_del EQ abap_true."Delete Snapshot
      NEW zcl_pm_mrs_snapshot( i_begda = p_begda i_endda = p_endda
               i_snaptype = p_sntyp )->delete_snapshot( ).

      MESSAGE s019(zpmmc_mrswrk) WITH  p_begda p_endda p_sntyp.
    ELSE."Create Snapshot
      NEW zcl_pm_mrs_snapshot( i_begda = p_begda i_endda = p_endda
      i_snaptype = p_sntyp )->create_snapshot( i_schd_stat = p_stat  ).

      MESSAGE s018(zpmmc_mrswrk) WITH  p_begda p_endda p_sntyp.
    ENDIF.

    COMMIT WORK AND WAIT.

    CATCH ZCX_PM_MRS_REPMGR INTO DATA(lo_exc).
      MESSAGE lo_exc->get_text( ) TYPE g_err_msg.
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_CONSISTENCY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_consistency .
*  Get the week ending for the current snapshot type
  p_endda  = p_begda - 1 + ( p_sntyp * 7 ).

  IF p_ins EQ abap_true.
    PERFORM check_overlap_forcrt.
  ELSE."Delete Snapshot
*    Check if there is an entry with the start and end of week dates
     SELECT SINGLE begda, endda FROM zpmttsnapshot
    INTO @DATA(ls_exists)
   WHERE begda EQ @p_begda AND endda EQ @p_endda
     AND snaptype EQ @p_sntyp.
   IF sy-subrc IS NOT INITIAL.
     MESSAGE e005(zpmmc_mrswrk) WITH |{ p_begda DATE = USER }|
                                     |{ p_endda DATE = USER }|
                                     p_sntyp.
   ENDIF.
  ENDIF.

ENDFORM.
