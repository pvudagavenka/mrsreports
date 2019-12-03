class ZCL_PM_MRS_SNAPSHOT definition
  public
  final
  create public .

public section.

  data G_BEGDA type BEGDA read-only .
  data G_ENDDA type ENDDA read-only .
  data G_SNAPTYPE type ZPMDE_SNAP_TYPE read-only .

  methods CONSTRUCTOR
    importing
      !I_BEGDA type BEGDA
      !I_ENDDA type ENDDA
      !I_SNAPTYPE type ZPMDE_SNAP_TYPE
    raising
      ZCX_PM_MRS_REPMGR .
  class-methods CHECK_SNAPSHOT_DATES_FORCRT
    importing
      !I_BEGDA type BEGDA
      !I_ENDDA type ENDDA
      !I_SNAPTYPE type ZPMDE_SNAP_TYPE
    raising
      ZCX_PM_MRS_REPMGR .
  methods CREATE_SNAPSHOT
    importing
      !I_SCHD_STAT type TJ30T-TXT04
    raising
      ZCX_PM_MRS_REPMGR .
  methods DELETE_SNAPSHOT
    raising
      ZCX_PM_MRS_REPMGR .
  class-methods GET_FIRST_LAST_DAYOFWEEK
    importing
      value(I_DATE) type SY-DATUM
    exporting
      value(E_WEEK_BEGDA) type BEGDA
      value(E_WEEK_ENDDA) type ENDDA .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PM_MRS_SNAPSHOT IMPLEMENTATION.


  METHOD check_snapshot_dates_forcrt.

    IF i_begda IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>start_date_blank.
    ENDIF.

*      check if the date is start date of the week
      zcl_pm_mrs_snapshot=>get_first_last_dayofweek( EXPORTING i_date = i_begda IMPORTING e_week_begda = DATA(lv_date_tmp) ).
      IF i_begda NE lv_date_tmp.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>invalid_start_date
          g_begda = |{ i_begda DATE = USER }|.
      ENDIF.

    IF i_endda IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>end_date_blank.
    ENDIF.

*      check if the date is end date of the week
      CLEAR lv_date_tmp.
      zcl_pm_mrs_snapshot=>get_first_last_dayofweek( EXPORTING i_date = i_endda IMPORTING e_week_endda = lv_date_tmp ).
      IF i_endda NE lv_date_tmp.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>invalid_end_date
          g_endda = |{ i_endda DATE = USER }|
          .
      ENDIF.

    IF  i_snaptype IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>snapshot_type_blank
          .
    ENDIF.

*    Based on the snapshot type determine the no of weeks
    DATA(lv_week_per) = SWITCH i( i_snaptype WHEN '1' THEN 1 WHEN '2' THEN 2
                                  WHEN '4' THEN 4 WHEN '8' THEN 8 ELSE 0 ).
    IF lv_week_per IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>snap_type_week_blank
          g_snapshot_type = i_snaptype.
    ENDIF.

*    Get the end day of the week based on the week range
    CLEAR lv_date_tmp.
    lv_date_tmp = i_begda - 1 + ( lv_week_per * 7 ).
    IF lv_date_tmp NE i_endda.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>snap_type_week_blank
          g_begda = |{ i_begda DATE = USER }|
          g_endda = |{ i_endda DATE = USER }|
          g_snapshot_type = i_snaptype.
    ENDIF.

*  Check if there are any entries for the current start and end dates
  SELECT SINGLE begda, endda FROM zpmttsnapshot
    INTO @DATA(ls_overlap)
   WHERE begda EQ @i_begda AND endda EQ @i_endda
     AND snaptype EQ @i_snaptype.
   IF sy-subrc IS INITIAL.
     RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>creation_not_possible
          g_begda = |{ i_begda DATE = USER }|
          g_endda = |{ i_endda DATE = USER }|
          g_snapshot_type = i_snaptype.
   ENDIF.

*   Check if there is an overlap with dates in the future.
   CHECK i_snaptype NE 1."for 1 weekt the above check is enough.
   CLEAR: ls_overlap.
  SELECT SINGLE begda, endda FROM zpmttsnapshot
    INTO @ls_overlap
   WHERE begda LT @i_begda AND endda GT @i_begda
    AND snaptype EQ @i_snaptype.
   IF sy-subrc IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>creation_overlap
          g_begda = |{ ls_overlap-begda DATE = USER }|
          g_endda = |{ ls_overlap-endda DATE = USER }|
          g_snapshot_type = i_snaptype.
   ENDIF.
  ENDMETHOD.


  METHOD constructor.

    IF i_begda IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>start_date_blank.
    ENDIF.

    IF i_endda IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>end_date_blank.
    ENDIF.
    IF  i_snaptype IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>snapshot_type_blank
          .
    ENDIF.

  g_begda = i_begda.
  g_endda = i_endda.
  g_snaptype = i_snaptype.

  ENDMETHOD.


  METHOD create_snapshot.

    DATA: lv_tstmp TYPE p.

* check if there is already an entry in the snapshot header for the current week data
    check_snapshot_dates_forcrt( i_begda = g_begda i_endda = g_endda i_snaptype = g_snaptype ).

* Get Work orders scheduled based on the snapshot week type( 1 ro 2 or 4 weeks).
*    The logic to get the work orders is to select all the work orders with current status FSHM
*    and ignore the deleted orders and operations. Only select those work order, where
*  the latest finish is within the current snapshot week type.
    SELECT aufk~aufnr, afvc~aufpl, afvc~aplzl, aufk~objnr AS ord_objnr, afvc~objnr AS oper_objnr, ssedd
      INTO TABLE @DATA(lt_ordschd)
      FROM aufk
     INNER JOIN afko  ON aufk~aufnr = afko~aufnr
     INNER JOIN afvc  ON afko~aufpl = afvc~aufpl
     INNER JOIN afvv  ON afvc~aufpl = afvv~aufpl AND afvc~aplzl = afvv~aplzl
     INNER JOIN jsto  ON aufk~objnr = jsto~objnr
     INNER JOIN tj30t ON jsto~stsma = tj30t~stsma AND spras = @sy-langu
            AND tj30t~txt04 = @i_schd_stat
     INNER JOIN jest  ON aufk~objnr = jest~objnr AND jest~stat = tj30t~estat
     WHERE autyp = '30' AND inact = '' AND ssedd GE @g_begda AND ssedd LE @g_endda
       AND afvc~loekz EQ ''.
    IF sy-subrc IS NOT INITIAL.
*    No work orders, then save the header only
    ENDIF.

    IF lt_ordschd[] IS NOT INITIAL."Fill the work order operation detail
      DATA(lt_sch_save) = VALUE zpmty_snap_ordsch( FOR ls_ordschd IN lt_ordschd
                           ( begda = g_begda endda = g_endda aufnr = ls_ordschd-aufnr
                            aufpl = ls_ordschd-aufpl aplzl = ls_ordschd-aplzl
                            ssedd = ls_ordschd-ssedd ) ).
    ENDIF.

    CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP lv_tstmp TIME ZONE sy-zonlo.
    DATA(ls_header) = VALUE zpmttsnapshot( begda = g_begda endda = g_endda  snaptype = g_snaptype
                                create_user = sy-uname create_time = lv_tstmp ).

*    Save the snapshot to the DB.
    CALL FUNCTION 'Z_PM_ORDSCH_SNAPSHOT_SAVE' IN UPDATE TASK
      EXPORTING
        i_header = ls_header
        i_ordsch = lt_sch_save.

  ENDMETHOD.


  METHOD delete_snapshot.
*    Check if there is a snapshot already in the system.
    SELECT SINGLE * FROM zpmttsnapshot INTO @DATA(ls_header)
     WHERE begda = @g_begda AND endda = @g_endda.
     IF sy-subrc IS NOT INITIAL."No entry in the DB
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>delete_not_possible
          g_begda = |{ g_begda DATE = USER }|
          g_endda = |{ g_endda DATE = USER }|.
     ENDIF.

*     Get the work order info
     SELECT * FROM zpmttsnap_wrk INTO TABLE @DATA(lt_ordschd)
      WHERE begda = @g_begda AND endda = @g_endda.
     IF sy-subrc IS NOT INITIAL.
*"No work order operarations exists. This is fine!
     ENDIF.

    CALL FUNCTION 'Z_PM_ORDSCH_SNAPSHOT_SAVE' IN UPDATE TASK
      EXPORTING
        i_header_del       = ls_header
        i_ordsch_del       = lt_ordschd.

  ENDMETHOD.


  method GET_FIRST_LAST_DAYOFWEEK.

*      check if the date is start date of the week
  CALL FUNCTION '/MRSS/DATE_GET_FIRST_WEEKDAY'
    EXPORTING
      date_in        = i_date
   IMPORTING
     date_out       = e_week_begda .

  CHECK e_week_begda IS NOT INITIAL AND e_week_endda IS SUPPLIED.
  e_week_endda = e_week_begda + 6.
  endmethod.
ENDCLASS.
