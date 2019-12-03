class ZCL_PM_MRSWRK_COMPLIANCE definition
  public
  final
  create public .

public section.

  types:
    ty_t_crhs TYPE TABLE OF crhs .
  types:
    ty_rng_objid TYPE RANGE OF crhd-objid .
  types:
    ty_rng_auart TYPE RANGE OF auart .
  types:
    ty_rng_priok TYPE RANGE OF afih-priok .
  types:
    ty_rng_ilart TYPE RANGE OF afih-ilart .
  types:
    ty_rng_arbpl TYPE RANGE OF crhd-arbpl .
  types:
    ty_t_wrkcomp TYPE TABLE OF zpmstwrkcompl .
  types:
    ty_rng_perio TYPE RANGE OF sy-datum .

  data G_RNG_AUART type TY_RNG_AUART read-only .
  data G_RNG_PRIOK type TY_RNG_PRIOK read-only .
  data G_RNG_ILART type TY_RNG_ILART read-only .
  data G_RNG_ARBPL type TY_RNG_ARBPL read-only .
  data G_IWERK type IWERK read-only .
  data G_SNAPTYPE type ZPMDE_SNAP_TYPE read-only .
  data G_HIERPLNT type CRHH-WERKS read-only .
  data G_WRKHIER type CRHH-NAME read-only .
  data G_WRKNODE type CRHD-ARBPL read-only .
  data G_REP_BEGDA type BEGDA read-only .
  data G_REP_ENDDA type ENDDA read-only .
  data G_WRKCTR_HIER type TY_T_CRHS read-only .
  data G_WRKCTR_DET type RFC_WKC_DETAIL_TAB read-only .
  data G_WRKCMPL type TY_T_WRKCOMP read-only .
  constants G_MAINT_ORDCAT type AUFK-AUTYP value '30' ##NO_TEXT.
  constants G_INIT_DATE type SY-DATUM value '00000000' ##NO_TEXT.
  constants G_COMSTAT_COMPLIANT type TEXT40 value 'COMPLIANT' ##NO_TEXT.
  constants G_COMSTAT_NONCOMPL type TEXT40 value 'NOT COMPLIANT' ##NO_TEXT.
  constants G_COMSTAT_BREAKIN type TEXT40 value 'BREAKIN' ##NO_TEXT.
  constants G_OBJTY_WRKCTR type CRHD-OBJTY value 'A' ##NO_TEXT.
  constants G_OBJTY_HIER type CRHH-OBJTY value 'H' ##NO_TEXT.
  constants G_SIGN_INCL type CHAR1 value 'I' ##NO_TEXT.
  constants G_OPT_EQ type CHAR2 value 'EQ' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      value(I_RNG_AUART) type TY_RNG_AUART
      value(I_RNG_PRIOK) type TY_RNG_PRIOK
      value(I_RNG_ILART) type TY_RNG_ILART
      value(I_RNG_ARBPL) type TY_RNG_ARBPL
      value(I_IWERK) type IWERK
      value(I_RNG_PERIO) type TY_RNG_PERIO
      value(I_SNAPTYPE) type ZPMDE_SNAP_TYPE
      value(I_WRKHIER) type CRHH-NAME
      value(I_HIERPLNT) type CRHH-WERKS
      value(I_WRKNODE) type CRHD-ARBPL
    raising
      ZCX_PM_MRS_REPMGR .
  methods GET_WORK_COMPL_INFO
    raising
      ZCX_PM_MRS_REPMGR .
  class-methods VALIDATE_WORKCTR_HIER
    importing
      value(I_WRKHIER) type CRHH-NAME
      value(I_WRKNODE) type CRHD-ARBPL
      value(I_IWERK) type IWERK
    exporting
      value(E_WORKCTR_ID) type CRHD-OBJID
      value(E_WORKHIER_ID) type CRHH-OBJID
    raising
      ZCX_PM_MRS_REPMGR .
protected section.
private section.

  methods GET_WORKCTR_SELECTION
    raising
      zcx_pm_mrs_repmgr .
  methods FILL_OPER_STAT_BUFFER
    importing
      value(I_OPER_OBJNR) type TT_OBJNR .
ENDCLASS.



CLASS ZCL_PM_MRSWRK_COMPLIANCE IMPLEMENTATION.


  METHOD constructor.

    IF i_iwerk IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>main_plant_blank.
    ENDIF.

    IF i_snaptype IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>snapshot_type_blank.
    ENDIF.

    IF i_rng_perio[] IS INITIAL.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>repweek_start_date_blank.
    ELSE.
      IF i_rng_perio[ 1 ]-low IS INITIAL.
        RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
          EXPORTING
            textid = ZCX_PM_MRS_REPMGR=>repweek_start_date_blank.
      ELSE.
        g_rep_begda = i_rng_perio[ 1 ]-low.
      ENDIF.
      IF i_rng_perio[ 1 ]-high IS INITIAL.
        RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
          EXPORTING
            textid = ZCX_PM_MRS_REPMGR=>repweek_end_date_blank.
      ELSE.
        g_rep_endda = i_rng_perio[ 1 ]-high.
      ENDIF.
    ENDIF.

*      check if the date is start date of the week
    zcl_pm_mrs_snapshot=>get_first_last_dayofweek( EXPORTING i_date = g_rep_begda IMPORTING e_week_begda = DATA(lv_date_tmp) ).
    IF g_rep_begda NE lv_date_tmp.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid  = ZCX_PM_MRS_REPMGR=>invalid_start_date
          g_begda = |{ g_rep_begda DATE = USER }|.
    ENDIF.

*      check if the date is end date of the week
    CLEAR lv_date_tmp.
    zcl_pm_mrs_snapshot=>get_first_last_dayofweek( EXPORTING i_date = g_rep_endda IMPORTING e_week_endda = lv_date_tmp ).
    IF g_rep_endda NE lv_date_tmp.
      RAISE EXCEPTION TYPE ZCX_PM_MRS_REPMGR
        EXPORTING
          textid  = ZCX_PM_MRS_REPMGR=>invalid_end_date
          g_endda = |{ g_rep_endda DATE = USER }|.
    ENDIF.

    g_rng_auart = i_rng_auart.
    g_rng_priok = i_rng_priok.
    g_rng_ilart = i_rng_ilart.
    g_rng_arbpl = i_rng_arbpl.
    g_iwerk     = i_iwerk.
*g_rng_perio = i_rng_perio.
    g_snaptype  = i_snaptype.
    g_wrkhier   = i_wrkhier.
    g_wrknode   = i_wrknode.
    g_hierplnt  = i_hierplnt.

  ENDMETHOD.


  METHOD fill_oper_stat_buffer.



  ENDMETHOD.


  METHOD get_workctr_selection.
    DATA: lt_ret        TYPE  bapiret2_t.

* Validate Work Center Hierarchy and node
    CALL METHOD zcl_pm_mrswrk_compliance=>validate_workctr_hier
      EXPORTING
        i_wrkhier     = g_wrkhier
        i_wrknode     = g_wrknode
        i_iwerk       = g_hierplnt
      IMPORTING
        e_workctr_id  = DATA(lv_workcenter_id)
        e_workhier_id = DATA(lv_hierarchy_id).

*   Get all the work centers for the node or hierrchy
    CALL FUNCTION 'CR_RFC_GET_HIER_NEXT_LEVEL'
      EXPORTING
        iv_plant             = g_hierplnt
        iv_hierarchy_id      = lv_hierarchy_id
        iv_workcenter_id     = lv_workcenter_id
*       IV_WORKCENTER_TYPE   = 'A'
        iv_level             = '99'
        iv_lang              = sy-langu
      TABLES
        et_hierarchy_tab     = g_wrkctr_hier
        et_workcenter_detail = g_wrkctr_det
        et_return            = lt_ret.
    .
    IF g_wrkctr_det[] IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = ZCX_PM_MRS_REPMGR=>invalid_wrkctr_node
          g_hier = g_wrkhier
          g_node = g_wrknode.
    ENDIF.

    g_rng_arbpl = VALUE #( BASE g_rng_arbpl
                           FOR ls_wrkctr_det IN  g_wrkctr_det WHERE ( plant = g_hierplnt )
                           ( sign = g_sign_incl option = g_opt_eq low = ls_wrkctr_det-workcenter_name ) ).
  ENDMETHOD.


  METHOD get_work_compl_info.

* Get work center selection
    REFRESH: g_wrkcmpl, g_wrkctr_det, g_wrkctr_hier.
    IF g_wrkhier IS NOT INITIAL.
      get_workctr_selection( ).
    ENDIF.

* Get all the OPER confirmations within the reporting week period and get any snapshot entries for the reporting week for the corresponding operation
    SELECT a~aufnr, a~aufpl, a~aplzl, a~vornr, a~iedd AS actual_conf, d~objnr, d~arbid, d~werks, b~ktext, d~ltxa1,
           w~workcenter,  w~workcentertext, x~stzhl,
           e~ssedd, f~begda AS snp_begda, f~endda AS snp_endda, f~ssedd AS snp_ssedd

      FROM afru AS a
      LEFT OUTER JOIN afru AS x ON a~rueck EQ x~rueck AND a~rmzhl EQ x~stzhl"Cancelled confirmations
     INNER JOIN aufk AS b ON a~aufnr EQ b~aufnr
     INNER JOIN afih AS c ON a~aufnr EQ c~aufnr
     INNER JOIN afvc AS d ON a~aufpl EQ d~aufpl AND a~aplzl EQ d~aplzl
     INNER JOIN afvv AS e ON a~aufpl EQ e~aufpl AND a~aplzl EQ e~aplzl
     INNER JOIN i_workcentertextbysemantickey AS w ON d~arbid EQ w~workcenterinternalid
            AND w~language EQ @sy-langu
      LEFT OUTER JOIN zpmvisnpwrk AS f ON ( f~begda GE @g_rep_begda AND f~endda LE @g_rep_endda )
           AND f~aufpl EQ a~aufpl AND f~aplzl EQ a~aplzl AND f~snaptype EQ @g_snaptype

     WHERE ( a~iedd  GE @g_rep_begda AND a~iedd  LE @g_rep_endda )
       AND ( e~ssedd GE @g_rep_begda AND e~ssedd LE @g_rep_endda )
       AND autyp  EQ @g_maint_ordcat "Maintainance Orders only
       AND iwerk  EQ @g_iwerk
       AND auart  IN @g_rng_auart
       AND ilart  IN @g_rng_ilart
       AND priok  IN @g_rng_priok
       AND workcenter  IN @g_rng_arbpl
       AND a~stzhl EQ '00000000'
*
*     GROUP BY a~aufnr, a~aufpl, a~aplzl, a~vornr, d~objnr, d~arbid, d~werks,
*     w~workcenter, w~workcentertext, e~ssedd, f~begda, f~endda, f~ssedd

     INTO TABLE @DATA(lt_opercnf)

      .
    IF lt_opercnf[] IS INITIAL. "No confirmations in the reporting week. This is possible.
    ELSE.
      DELETE lt_opercnf WHERE stzhl IS NOT INITIAL.
    ENDIF.

* Check if there are any operations in the snapshot. This will  get the orders that were schd in the
* reporting week range selection and that could have been confirmed.
    SELECT a~aufnr, a~aufpl, a~aplzl, d~vornr, @g_init_date AS actual_conf, d~objnr, d~arbid, d~werks, b~ktext, d~ltxa1,
           w~workcenter,  w~workcentertext, CAST( '00000000' AS NUMC( 8 ) ) AS stzhl,
           a~ssedd, a~begda AS snp_begda, a~endda AS snp_endda, a~ssedd AS snp_ssedd

      FROM zpmvisnpwrk AS a
     INNER JOIN aufk AS b ON a~aufnr EQ b~aufnr
     INNER JOIN afih AS c ON a~aufnr EQ c~aufnr
     INNER JOIN afvc AS d ON a~aufpl EQ d~aufpl AND a~aplzl EQ d~aplzl
     INNER JOIN i_workcentertextbysemantickey AS w ON d~arbid EQ w~workcenterinternalid
            AND w~language EQ @sy-langu

     WHERE a~begda  GE @g_rep_begda
       AND a~endda  LE @g_rep_endda
       AND snaptype EQ @g_snaptype
       AND autyp    EQ @g_maint_ordcat "Maintainance Orders only
       AND iwerk    EQ @g_iwerk
       AND auart    IN @g_rng_auart
       AND ilart    IN @g_rng_ilart
       AND priok    IN @g_rng_priok
       AND workcenter  IN @g_rng_arbpl

       APPENDING TABLE @lt_opercnf
       .
    IF lt_opercnf[] IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>results_empty.
    ENDIF.

* ensure that there are only record with unique operations. and with latest actual confirmation date
    SORT lt_opercnf BY aufpl aplzl actual_conf DESCENDING snp_ssedd DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_opercnf COMPARING aufpl aplzl.

**    Get Operation status into the buffer using the status object no
    DATA(lt_pre_objnr) = VALUE tt_objnr( FOR ls_oper IN lt_opercnf ( objnr = ls_oper-objnr  ) ).
    CALL FUNCTION 'STATUS_PRE_READ'
      TABLES
        jsto_pre_tab = lt_pre_objnr[].

***** Build the result work compliance table from snapshot
    LOOP AT lt_opercnf INTO DATA(ls_opercnf).

      APPEND INITIAL LINE TO g_wrkcmpl ASSIGNING FIELD-SYMBOL(<ls_compl_oper>).

      <ls_compl_oper>-iedd = ls_opercnf-actual_conf.
      "Use the snapshot latest finish when available. If not use the latest finish from the operation
      <ls_compl_oper>-ssedd = COND #( WHEN ls_opercnf-snp_ssedd IS NOT INITIAL THEN ls_opercnf-snp_ssedd ELSE ls_opercnf-ssedd ).
      zcl_pm_mrs_snapshot=>get_first_last_dayofweek( EXPORTING i_date = <ls_compl_oper>-ssedd IMPORTING e_week_begda = <ls_compl_oper>-begda e_week_endda = <ls_compl_oper>-endda ).
      <ls_compl_oper>-weekno = ( ( <ls_compl_oper>-ssedd - g_rep_begda ) / 7 ) + '0.5'.
      <ls_compl_oper>-aufnr = ls_opercnf-aufnr.
      <ls_compl_oper>-vornr = ls_opercnf-vornr.
      <ls_compl_oper>-arbpl = ls_opercnf-workcenter.
      <ls_compl_oper>-ktext = ls_opercnf-workcentertext.
      <ls_compl_oper>-arbid = ls_opercnf-arbid.
      <ls_compl_oper>-werks = ls_opercnf-werks.
      <ls_compl_oper>-ordtxt = ls_opercnf-ktext.
      <ls_compl_oper>-ltxa1 = ls_opercnf-ltxa1.

      <ls_compl_oper>-schind = COND #( WHEN ls_opercnf-snp_begda IS NOT INITIAL AND ls_opercnf-snp_endda IS NOT INITIAL
                                        THEN 'SCHEDULED' ELSE '' ).

      <ls_compl_oper>-daycomp = COND #( WHEN ls_opercnf-actual_conf IS NOT INITIAL AND ls_opercnf-snp_begda IS INITIAL THEN g_comstat_breakin
                                        WHEN <ls_compl_oper>-iedd  = <ls_compl_oper>-ssedd THEN g_comstat_compliant
                                        ELSE g_comstat_noncompl ).

      <ls_compl_oper>-weekcomp = COND #( WHEN ls_opercnf-actual_conf IS NOT INITIAL AND ls_opercnf-snp_begda IS INITIAL THEN g_comstat_breakin
                                         WHEN <ls_compl_oper>-iedd GE <ls_compl_oper>-begda
                                              AND <ls_compl_oper>-iedd LE <ls_compl_oper>-endda THEN g_comstat_compliant
                                         ELSE g_comstat_noncompl ).

      CALL FUNCTION 'STATUS_TEXT_EDIT'
        EXPORTING
*         FLG_USER_STAT    = 'X'
          objnr            = ls_opercnf-objnr
          spras            = sy-langu
        IMPORTING
          line             = <ls_compl_oper>-sttxt
*         USER_LINE        =
        EXCEPTIONS
          object_not_found = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

    ENDLOOP.

    SORT g_wrkcmpl BY weekno aufnr vornr.
  ENDMETHOD.


  METHOD validate_workctr_hier.

*    When hier is entered by the user, check if the hier node is entered. Get all the workctr under this node.
    CHECK  i_wrkhier IS NOT INITIAL.
* Get the hierarchy id using the hier name
    SELECT SINGLE objid FROM crhh INTO @e_workhier_id
     WHERE objty EQ @g_objty_hier AND name EQ @i_wrkhier AND werks EQ @i_iwerk.
    IF sy-subrc IS NOT INITIAL OR e_workhier_id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid  = zcx_pm_mrs_repmgr=>invalid_wrkctr_hier
          g_hier  = i_wrkhier
          g_iwerk = i_iwerk.
    ENDIF.

*    Get the hier work center node id if used has entered
    CHECK i_wrknode IS NOT INITIAL.
    SELECT SINGLE objid
      INTO @e_workctr_id
      FROM crhs AS a INNER JOIN crhd AS b
        ON a~objty_hy EQ @g_objty_hier AND a~objid_hy EQ @e_workhier_id
       AND a~objty_ho EQ b~objty AND a~objid_ho EQ b~objid
     WHERE objty EQ @g_objty_wrkctr AND arbpl EQ @i_wrknode AND werks EQ @i_iwerk.
    IF sy-subrc IS NOT INITIAL OR e_workctr_id IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid  = zcx_pm_mrs_repmgr=>invalid_wrkctr_node
          g_hier  = i_wrkhier
          g_node  = i_wrknode
          g_iwerk = i_iwerk.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
