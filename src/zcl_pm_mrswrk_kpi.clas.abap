class ZCL_PM_MRSWRK_KPI definition
  public
  final
  create public .

public section.

  types:
    ty_rng_steus TYPE RANGE OF afvc-steus .
  types:
    ty_t_ilakpi  TYPE STANDARD TABLE OF zpmstoilakpi .
  types:
    ty_t_wctrkpi TYPE STANDARD TABLE OF zpmstowctrkpi .
  types:
    ty_t_operkpi TYPE TABLE OF zpmstoperkpi .
  types TY_CUML_DUR type DEC_31 .
  types:
    ty_rng_aufnr TYPE RANGE OF aufnr .
  types:
    ty_rng_txt04 TYPE RANGE OF j_txt04 .
  types:
    BEGIN OF ty_s_operact,
        aufnr   TYPE aufnr,
        vornr   TYPE afvc-vornr,
        act_dur TYPE ty_cuml_dur,
      END OF ty_s_operact .
  types:
    ty_t_operact TYPE HASHED TABLE OF ty_s_operact WITH UNIQUE KEY aufnr vornr .

  data G_RNG_AUART type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_AUART read-only .
  data G_RNG_PRIOK type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_PRIOK read-only .
  data G_RNG_ILART type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_ILART read-only .
  data G_RNG_ARBPL type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_ARBPL read-only .
  data G_IWERK type IWERK read-only .
  data G_RNG_PERIO type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_PERIO read-only .
  data G_RNG_AUFNR type TY_RNG_AUFNR read-only .
  data G_RNG_USTAT type TY_RNG_TXT04 read-only .
  data G_RNG_STEUS type TY_RNG_STEUS read-only .
  data G_OPERWRK_KPI type TY_T_OPERKPI read-only .
  data G_OPERACT_SUM type TY_T_OPERACT read-only .
  data G_ILAWRK_KPI type TY_T_ILAKPI read-only .
  data G_WKCTR_KPI type TY_T_WCTRKPI read-only .

  methods CONSTRUCTOR
    importing
      value(I_RNG_AUART) type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_AUART
      value(I_RNG_PRIOK) type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_PRIOK
      value(I_RNG_ILART) type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_ILART
      value(I_RNG_ARBPL) type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_ARBPL
      value(I_IWERK) type IWERK
      value(I_RNG_PERIO) type ZCL_PM_MRSWRK_COMPLIANCE=>TY_RNG_PERIO
      value(I_RNG_AUFNR) type TY_RNG_AUFNR
      value(I_RNG_USTAT) type TY_RNG_TXT04
      value(I_RNG_STEUS) type TY_RNG_STEUS
    raising
      ZCX_PM_MRS_REPMGR .
  methods GET_OPER_KPI
    raising
      ZCX_PM_MRS_REPMGR .
  class-methods CONVERT_DUR_TOHRS
    importing
      !I_DUR_UNIT type T006-MSEHI
      !I_DURATION type TY_CUML_DUR
    exporting
      value(E_DUR_HRS) type TY_CUML_DUR .
protected section.
private section.

  methods BUILD_SUMMARY_KPI .
ENDCLASS.



CLASS ZCL_PM_MRSWRK_KPI IMPLEMENTATION.


  METHOD build_summary_kpi.

* Summary at Maint Activity Level
    LOOP AT g_operwrk_kpi INTO DATA(ls_oper_kpi)
    GROUP BY ( ilart = ls_oper_kpi-ilart ilatx = ls_oper_kpi-ilatx ) INTO DATA(ls_ila_grp).

      DATA(ls_ilawrk_kpi) = VALUE zpmstoilakpi( ilart = ls_ila_grp-ilart ilatx = ls_ila_grp-ilatx ).
      LOOP AT GROUP ls_ila_grp INTO DATA(ls_ila_mem).
        ls_ilawrk_kpi-bnchmrk = ls_ilawrk_kpi-bnchmrk + ls_ila_mem-bnchmrk.
        ls_ilawrk_kpi-scope   = ls_ilawrk_kpi-scope   + ls_ila_mem-scope.
        ls_ilawrk_kpi-asgnd   = ls_ilawrk_kpi-asgnd   + ls_ila_mem-asgnd.
        ls_ilawrk_kpi-actual   = ls_ilawrk_kpi-actual + ls_ila_mem-actual.
      ENDLOOP.
* Calculate the KPI in percentage
      ls_ilawrk_kpi-scp_bnch = COND #( WHEN ls_ilawrk_kpi-bnchmrk IS INITIAL THEN 0 ELSE ls_ilawrk_kpi-scope  * 100 / ls_ilawrk_kpi-bnchmrk ).
      ls_ilawrk_kpi-asg_bnch = COND #( WHEN ls_ilawrk_kpi-bnchmrk IS INITIAL THEN 0 ELSE ls_ilawrk_kpi-asgnd  * 100 / ls_ilawrk_kpi-bnchmrk ).
      ls_ilawrk_kpi-act_bnch = COND #( WHEN ls_ilawrk_kpi-bnchmrk IS INITIAL THEN 0 ELSE ls_ilawrk_kpi-actual * 100 / ls_ilawrk_kpi-bnchmrk ).
      ls_ilawrk_kpi-asg_scp  = COND #( WHEN ls_ilawrk_kpi-scope   IS INITIAL THEN 0 ELSE ls_ilawrk_kpi-asgnd  * 100 / ls_ilawrk_kpi-scope ).
      ls_ilawrk_kpi-act_scp  = COND #( WHEN ls_ilawrk_kpi-scope   IS INITIAL THEN 0 ELSE ls_ilawrk_kpi-actual * 100 / ls_ilawrk_kpi-scope ).
      ls_ilawrk_kpi-act_asg  = COND #( WHEN ls_ilawrk_kpi-asgnd   IS INITIAL THEN 0 ELSE ls_ilawrk_kpi-actual * 100 / ls_ilawrk_kpi-asgnd ).
      APPEND ls_ilawrk_kpi TO g_ilawrk_kpi.
    ENDLOOP.


* Summary at Workcenter Level
    LOOP AT g_operwrk_kpi INTO ls_oper_kpi
    GROUP BY ( workcenter = ls_oper_kpi-workcenter workcentertext = ls_oper_kpi-workcentertext ) INTO DATA(ls_wkctr_grp).

      DATA(ls_wkctr_kpi) = VALUE zpmstowctrkpi( workcenter = ls_wkctr_grp-workcenter workcentertext = ls_wkctr_grp-workcentertext ).
      LOOP AT GROUP ls_wkctr_grp INTO DATA(ls_wkctr_mem).
        ls_wkctr_kpi-bnchmrk = ls_wkctr_kpi-bnchmrk + ls_wkctr_mem-bnchmrk.
        ls_wkctr_kpi-scope   = ls_wkctr_kpi-scope   + ls_wkctr_mem-scope.
        ls_wkctr_kpi-asgnd   = ls_wkctr_kpi-asgnd   + ls_wkctr_mem-asgnd.
        ls_wkctr_kpi-actual  = ls_wkctr_kpi-actual  + ls_wkctr_mem-actual.
      ENDLOOP.
* Calculate the KPI in percentage
      ls_wkctr_kpi-scp_bnch = COND #( WHEN ls_wkctr_kpi-bnchmrk IS INITIAL THEN 0 ELSE ls_wkctr_kpi-scope  * 100 / ls_wkctr_kpi-bnchmrk  ).
      ls_wkctr_kpi-asg_bnch = COND #( WHEN ls_wkctr_kpi-bnchmrk IS INITIAL THEN 0 ELSE ls_wkctr_kpi-asgnd  * 100 / ls_wkctr_kpi-bnchmrk  ).
      ls_wkctr_kpi-act_bnch = COND #( WHEN ls_wkctr_kpi-bnchmrk IS INITIAL THEN 0 ELSE ls_wkctr_kpi-actual * 100 / ls_wkctr_kpi-bnchmrk  ).
      ls_wkctr_kpi-asg_scp  = COND #( WHEN ls_wkctr_kpi-scope   IS INITIAL THEN 0 ELSE ls_wkctr_kpi-asgnd  * 100 / ls_wkctr_kpi-scope ).
      ls_wkctr_kpi-act_scp  = COND #( WHEN ls_wkctr_kpi-scope   IS INITIAL THEN 0 ELSE ls_wkctr_kpi-actual * 100 / ls_wkctr_kpi-scope  ).
      ls_wkctr_kpi-act_asg  = COND #( WHEN ls_wkctr_kpi-asgnd   IS INITIAL THEN 0 ELSE ls_wkctr_kpi-actual * 100 / ls_wkctr_kpi-asgnd  ).
      APPEND ls_wkctr_kpi TO g_wkctr_kpi.
    ENDLOOP.
  ENDMETHOD.


  METHOD CONSTRUCTOR.
    IF i_iwerk IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>main_plant_blank.
    ENDIF.

    IF i_rng_perio[] IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>repweek_start_date_blank.
    ENDIF.

* Save the selection parameters
    g_rng_auart = i_rng_auart.
    g_rng_priok = i_rng_priok.
    g_rng_ilart = i_rng_ilart.
    g_rng_arbpl = i_rng_arbpl.
    g_iwerk     = i_iwerk.
    g_rng_perio = i_rng_perio.
    g_rng_aufnr = i_rng_aufnr.
    g_rng_ustat = i_rng_ustat.
    g_rng_steus = i_rng_steus.
  ENDMETHOD.


  METHOD CONVERT_DUR_TOHRS.

    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input                = i_duration
        unit_in              = i_dur_unit
        unit_out             = 'H'
      IMPORTING
*       ADD_CONST            =
*       DECIMALS             =
*       DENOMINATOR          =
*       NUMERATOR            =
        output               = e_dur_hrs
      EXCEPTIONS
        conversion_not_found = 1
        division_by_zero     = 2
        input_invalid        = 3
        output_invalid       = 4
        overflow             = 5
        type_invalid         = 6
        units_missing        = 7
        unit_in_not_found    = 8
        unit_out_not_found   = 9
        OTHERS               = 10.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDMETHOD.


  METHOD get_oper_kpi.

    DATA: lv_act_sum   TYPE zpmde_actual,
          lt_ord_ustat TYPE HASHED TABLE OF aufnr WITH UNIQUE KEY table_line.


* Get the assigned hours *    Get the bench mark scoped hours
    SELECT orm~aufnr, opr~vornr, ktext, or2~ilart, ilatx, usr04 AS bch_dur, use04 AS bch_unit,
           arbei AS scp_dur, arbeh AS scp_unit, orm~objnr, wrk~workcenter, wrk~workcentertext,
           SUM( asg~duration ) AS asg_dur

      FROM      aufk            AS orm
     INNER JOIN afih            AS or2 ON orm~aufnr EQ or2~aufnr
     INNER JOIN afko            AS orh ON orm~aufnr EQ orh~aufnr
     INNER JOIN afvc            AS opr ON orh~aufpl EQ opr~aufpl
     INNER JOIN afvv            AS opv ON opr~aufpl EQ opv~aufpl AND opr~aplzl EQ opv~aplzl
     INNER JOIN afvu            AS opu ON opr~aufpl EQ opu~aufpl AND opr~aplzl EQ opu~aplzl
     INNER JOIN i_workcentertextbysemantickey AS wrk ON opr~arbid EQ wrk~workcenterinternalid
            AND wrk~language EQ @sy-langu
     INNER JOIN t353i_t         AS ilt ON or2~ilart EQ ilt~ilart AND spras EQ @sy-langu
      LEFT OUTER JOIN zpmviasgwrk AS asg ON orm~aufnr EQ asg~demhdr_id AND opr~vornr EQ asg~demitm_id"MRS Assignment

     WHERE autyp      EQ @zcl_pm_mrswrk_compliance=>g_maint_ordcat "Maintainance Orders only
       AND orm~aufnr  IN @g_rng_aufnr
       AND iwerk      EQ @g_iwerk
       AND auart      IN @g_rng_auart
       AND or2~ilart  IN @g_rng_ilart
       AND priok      IN @g_rng_priok
       AND gstrs      IN @g_rng_perio
       AND workcenter IN @g_rng_arbpl
       AND steus      IN @g_rng_steus
      GROUP BY orm~aufnr, vornr, ktext, or2~ilart, ilatx, usr04, use04, arbei, arbeh, orm~objnr, wrk~workcenter, wrk~workcentertext
      INTO TABLE @DATA(lt_oper_asgini)
        .
    IF sy-subrc IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>results_empty.
    ENDIF.

* Filter on order User status
    IF g_rng_ustat[] IS NOT INITIAL.
      SELECT DISTINCT aufnr FROM zpmviordustat
        INTO TABLE lt_ord_ustat
         FOR ALL ENTRIES IN lt_oper_asgini
       WHERE aufnr EQ lt_oper_asgini-aufnr
         AND spras EQ sy-langu
         AND txt04 IN g_rng_ustat.
      IF sy-subrc IS NOT INITIAL.
        RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
          EXPORTING
            textid = zcx_pm_mrs_repmgr=>results_empty.
      ENDIF.

* Filter the order slected on user status
      DATA(lt_oper_asgdur) = FILTER #( lt_oper_asgini IN lt_ord_ustat WHERE aufnr = table_line ).
    ELSE.
      lt_oper_asgdur = lt_oper_asgini[].
    ENDIF.

* Get the actual hours from confirmations excluding reversed confirmations
    SELECT cnf~aufnr, cnf~vornr, cnf~isdd, cnf~iedd, cnf~ismnw, cnf~ismne, cnl~stzhl
      FROM afru AS cnf
      LEFT OUTER JOIN afru AS cnl ON cnf~rueck EQ cnl~rueck AND cnf~rmzhl EQ cnl~stzhl"Cancelled confirmations
       FOR ALL ENTRIES IN @lt_oper_asgdur
     WHERE cnf~aufnr EQ @lt_oper_asgdur-aufnr AND cnf~vornr EQ @lt_oper_asgdur-vornr
       AND cnf~stzhl EQ '00000000'
      INTO TABLE @DATA(lt_oper_cnfdur).
    IF sy-subrc IS INITIAL.
      DELETE lt_oper_cnfdur WHERE stzhl IS NOT INITIAL."Cancelled hours are to be ignored
    ENDIF.

* sum-up the actual hours by operation after converting the confirmation duration to hours
    LOOP AT lt_oper_cnfdur INTO DATA(ls_cnfdur)
      GROUP BY ( aufnr = ls_cnfdur-aufnr vornr = ls_cnfdur-vornr )
      INTO DATA(ls_cnfdur_grp).

      LOOP AT GROUP ls_cnfdur_grp INTO DATA(ls_act).
        IF ls_act-ismne NE 'H' AND ls_act-ismne NE 'STD' AND ls_act-ismne IS NOT INITIAL
            AND ls_act-ismnw IS NOT INITIAL.
          convert_dur_tohrs( EXPORTING i_dur_unit = ls_act-ismne i_duration = CONV #( ls_act-ismnw )
                             IMPORTING e_dur_hrs = DATA(lv_act_hrs) ).
        ELSE.
          lv_act_hrs = ls_act-ismnw.
        ENDIF.

        lv_act_sum = lv_act_hrs + lv_act_sum.
        CLEAR: lv_act_hrs.
      ENDLOOP.
      g_operact_sum = VALUE #( BASE g_operact_sum
                              ( aufnr = ls_cnfdur_grp-aufnr vornr = ls_cnfdur_grp-vornr
                                act_dur = lv_act_sum ) ).
      CLEAR lv_act_sum.
    ENDLOOP.

    LOOP AT lt_oper_asgdur INTO DATA(ls_asgdur).
      APPEND INITIAL LINE TO g_operwrk_kpi ASSIGNING FIELD-SYMBOL(<ls_operwrk_kpi>).
      <ls_operwrk_kpi>-ilart = ls_asgdur-ilart.
      <ls_operwrk_kpi>-ilatx = ls_asgdur-ilatx.
      <ls_operwrk_kpi>-workcenter = ls_asgdur-workcenter.
      <ls_operwrk_kpi>-workcentertext = ls_asgdur-workcentertext.
      <ls_operwrk_kpi>-aufnr = ls_asgdur-aufnr.
      <ls_operwrk_kpi>-ktext = ls_asgdur-ktext.
      <ls_operwrk_kpi>-vornr = ls_asgdur-vornr.

* Convert to Benchmark hours
      IF ls_asgdur-bch_unit NE 'H' AND ls_asgdur-bch_unit NE 'STD'  AND ls_asgdur-bch_unit IS NOT INITIAL
        AND ls_asgdur-bch_dur IS NOT INITIAL.
        convert_dur_tohrs( EXPORTING i_dur_unit = ls_asgdur-bch_unit i_duration = CONV #( ls_asgdur-bch_dur )
                           IMPORTING e_dur_hrs = <ls_operwrk_kpi>-bnchmrk ).
      ELSE.
        <ls_operwrk_kpi>-bnchmrk = ls_asgdur-bch_dur.
      ENDIF.

* Convert to Scope hours
      IF ls_asgdur-scp_unit NE 'H' AND ls_asgdur-scp_unit NE 'STD' AND ls_asgdur-scp_unit IS NOT INITIAL
        AND ls_asgdur-scp_dur IS NOT INITIAL.
        convert_dur_tohrs( EXPORTING i_dur_unit = ls_asgdur-scp_unit i_duration = CONV #( ls_asgdur-scp_dur )
                           IMPORTING e_dur_hrs = <ls_operwrk_kpi>-scope ).
      ELSE.
        <ls_operwrk_kpi>-scope = ls_asgdur-scp_dur.
      ENDIF.

* * Convert to Assigned hours
      <ls_operwrk_kpi>-asgnd = ls_asgdur-asg_dur / 3600.

*   Convert to actual hours
      TRY .
          <ls_operwrk_kpi>-actual = g_operact_sum[ KEY primary_key  aufnr = <ls_operwrk_kpi>-aufnr vornr = <ls_operwrk_kpi>-vornr ]-act_dur.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

* Calculate the KPI in percentage
      <ls_operwrk_kpi>-scp_bnch = COND #( WHEN <ls_operwrk_kpi>-bnchmrk IS INITIAL THEN 0 ELSE <ls_operwrk_kpi>-scope  * 100 / <ls_operwrk_kpi>-bnchmrk ).
      <ls_operwrk_kpi>-asg_bnch = COND #( WHEN <ls_operwrk_kpi>-bnchmrk IS INITIAL THEN 0 ELSE <ls_operwrk_kpi>-asgnd  * 100 / <ls_operwrk_kpi>-bnchmrk ).
      <ls_operwrk_kpi>-act_bnch = COND #( WHEN <ls_operwrk_kpi>-bnchmrk IS INITIAL THEN 0 ELSE <ls_operwrk_kpi>-actual * 100 / <ls_operwrk_kpi>-bnchmrk ).
      <ls_operwrk_kpi>-asg_scp  = COND #( WHEN <ls_operwrk_kpi>-scope   IS INITIAL THEN 0 ELSE <ls_operwrk_kpi>-asgnd  * 100 / <ls_operwrk_kpi>-scope ).
      <ls_operwrk_kpi>-act_scp  = COND #( WHEN <ls_operwrk_kpi>-scope   IS INITIAL THEN 0 ELSE <ls_operwrk_kpi>-actual * 100 / <ls_operwrk_kpi>-scope ).
      <ls_operwrk_kpi>-act_asg  = COND #( WHEN <ls_operwrk_kpi>-asgnd   IS INITIAL THEN 0 ELSE <ls_operwrk_kpi>-actual * 100 / <ls_operwrk_kpi>-asgnd ).


    ENDLOOP.

    build_summary_kpi( ).
  ENDMETHOD.
ENDCLASS.
