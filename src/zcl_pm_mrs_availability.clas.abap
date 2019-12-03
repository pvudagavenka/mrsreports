class ZCL_PM_MRS_AVAILABILITY definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF TY_S_EMPDET,
          pernr TYPE pa0002-pernr,
          begda TYPE pa0002-begda,
          nachn TYPE pa0002-nachn,
          vorna TYPE pa0002-vorna,
        END OF TY_S_EMPDET .
  types:
    ty_t_empdet TYPE HASHED TABLE OF TY_S_EMPDET WITH UNIQUE KEY pernr .
  types:
    BEGIN OF ty_s_monfld,
             monyr(6)  TYPE n,
             field(30) TYPE c,
           END OF ty_s_monfld .
  types:
    ty_t_monfld TYPE TABLE OF ty_s_monfld .
  types:
    ty_t_wkctr_avail TYPE HASHED TABLE OF zpmstwkctr_avail WITH UNIQUE KEY werks arbpl pernr datum .
  types:
    ty_t_wkctr_ta TYPE HASHED TABLE OF zpmstwkctr_ta WITH UNIQUE KEY werks arbpl timespec_type .
  types:
    BEGIN OF ty_s_work_center ,
        objid TYPE crhd-objid,
        arbpl TYPE crhd-arbpl,
        werks TYPE crhd-werks,
        ktext TYPE crtx-ktext,
        kokrs TYPE crco-kokrs,
        veran TYPE crhd-veran,
        verwe TYPE crhd-verwe,
        endda TYPE crco-endda,
        kapid TYPE crhd-kapid,
        BEGZT TYPE kako-begzt,
        ENDZT TYPE KAKO-ENDZT,
        pause TYPE KAKO-PAUSE,
        aznor TYPE KAKO-AZNOR,
        ngrad TYPE KAKO-NGRAD,
      END OF ty_s_work_center .
  types:
    ty_t_work_centers TYPE HASHED TABLE OF ty_s_work_center WITH UNIQUE KEY objid .
  types:
    ty_t_crid TYPE TABLE OF rcrid .
  types:
    ty_t_res_asgn TYPE TABLE OF zpmviasgwrk .
  types:
    ty_t_time_alloc TYPE TABLE OF zpmvitimealloc .
  types:
    ty_rng_restyp TYPE RANGE OF /mrss/d_bas_res-resource_type .
  types:
    BEGIN OF ty_s_resource,
        pernr TYPE pa0001-pernr,
        key   TYPE /mrss/d_bas_res-resource_key,
      END OF ty_s_resource .
  types:
    ty_t_resource TYPE TABLE OF ty_s_resource .
  types:
    ty_rng_tatyp TYPE RANGE OF /mrss/c_bas_ta-ta_type .
  types:
    ty_rng_respn TYPE RANGE OF crhd-veran .
  types:
    ty_rng_catg TYPE RANGE OF crhd-verwe .
  types:
    ty_rng_kokrs TYPE RANGE OF kokrs .
  types:
    ty_rng_werks TYPE RANGE OF crhd-werks .

  data G_AVAILABILITY type BOOLE_D read-only .
  data G_REP_BEGDA type BEGDA read-only .
  data G_REP_ENDDA type ENDDA read-only .
  data G_RNG_TATYP type TY_RNG_TATYP read-only .
  data G_RNG_RESPN type TY_RNG_RESPN read-only .
  data G_RNG_CATG type TY_RNG_CATG read-only .
  data G_RNG_KOKRS type TY_RNG_KOKRS read-only .
  data G_RNG_WERKS type TY_RNG_WERKS read-only .
  data G_RNG_ARBPL type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_ARBPL read-only .
  data G_TIME_ALLOC type TY_T_TIME_ALLOC read-only .
  data G_RES_ASGN type TY_T_RES_ASGN read-only .
  data G_WORK_CENTERS type TY_T_WORK_CENTERS read-only .
  data G_WKCTR_TA type TY_T_WKCTR_TA read-only .
  data G_WKCTR_AVAIL type TY_T_WKCTR_AVAIL read-only .
  data G_EMPDET type TY_T_EMPDET read-only .
  data G_TIME_ZONE type /MRSS/T_SGE_GLOBAL_TIMEZONE read-only .
  data G_BEG_TSTMP type TIMESTAMP read-only .
  data G_END_TSTMP type TIMESTAMP read-only .
  data G_MONFLD type TY_T_MONFLD .

  methods CONSTRUCTOR
    importing
      !I_RNG_TATYP type TY_RNG_TATYP optional
      !I_RNG_RESPN type TY_RNG_RESPN optional
      !I_RNG_CATG type TY_RNG_CATG optional
      !I_RNG_KOKRS type TY_RNG_KOKRS optional
      !I_RNG_WERKS type TY_RNG_WERKS optional
      !I_RNG_ARBPL type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_ARBPL optional
      !I_RNG_PERIO type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_PERIO
      !I_AVAILABILITY type BOOLE_D optional
    raising
      ZCX_PM_MRS_REPMGR .
  class-methods CHECK_DATE_RANGE
    importing
      !I_AVAILABILITY type BOOLE_D
      !I_BEGDA type BEGDA
      !I_ENDDA type ENDDA
    raising
      ZCX_PM_MRS_REPMGR .
  methods FILTER_WORKCENTER_SELECTION
    raising
      ZCX_PM_MRS_REPMGR .
  methods DETERMINE_TIME_ALLOCATIONS
    importing
      !I_RESOURCE_SEL type TY_T_RESOURCE optional
      !I_RNG_RESTYP type TY_RNG_RESTYP
    raising
      ZCX_PM_MRS_REPMGR .
  methods DETERMINE_RESOURCE_ASGN
    importing
      !I_RESOURCE_SEL type TY_T_RESOURCE optional
      !I_RNG_RESTYP type TY_RNG_RESTYP .
  methods DETERMINE_PERSONS_OF_WKCTR
    importing
      !I_WKCTR_SEL type TY_T_CRID
    exporting
      !E_PERSON_ASGN type RPLM_TT_PERSON_ASSIGNMENT
      !E_RESOURCE_SEL type TY_T_RESOURCE
    raising
      ZCX_PM_MRS_REPMGR .
  methods DETERMINE_WKCTR_OF_PERSON
    importing
      !I_PERSON_SEL type TY_T_CRID
    exporting
      !E_WKCTR_ASGN type RPLM_TT_PERSON_ASSIGNMENT .
protected section.
private section.

  methods GET_AVAILABILITY_SUMMARY
    importing
      !I_RESOURCE_SEL type TY_S_RESOURCE
      !I_PERSON_ASGN type OBJECT_PERSON_ASSIGNMENT
      !I_AVAIL type ZPMSTWKCTR_AVAIL .
  methods GET_TIME_ALLOC_SUMMARY
    importing
      !I_RESOURCE_SEL type TY_S_RESOURCE
      !I_PERSON_ASGN type OBJECT_PERSON_ASSIGNMENT
      !I_ALLOC type ZPMSTWKCTR_TA .
  methods GET_RESOURCE_SELECTION
    exporting
      !E_RESOURCE_SEL type TY_T_RESOURCE
      !E_PERSON_SEL type TY_T_CRID .
ENDCLASS.



CLASS ZCL_PM_MRS_AVAILABILITY IMPLEMENTATION.


  METHOD check_date_range.

    DATA lv_endda TYPE endda.

    IF i_endda IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>repweek_end_date_blank.
    ENDIF.

* Check date range is valid
    IF i_availability EQ abap_true.
*      Max Date range is 3 months
      DATA(lv_mon) = 6.
    ELSE.
*      *      Max Date range is 12 months
      lv_mon = 12.
    ENDIF.
    CALL FUNCTION '/MRSS/ADD_MONTH_TO_DATE'
      EXPORTING
        months  = lv_mon
        olddate = i_begda
      IMPORTING
        newdate = lv_endda.
    lv_endda = lv_endda - 1.
    IF i_endda GT lv_endda.
* Invalid date range
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid   = zcx_pm_mrs_repmgr=>date_range_invalid
          g_begda  = |{ i_begda DATE = USER  }|
          g_endda  = |{ i_endda DATE = USER  }|
          g_months = lv_mon.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    DATA: lv_endda TYPE endda.
    IF i_rng_perio[] IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>repweek_start_date_blank.
    ELSE.
      IF i_rng_perio[ 1 ]-low IS INITIAL.
        RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
          EXPORTING
            textid = zcx_pm_mrs_repmgr=>repweek_start_date_blank.
      ELSE.
        g_rep_begda = i_rng_perio[ 1 ]-low.
      ENDIF.
      IF i_rng_perio[ 1 ]-high IS INITIAL.
        RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
          EXPORTING
            textid = zcx_pm_mrs_repmgr=>repweek_end_date_blank.
      ELSE.
        g_rep_endda = i_rng_perio[ 1 ]-high.
      ENDIF.
    ENDIF.

    IF i_rng_kokrs IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>contrl_area_missing.
    ENDIF.

*    Check date range is valid
    check_date_range( i_begda = g_rep_begda i_endda = g_rep_endda i_availability = i_availability ).

    g_availability = i_availability.
    g_rng_tatyp = i_rng_tatyp.
    g_rng_respn = i_rng_respn.
    g_rng_catg  = i_rng_catg.
    g_rng_kokrs = i_rng_kokrs.
    g_rng_werks = i_rng_werks.
    g_rng_arbpl = i_rng_arbpl.

* Add the exclusion TA types into the range table.
    g_rng_tatyp = VALUE #( BASE g_rng_tatyp ( sign = 'E' option = 'EQ' low = 'WORK' )
                                            ( sign = 'E' option = 'EQ' low = 'WORK_BREAK' ) ).

*    Determine timestamps for the start and end date range using the global time zone of MRS
    g_time_zone = /mrss/cl_sge_customizing=>get_global_timezone( ).

    CONVERT DATE g_rep_begda
      INTO TIME STAMP g_beg_tstmp
      TIME ZONE g_time_zone.

    CONVERT DATE g_rep_endda
      TIME 235959
      INTO TIME STAMP g_end_tstmp
      TIME ZONE g_time_zone.

* Determine the month year field
    IF g_availability EQ abap_false.
      DATA(lv_begmon) = g_rep_begda(6).
      DATA(lv_endmon) = g_rep_endda(6).

      DO 13 TIMES."Maximum is 13 months
        DATA(lv_idx) = sy-index.
        APPEND VALUE #( monyr = lv_begmon field = 'MON' && lv_idx && '_DUR' ) TO g_monfld.
        IF lv_begmon ge lv_endmon.
          EXIT.
        ENDIF.

        IF lv_begmon+4(2) eq 12.
          lv_begmon(4) = lv_begmon(4) + 1.
          lv_begmon+4(2) = '01'.
        else.
          lv_begmon = lv_begmon + 1.
        ENDIF.
      ENDDO.
    ENDIF.

  ENDMETHOD.


  METHOD determine_persons_of_wkctr.

    DATA lv_reskey     TYPE          sys_uid-id.

* GEt the persons assigned to the work centers
    CALL FUNCTION 'COI2_PERSON_OF_WORKCENTER'
      EXPORTING
        begda                       = g_rep_begda
        endda                       = g_rep_endda
        duplicates                  = 'X'
      TABLES
        in_object                   = i_wkctr_sel
        out_persons                 = e_person_asgn
      EXCEPTIONS
        no_person_found             = 1
        invalid_object              = 2
        invalid_hr_planning_variant = 3
        other_error                 = 4
        OTHERS                      = 5.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>results_empty.
    ENDIF.

* Convert the employee no to resource key
    LOOP AT e_person_asgn INTO DATA(ls_perso_asgn).
      CLEAR lv_reskey.
      CALL FUNCTION '/MRSS/SGE_EMPLOYEE_TO_RESOURCE'
        EXPORTING
          persno       = ls_perso_asgn-pernr
        IMPORTING
          lrp_resource = lv_reskey.
      APPEND VALUE #( pernr = ls_perso_asgn-pernr key = lv_reskey ) TO e_resource_sel.
    ENDLOOP.

*    Get the time allocations by resource key
    SORT e_resource_sel BY pernr.
    DELETE ADJACENT DUPLICATES FROM e_resource_sel COMPARING pernr."Remove any duplicates

  ENDMETHOD.


  METHOD DETERMINE_RESOURCE_ASGN.
*    Get the assignments by resource between the date range
    IF i_resource_sel IS NOT INITIAL.
      SELECT * FROM zpmviasgwrk
       INTO TABLE @g_res_asgn
        FOR ALL ENTRIES IN @i_resource_sel
       WHERE res_key EQ @i_resource_sel-key
         AND res_type IN @i_rng_restyp
         AND beg_tstmp GE @g_beg_tstmp
         AND end_tstmp LE @g_end_tstmp
        .
    ELSE.
      SELECT * FROM zpmviasgwrk
        INTO TABLE @g_res_asgn
       WHERE res_type IN @i_rng_restyp
         AND beg_tstmp GE @g_beg_tstmp
         AND end_tstmp LE @g_end_tstmp
        .
    ENDIF.
  ENDMETHOD.


  METHOD DETERMINE_TIME_ALLOCATIONS.

    REFRESH: g_time_alloc.
    IF i_resource_sel IS INITIAL.
* Get the time allocations without resource selections
      SELECT * FROM zpmvitimealloc INTO TABLE @g_time_alloc
       WHERE beg_tstmp GE @g_beg_tstmp
         AND end_tstmp LE @g_end_tstmp
         AND timespec_type IN @g_rng_tatyp
         AND resource_type IN @i_rng_restyp
         AND spras EQ @sy-langu
         AND confidential EQ @abap_false."Ignore confidential resources

    ELSE.
* Get the time allocations with resource selections
      SELECT * FROM zpmvitimealloc
        INTO TABLE @g_time_alloc
         FOR ALL ENTRIES IN @i_resource_sel
       WHERE resource_key EQ @i_resource_sel-key
         AND beg_tstmp GE @g_beg_tstmp
         AND end_tstmp LE @g_end_tstmp
         AND timespec_type IN @g_rng_tatyp
         AND resource_type IN @i_rng_restyp
         AND spras EQ @sy-langu
         AND confidential EQ @abap_false."Ignore confidential resources
    ENDIF.
  ENDMETHOD.


  METHOD determine_wkctr_of_person.

*    Get the work centers for the person selection
    CALL FUNCTION 'COI2_WORKCENTER_OF_PERSON'
      EXPORTING
        begda                       = g_rep_begda
        endda                       = g_rep_endda
      TABLES
        in_object                   = i_person_sel
        out_object                  = e_wkctr_asgn
      EXCEPTIONS
        no_in_objects               = 1
        invalid_object              = 2
        invalid_hr_planning_variant = 3
        other_error                 = 4
        evaluation_path_not_found   = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDMETHOD.


  METHOD filter_workcenter_selection.

    DATA: lt_work_centers TYPE TABLE OF ty_s_work_center.


* GEt the work centeres based on the selection
    SELECT DISTINCT wrk~objid, arbpl, wrk~werks, ktext, kokrs, veran, verwe, cos~endda, wrk~kapid, begzt, endzt, pause, aznor, ngrad
      FROM crhd AS wrk
      LEFT OUTER JOIN crtx AS txt  ON wrk~objty EQ txt~objty AND wrk~objid EQ txt~objid
                 AND txt~spras EQ @sy-langu
      LEFT OUTER JOIN crco  AS cos ON wrk~objty EQ cos~objty AND wrk~objid EQ cos~objid
                 AND cos~laset EQ 1 AND cos~lanum EQ '0001'
      LEFT OUTER JOIN kako AS cap ON wrk~kapid EQ cap~kapid AND cap~kapar EQ '002'"Person Capacity
     WHERE wrk~objty EQ 'A' AND arbpl IN @g_rng_arbpl AND wrk~werks IN @g_rng_werks
       AND veran IN @g_rng_respn AND verwe IN @g_rng_catg AND kokrs IN @g_rng_kokrs
       AND cos~begda LE @sy-datum AND cos~endda GE @sy-datum
      INTO TABLE @lt_work_centers
      .
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>results_empty.
    ENDIF.

* Get all the persons assigned to the work center
    SORT lt_work_centers BY objid endda.
    DELETE ADJACENT DUPLICATES FROM lt_work_centers COMPARING objid.
    g_work_centers = lt_work_centers.

*    Get time allocations for the current date range. Note that only specific time allocation have to be selected
    determine_time_allocations( EXPORTING i_rng_restyp = VALUE #( ( sign = 'I' option = 'EQ' low = '00'  ) ) ). "Only service employees
    IF g_time_alloc IS INITIAL AND g_availability EQ abap_false.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>results_empty.
    ENDIF.

*    Get all the assignemnt for the current date range.
    IF g_availability EQ abap_true.
      determine_resource_asgn( EXPORTING i_rng_restyp = VALUE #( ( sign = 'I' option = 'EQ' low = '00'  ) ) ). "Only service employees
      IF g_res_asgn IS INITIAL AND g_time_alloc IS  INITIAL."No resource data selected. Cannot link to work center
        RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
          EXPORTING
            textid = zcx_pm_mrs_repmgr=>results_empty.
      ENDIF.
    ENDIF.

* For the current resource selection, Get all the work centers
    get_resource_selection( IMPORTING e_resource_sel = DATA(lt_resource_sel) e_person_sel = DATA(lt_person_sel) ).
    determine_wkctr_of_person( EXPORTING i_person_sel = lt_person_sel
                               IMPORTING e_wkctr_asgn = DATA(lt_person_asgn) ).
    IF lt_person_asgn IS INITIAL."No resource data selected. Cannot link to work center
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>results_empty.
    ENDIF.

*    Combine the work center assignment with time allocation data and assignment data...depending on whether avaialability is requrested
    SORT g_time_alloc BY resource_key beg_tstmp.
    SORT g_res_asgn   BY res_key beg_tstmp.
    SORT lt_person_asgn BY pernr.
    LOOP AT lt_person_asgn INTO DATA(ls_person_asgn).

*      Get Work center details
      TRY .
          DATA(ls_work_center) = g_work_centers[ objid = ls_person_asgn-arbid ].
        CATCH cx_sy_itab_line_not_found.
          CONTINUE.
      ENDTRY.

* Get the resource Key for the current employee assigned to the work center
      READ TABLE lt_resource_sel INTO DATA(ls_resource) WITH KEY pernr = ls_person_asgn-pernr
      BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL OR ls_resource-key IS INITIAL.
        CONTINUE.
      ENDIF.

      IF g_availability EQ abap_true.
* Get the assignment summary by day for each employee of a work center
        DATA(lv_workdur) = COND zpmstwkctr_avail-kapah(
                                    WHEN ls_work_center-endzt GT 0 OR ls_work_center-begzt GT 0
                                      THEN COND #( WHEN ls_work_center-endzt > ls_work_center-begzt
                                                     THEN ls_work_center-endzt - ls_work_center-begzt
                                                     ELSE 86400 - ls_work_center-begzt + ls_work_center-endzt )
                                      ELSE 0 ).

        DATA(lv_capacity) = COND zpmstwkctr_avail-kapah(
                                    WHEN lv_workdur > ls_work_center-pause
                                      THEN ( lv_workdur - ls_work_center-pause ) * ls_work_center-ngrad / ( 3600 * 100 )
                                      ELSE 0 ).
        TRY .
          DATA(ls_empdet) = g_empdet[ pernr = ls_resource-pernr ].

        CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        get_availability_summary( EXPORTING i_person_asgn = ls_person_asgn i_resource_sel = ls_resource
                                  i_avail = VALUE #( arbpl = ls_work_center-arbpl werks = ls_work_center-werks ktext = ls_work_center-ktext
                                                     pernr = ls_resource-pernr stext =  |{ ls_empdet-nachn }| & | | & |{ ls_empdet-vorna }|
                                                     kapah = lv_capacity ) ).
      ELSE.

        get_time_alloc_summary( EXPORTING i_person_asgn = ls_person_asgn i_resource_sel = ls_resource
                                 i_alloc = VALUE #( arbpl = ls_work_center-arbpl werks = ls_work_center-werks ktext = ls_work_center-ktext ) ).
      ENDIF.

      CLEAR: ls_person_asgn, ls_resource, ls_work_center, lv_capacity, ls_empdet, lv_workdur.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_availability_summary.

    DATA: lt_wkctr_avail TYPE STANDARD TABLE OF zpmstwkctr_avail,
          lt_wkctr_ta    TYPE STANDARD TABLE OF zpmstwkctr_ta,
          lv_secs        TYPE                   i.

*      Using the resource key get the time allocations for the employee
    READ TABLE g_res_asgn WITH KEY res_key = i_resource_sel-key
    TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      DATA(lv_idx) = sy-tabix.
* Index search the time allocations for the current resource
      LOOP AT g_res_asgn INTO DATA(ls_res_assgn) FROM lv_idx.
        IF ls_res_assgn-res_key NE i_resource_sel-key.
          EXIT.
        ENDIF.

* Convert the time stamps based on global time zone
        CONVERT TIME STAMP ls_res_assgn-beg_tstmp TIME ZONE g_time_zone INTO DATE DATA(lv_begda) TIME DATA(lv_begtm).
        CONVERT TIME STAMP ls_res_assgn-end_tstmp TIME ZONE g_time_zone INTO DATE DATA(lv_endda) TIME DATA(lv_endtm).

        CHECK lv_begda GE i_person_asgn-begda AND lv_begda LE i_person_asgn-endda.
        IF NOT line_exists( g_wkctr_avail[ werks = i_avail-werks arbpl = i_avail-arbpl pernr = i_avail-pernr datum = lv_begda ] ).
          DATA(ls_wkctr_avail) = VALUE zpmstwkctr_avail( BASE i_avail datum = lv_begda ).
          lt_wkctr_avail = g_wkctr_avail.
          APPEND ls_wkctr_avail TO lt_wkctr_avail.
          g_wkctr_avail = lt_wkctr_avail.
        ENDIF.

        TRY .
            ASSIGN g_wkctr_avail[ werks = i_avail-werks arbpl = i_avail-arbpl pernr = i_avail-pernr datum = lv_begda ] TO FIELD-SYMBOL(<ls_wkctr_avail>).
            CHECK <ls_wkctr_avail> IS ASSIGNED.
            <ls_wkctr_avail>-asgnd = <ls_wkctr_avail>-asgnd + ( ls_res_assgn-duration / 3600 ).
            <ls_wkctr_avail>-remain = <ls_wkctr_avail>-kapah - <ls_wkctr_avail>-alloc - <ls_wkctr_avail>-asgnd.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        CLEAR: ls_wkctr_avail,ls_res_assgn.
        UNASSIGN: <ls_wkctr_avail>.
      ENDLOOP.
    ENDIF.


*      Using the resource key get the time allocations for the employee
    READ TABLE g_time_alloc WITH KEY resource_key = i_resource_sel-key
    TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      lv_idx = sy-tabix.

* Index search the time allocations for the current resource
      LOOP AT g_time_alloc INTO DATA(ls_time_alloc) FROM lv_idx.
        IF ls_time_alloc-resource_key NE i_resource_sel-key.
          EXIT.
        ENDIF.

* Convert the time stamps based on global time zone
        CONVERT TIME STAMP ls_time_alloc-beg_tstmp TIME ZONE g_time_zone INTO DATE lv_begda TIME lv_begtm.
        CONVERT TIME STAMP ls_time_alloc-end_tstmp TIME ZONE g_time_zone INTO DATE lv_endda TIME lv_endtm.

*        Check if the person is assigned to the workcenter during the time allocation
        IF lv_begda EQ lv_endda. "Time allocation does not span mulitple days
          DATA(lv_days) = 1.
        ELSE."Time allocation is spread over multiple days. Atleast 2 days
          lv_days = lv_endda - lv_begda + 1.
        ENDIF.

        DATA(lv_curr_date) = lv_begda.
        DO lv_days TIMES.
*          Check if the person is assigned to the workcenter during the time allocation
          CHECK lv_curr_date GE i_person_asgn-begda AND lv_curr_date LE i_person_asgn-endda .

* Calculate the hours allocated for each day
          CLEAR lv_secs.
          IF lv_begda EQ lv_endda."Time allocation does not span mulitple days
            lv_secs = ls_time_alloc-capacity.
          ELSE."Time allocation is spread over multiple days. Atleast 2 days. Get the duration for each day
            cl_abap_tstmp=>td_subtract( EXPORTING date1 = COND d( WHEN lv_curr_date EQ lv_endda THEN lv_curr_date ELSE lv_curr_date + 1 )
                                                  time1 = COND t( WHEN lv_curr_date EQ lv_endda THEN lv_endtm ELSE 000000 )
                                                  date2 = lv_curr_date
                                                  time2 = COND t( WHEN lv_curr_date EQ lv_begda THEN lv_begtm ELSE 000000 )
                                        IMPORTING res_secs = lv_secs ).
          ENDIF.

* Add the time allocation hours to the result list
          lv_curr_date = lv_curr_date + 1.
          CHECK lv_secs GT 0.
          IF NOT line_exists( g_wkctr_avail[ werks = i_avail-werks arbpl = i_avail-arbpl pernr = i_avail-pernr datum = lv_curr_date ] ).
            ls_wkctr_avail = VALUE zpmstwkctr_avail( BASE i_avail datum = lv_curr_date ).
            lt_wkctr_avail = g_wkctr_avail.
            APPEND ls_wkctr_avail TO lt_wkctr_avail.
            g_wkctr_avail = lt_wkctr_avail.
          ENDIF.

          TRY .
              ASSIGN g_wkctr_avail[ werks = i_avail-werks arbpl = i_avail-arbpl pernr = i_avail-pernr datum = lv_curr_date ] TO <ls_wkctr_avail>.
              CHECK <ls_wkctr_avail> IS ASSIGNED.
              <ls_wkctr_avail>-alloc = <ls_wkctr_avail>-alloc + ( lv_secs / 3600 ).
              <ls_wkctr_avail>-remain = <ls_wkctr_avail>-kapah - <ls_wkctr_avail>-alloc - <ls_wkctr_avail>-asgnd.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.

          CLEAR: ls_wkctr_avail.
          UNASSIGN: <ls_wkctr_avail>.
        ENDDO.

        CLEAR: lv_days, ls_time_alloc.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_resource_selection.

    DATA: lv_resource TYPE          sys_uid-id,
          lv_pernr    TYPE          pernr_d.

* Get all the personnel number form the MRS resource ID for all time allocations
    LOOP AT g_time_alloc INTO DATA(ls_time_alloc).
      CHECK NOT line_exists( e_resource_sel[ key = ls_time_alloc-resource_key ] ).
      CLEAR: lv_pernr, lv_resource.
      lv_resource = ls_time_alloc-resource_key.
* Convert the resource key to employee id
      CALL FUNCTION '/MRSS/SGE_RESOURCE_TO_EMPLOYEE'
        EXPORTING
          lrp_resource     = lv_resource
        IMPORTING
          persno           = lv_pernr
        EXCEPTIONS
          conversion_error = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
        CONTINUE.
      ENDIF.
      APPEND VALUE #( key = ls_time_alloc-resource_key pernr = lv_pernr ) TO e_resource_sel.
      APPEND VALUE #( objty = 'P' objid = lv_pernr ) TO e_person_sel.
    ENDLOOP.

* Get all the personnel number form the MRS resource ID
    LOOP AT g_res_asgn INTO DATA(ls_res_asgn).
      CHECK NOT line_exists( e_resource_sel[ key = ls_res_asgn-res_key ] ).
      CLEAR: lv_pernr, lv_resource.
      lv_resource = ls_res_asgn-res_key.
* Convert the resource key to employee id
      CALL FUNCTION '/MRSS/SGE_RESOURCE_TO_EMPLOYEE'
        EXPORTING
          lrp_resource     = lv_resource
        IMPORTING
          persno           = lv_pernr
        EXCEPTIONS
          conversion_error = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
        CONTINUE.
      ENDIF.
      APPEND VALUE #( key = ls_res_asgn-res_key pernr = lv_pernr ) TO e_resource_sel.
      APPEND VALUE #( objty = 'P' objid = lv_pernr ) TO e_person_sel.
    ENDLOOP.

*    Get the time allocations by resource key
    SORT e_resource_sel BY pernr.
    DELETE ADJACENT DUPLICATES FROM e_resource_sel COMPARING pernr."Remove any duplicates

    SORT e_person_sel BY objid.
    DELETE ADJACENT DUPLICATES FROM e_person_sel COMPARING objid."Remove any duplicates

    IF e_resource_sel IS NOT INITIAL AND g_availability EQ abap_true.
*     Get the employee details like first name and last name
      SELECT pernr, begda, nachn, vorna
        FROM pa0002

         FOR ALL ENTRIES IN @e_resource_sel
       WHERE pernr EQ @e_resource_sel-pernr
         AND begda le @sy-datum AND endda ge @sy-datum

        INTO TABLE @DATA(lt_empdet)
        .
      IF sy-subrc IS INITIAL.
        SORT lt_empdet by pernr begda DESCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_empdet.
        g_empdet[] = lt_empdet[].
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_time_alloc_summary.

    DATA: lv_secs     TYPE          i,
          lt_wkctr_ta TYPE STANDARD TABLE OF zpmstwkctr_ta.

*      Using the resource key get the time allocations for the employee
    READ TABLE g_time_alloc WITH KEY resource_key = i_resource_sel-key
    TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      DATA(lv_idx) = sy-tabix.
    ELSE.
      RETURN.
    ENDIF.

* Index search the time allocations for the current resource
    LOOP AT g_time_alloc INTO DATA(ls_time_alloc) FROM lv_idx.
      IF ls_time_alloc-resource_key NE i_resource_sel-key.
        EXIT.
      ENDIF.

* Convert the time stamps based on global time zone
      CONVERT TIME STAMP ls_time_alloc-beg_tstmp TIME ZONE g_time_zone INTO DATE DATA(lv_begda) TIME DATA(lv_begtm).
      CONVERT TIME STAMP ls_time_alloc-end_tstmp TIME ZONE g_time_zone INTO DATE DATA(lv_endda) TIME DATA(lv_endtm).

*        Check if the person is assigned to the workcenter during the time allocation
      IF lv_begda EQ lv_endda. "Time allocation does not span mulitple days
        DATA(lv_days) = 1.
      ELSE."Time allocation is spread over multiple days. Atleast 2 days
        lv_days = lv_endda - lv_begda + 1.
      ENDIF.

      DATA(lv_curr_date) = lv_begda.
      DO lv_days TIMES.
*          Check if the person is assigned to the workcenter during the time allocation
        CHECK lv_curr_date GE i_person_asgn-begda AND lv_curr_date LE i_person_asgn-endda .

* Calculate the hours allocated for each day
        CLEAR lv_secs.
        IF lv_begda EQ lv_endda."Time allocation does not span mulitple days
          lv_secs = ls_time_alloc-capacity.
        ELSE."Time allocation is spread over multiple days. Atleast 2 days. Get the duration for each day
          cl_abap_tstmp=>td_subtract( EXPORTING date1 = COND d( WHEN lv_curr_date EQ lv_endda THEN lv_curr_date ELSE lv_curr_date + 1 )
                                                time1 = COND t( WHEN lv_curr_date EQ lv_endda THEN lv_endtm ELSE 000000 )
                                                date2 = lv_curr_date
                                                time2 = COND t( WHEN lv_curr_date EQ lv_begda THEN lv_begtm ELSE 000000 )
                                      IMPORTING res_secs = lv_secs ).
        ENDIF.

* Add the time allocation hours to the result list
        lv_curr_date = lv_curr_date + 1.
        CHECK lv_secs GT 0.
        IF NOT line_exists( g_wkctr_ta[ werks = i_alloc-werks arbpl = i_alloc-arbpl timespec_type = ls_time_alloc-timespec_type ] ).
          DATA(ls_wkctr_ta) = VALUE zpmstwkctr_ta( BASE i_alloc timespec_type = ls_time_alloc-timespec_type ta_type_text = ls_time_alloc-text ).
          lt_wkctr_ta = g_wkctr_ta.
          APPEND ls_wkctr_ta TO lt_wkctr_ta.
          g_wkctr_ta = lt_wkctr_ta.
        ENDIF.

*        "Add in hours
        TRY .
            ASSIGN COMPONENT g_monfld[ monyr = lv_curr_date(6) ]-field
            OF STRUCTURE g_wkctr_ta[ werks = i_alloc-werks arbpl = i_alloc-arbpl timespec_type = ls_time_alloc-timespec_type ]
            TO FIELD-SYMBOL(<lv_mon_dur>).
            CHECK <lv_mon_dur> IS ASSIGNED.
            <lv_mon_dur> = <lv_mon_dur> + ( lv_secs / 3600 ).
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.
        CLEAR: ls_wkctr_ta.
        UNASSIGN: <lv_mon_dur>.
      ENDDO.

      CLEAR: lv_days, ls_time_alloc.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
