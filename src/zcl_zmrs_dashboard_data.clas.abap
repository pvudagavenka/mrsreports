class ZCL_ZMRS_DASHBOARD_DATA definition
  public
  final
  create public .

public section.

  types:
    tt_workcenter_names TYPE STANDARD TABLE OF wctxt_bw_v .
  types:
    BEGIN OF ty_asg_details,
        name TYPE string,
        note TYPE string,
      END OF ty_asg_details .
  types:
    tt_asg_details TYPE STANDARD TABLE OF ty_asg_details .
  types:
    BEGIN OF ty_oper_assignments,
        order     TYPE aufnr,
        operation TYPE vornr,
        begdate   TYPE syst_datum,
        begtime   TYPE syst_uzeit,
        enddate   TYPE syst_datum,
        endtime   TYPE syst_uzeit,
        person    TYPE string,
        nn_res    TYPE string,
        note      TYPE string,
      END OF ty_oper_assignments .
  types:
    tt_oper_assignments TYPE STANDARD TABLE OF ty_oper_assignments .
  types:
    tt_pernr_names TYPE STANDARD TABLE OF v_bw_pa0001_enm .
  types:
    BEGIN OF ts_token,
        value TYPE string,
      END OF ts_token .
  types:
    BEGIN OF ts_selfilters,
        seldatefrom     TYPE string,
        seldateto       TYPE string,
        idworkcenter    TYPE str_tab,
        idperson        TYPE str_tab,
        idnnresource    TYPE str_tab,
        idtimealloctype TYPE str_tab,
      END OF ts_selfilters .

  data:
    mt_dailyview TYPE STANDARD TABLE OF zcl_zmrs_dashboard_mpc_ext=>ts_dailyview_deep .
  data MT_SELFILTERS type TS_SELFILTERS .

  methods CONSTRUCTOR .
  methods EVALUATE_FILTERS
    importing
      value(IV_JSON) type STRING optional .
protected section.
private section.

  constants MC_HTML_WRC type TDOBNAME value 'ZHTML_ZMRS_DASH_WRC' ##NO_TEXT.
  constants MC_HTML_RESTAB type TDOBNAME value 'ZHTML_ZMRS_DASH_RESTAB' ##NO_TEXT.
  data MT_ORDER_OPERATIONS type RPLM_TT_POWL_ORDER_PM_INFO .
  data MV_HTML_WRC type STRING .
  data MV_HTML_RESTAB type STRING .
  data MT_GUID_PERNR type /MRSS/T_API_GUID_PERNR_TAB .
  data MS_INTERVAL type /MRSS/T_TIMESTAMP_INTERVAL .
  data MT_OPER_ASSIGNMENTS type TT_OPER_ASSIGNMENTS .
  data MT_PERNR_NAMES type TT_PERNR_NAMES .
  data MT_WORKCENTER_NAMES type TT_WORKCENTER_NAMES .
  data MT_RESOURCES type /MRSS/T_BAS_RES_TAB .
  data MT_TIMEALLOCATIONS type /MRSS/T_RES_TIMESPEC_TAB .
  data MV_ALLOCTIME type STRING .

  methods GET_TIMEALLOCATIONS .
  methods GET_OPERATIONS .
  methods GET_APPOINTED_ASSIGNMENTS
    importing
      !IS_OPERATION type RPLM_TS_POWL_ORDER_PM_INFO optional
      !IV_DATE type CO_GSTRP optional
    returning
      value(RV_ASSIGNMENTS) type STRING .
  methods GET_HTML_WRAPPERS .
  methods GET_ASSIGNMENTS
    importing
      !IS_OPERATION type RPLM_TS_POWL_ORDER_PM_INFO optional
      !IS_INTERVAL type /MRSS/T_TIMESTAMP_INTERVAL optional
    returning
      value(RV_EXIST) type BOOLE_D .
  methods GET_NNRES_NAME
    importing
      !IV_RESKEY type /MRSS/T_GUID_RES optional
      !IV_DATE type CO_GSTRP optional
    returning
      value(RV_NAME) type STRING .
  methods GET_PERSON_NAME
    importing
      !IV_RESKEY type /MRSS/T_GUID_RES optional
      !IV_DATE type CO_GSTRP optional
    returning
      value(RV_NAME) type STRING .
  methods GET_DATE_TIMESTAMP
    importing
      !IV_DATE type CO_GSTRP optional
      !IV_TIME type CO_GSUZP optional
      !IV_UTC type BOOLE_D optional
    returning
      value(RV_TIMESTAMP) type TIMESTAMP .
  methods GET_WORKCENTER_NAME
    importing
      !IS_OPERATION type RPLM_TS_POWL_ORDER_PM_INFO optional
    returning
      value(RV_WORKCENTER) type STRING .
  methods GET_FORMATTED_TSTMP
    importing
      !IV_TIMESTAMP type TIMESTAMP optional
      !IV_MIDNIGHT type BOOLE_D optional
    returning
      value(RV_TIMESTAMP) type TIMESTAMP .
ENDCLASS.



CLASS ZCL_ZMRS_DASHBOARD_DATA IMPLEMENTATION.


  METHOD constructor.
*----------------------------------------------------------------------*
*- Get the orders and operations regarding the search criteria
    get_operations( ).
*----------------------------------------------------------------------*
* Buffer the HTML wrapping content
    get_html_wrappers( ).
*----------------------------------------------------------------------*
* Fill Odata entityset with Operations having Assignments Data
    DATA:
      ls_operalloc        TYPE zsmrs_operalloc,
      lv_html_workcenter  TYPE string,
      lv_html_assignments TYPE string,
      lv_gstrp            TYPE co_gstrp,
      lv_seldatefrom      TYPE timestamp,
      lv_seldateto        TYPE timestamp.
    CLEAR: mt_dailyview.
    APPEND INITIAL LINE TO mt_dailyview ASSIGNING FIELD-SYMBOL(<fs_dailyview>).
    <fs_dailyview>-seldateto = get_date_timestamp( iv_date = '99991231' iv_time = '235959' ).
    ms_interval-end_tstmp =
    get_date_timestamp( iv_date = '99991231' iv_time = '235959' iv_utc = abap_true ).
    SORT mt_order_operations BY gstrp v_arbpl ASCENDING.
    ms_interval-beg_tstmp =
    get_date_timestamp( iv_date = mt_order_operations[ 1 ]-gstrp iv_time = '000000' iv_utc = abap_true ).

    APPEND INITIAL LINE TO <fs_dailyview>-dailyview_sections ASSIGNING FIELD-SYMBOL(<fs_sections>).
    <fs_sections>-row_id = '0'.

    LOOP AT mt_order_operations ASSIGNING FIELD-SYMBOL(<fs_operation>).
*--------------------------------------------------------------------*
* Buffer the Assignments against each operation
      CHECK:
      get_assignments( is_operation = <fs_operation> is_interval = ms_interval )
      = abap_true.
*--------------------------------------------------------------------*
      CLEAR: ls_operalloc.
      ls_operalloc-row_id = '0'.
      ls_operalloc-operresource = |WO : { <fs_operation>-aufnr ALPHA = OUT }/{ <fs_operation>-vornr ALPHA = OUT }|.
      CONDENSE ls_operalloc-operresource.
      ls_operalloc-operallocinfo = |{ <fs_operation>-ltxa1 CASE = (cl_abap_format=>c_upper) }|.
      IF ls_operalloc-operallocinfo IS INITIAL.
        ls_operalloc-operallocinfo = cl_abap_char_utilities=>horizontal_tab.
      ENDIF.
      CASE <fs_operation>-ustxt.
        WHEN 'FSCH'. ls_operalloc-operallocstatus = '#00FF7F'. "'Type08'. "Green
        WHEN 'WFIS'. ls_operalloc-operallocstatus = '#FFA500'. "'Type01'. "Orange
        WHEN OTHERS. ls_operalloc-operallocstatus = '#FA8072'. "'Type03'. "Red
      ENDCASE.

* WRC name : Description of Operation Work Centre
      CLEAR: lv_html_workcenter.
      IF NOT <fs_operation>-v_arbpl IS INITIAL.
        lv_html_workcenter = get_workcenter_name( <fs_operation> ).
      ENDIF.

* Operations could span multiple days - Start with Start date and create an
* individual entry for each day until End Date
* This is done because there could be different assignments each day
      lv_gstrp = <fs_operation>-gstrp.
      WHILE lv_gstrp <= <fs_operation>-gltrp.
        CLEAR: lv_html_assignments.
        lv_html_assignments =
        get_appointed_assignments( is_operation = <fs_operation> iv_date = lv_gstrp ).

        IF NOT lv_html_assignments IS INITIAL.
          ls_operalloc-operallocstart = get_date_timestamp( iv_date = lv_gstrp iv_time = '000000').
          ls_operalloc-operallocend = get_date_timestamp( iv_date = lv_gstrp iv_time = '235959').

          IF NOT lv_html_workcenter IS INITIAL.
            ls_operalloc-operallocdetails = lv_html_workcenter.
          ENDIF.
          ls_operalloc-operallocdetails = ls_operalloc-operallocdetails &&  lv_html_assignments.

          CLEAR: lv_seldatefrom.
          lv_seldatefrom = get_date_timestamp( iv_date = lv_gstrp iv_time = '000000').
          IF <fs_dailyview>-seldatefrom IS INITIAL.
            <fs_dailyview>-seldatefrom = lv_seldatefrom.
          ELSE.
            IF lv_seldatefrom < <fs_dailyview>-seldatefrom.
              <fs_dailyview>-seldatefrom = lv_seldatefrom.
            ENDIF.
          ENDIF.
*          CLEAR: lv_seldateto.
*          lv_seldateto = get_date_timestamp( iv_date = lv_gstrp iv_time = '235959').
*          IF <fs_dailyview>-seldateto IS INITIAL.
*            <fs_dailyview>-seldateto = lv_seldateto.
*          ELSE.
*            IF lv_seldateto > <fs_dailyview>-seldateto.
*              <fs_dailyview>-seldateto = lv_seldateto.
*            ENDIF.
*          ENDIF.

          APPEND ls_operalloc TO <fs_sections>-section_operallocs.
        ENDIF.
        CLEAR: ls_operalloc-operallocstart, ls_operalloc-operallocend, ls_operalloc-operallocdetails.
        lv_gstrp = lv_gstrp + 1.
      ENDWHILE.
    ENDLOOP.
    UNASSIGN:
    <fs_operation>,
    <fs_sections>,
    <fs_dailyview>.
*--------------------------------------------------------------------*
* Checking to see if time allocations are shown:
    get_timeallocations( ).
    APPEND INITIAL LINE TO mt_dailyview ASSIGNING <fs_dailyview>.
    <fs_dailyview>-seldatefrom = mt_dailyview[ 1 ]-seldatefrom.
    <fs_dailyview>-seldateto = get_date_timestamp( iv_date = '99991231' iv_time = '235959' ).
    APPEND INITIAL LINE TO <fs_dailyview>-dailyview_sections ASSIGNING <fs_sections>.
    <fs_sections>-row_id = '1'.
    LOOP AT mt_timeallocations ASSIGNING FIELD-SYMBOL(<fs_allocations>).
      APPEND INITIAL LINE TO <fs_sections>-section_operallocs ASSIGNING
      FIELD-SYMBOL(<fs_operalloc>).
      <fs_operalloc>-row_id = '1'.
      <fs_operalloc>-operresource = get_person_name( iv_reskey = <fs_allocations>-business_partner_id ).
      <fs_operalloc>-operallocinfo = <fs_allocations>-description.
      <fs_operalloc>-operallocstart = get_formatted_tstmp( iv_timestamp = <fs_allocations>-beg_tstmp iv_midnight = abap_true ).
      <fs_operalloc>-operallocinfo = |{ <fs_operalloc>-operallocinfo } ({ mv_alloctime } to |.
      <fs_operalloc>-operallocend = get_formatted_tstmp( iv_timestamp = <fs_allocations>-end_tstmp ).
      <fs_operalloc>-operallocinfo = |{ <fs_operalloc>-operallocinfo }{ mv_alloctime })|.
*      <fs_operalloc>-operallocstart =  <fs_allocations>-beg_tstmp.
*      <fs_operalloc>-operallocend =  <fs_allocations>-end_tstmp.
      <fs_operalloc>-operallocstatus = '#6495ED'. "Cornflower Blue color

      UNASSIGN <fs_operalloc>.
    ENDLOOP.
    CLEAR: lv_gstrp.
*--------------------------------------------------------------------*

  ENDMETHOD.


  METHOD evaluate_filters.

    IF iv_json IS INITIAL.
      RETURN.
    ENDIF.

    CLEAR: mt_selfilters.
    CALL METHOD /ui2/cl_json=>deserialize
      EXPORTING
        json = iv_json
      CHANGING
        data = mt_selfilters.



  ENDMETHOD.


  METHOD get_appointed_assignments.

    DATA:
      lv_tabix       TYPE syst_tabix,
      ls_asg_person  TYPE ty_asg_details,
      ls_asg_nnres   TYPE ty_asg_details,
      lt_asg_persnam TYPE tt_asg_details,
      lt_asg_persnpm TYPE tt_asg_details,
      lt_asg_nnresam TYPE tt_asg_details,
      lt_asg_nnrespm TYPE tt_asg_details.

    DATA:
      lv_work_str    TYPE string,
      lv_html_person TYPE string,
      lv_html_nnres  TYPE string.

    CLEAR: rv_assignments.
    READ TABLE mt_oper_assignments ASSIGNING FIELD-SYMBOL(<fs_oper_assignments>)
    WITH KEY order = is_operation-aufnr operation = is_operation-vornr
    BINARY SEARCH.
    IF <fs_oper_assignments> IS ASSIGNED.
      lv_tabix = sy-tabix.
      UNASSIGN <fs_oper_assignments>.
      LOOP AT mt_oper_assignments ASSIGNING <fs_oper_assignments>
        FROM lv_tabix.
        IF <fs_oper_assignments>-order <> is_operation-aufnr
        OR <fs_oper_assignments>-operation <> is_operation-vornr.
          EXIT.
        ENDIF.
* Check window of work on current day( iv_date )
        CHECK: ( <fs_oper_assignments>-enddate >= iv_date AND <fs_oper_assignments>-endtime >= '000000' )
          AND  ( <fs_oper_assignments>-begdate <= iv_date AND <fs_oper_assignments>-begtime <= '235959' ).
        IF NOT <fs_oper_assignments>-person IS INITIAL.
          ls_asg_person-name = <fs_oper_assignments>-person.
          ls_asg_person-note = <fs_oper_assignments>-note.
* Cases:
* 1.Starts before today
          IF <fs_oper_assignments>-begdate < iv_date.
* 1.1 Ends today
            IF <fs_oper_assignments>-enddate = iv_date.
* 1.1.1 Ends Today am -> am
              IF <fs_oper_assignments>-endtime <= '115959'.
                COLLECT ls_asg_person INTO: lt_asg_persnam.
* 1.1.2 Ends Today pm -> am and pm
              ELSE.
                COLLECT ls_asg_person INTO: lt_asg_persnam, lt_asg_persnpm.
              ENDIF.

* 1.2 Ends Tomorrow of after -> am and pm
            ELSE.
              COLLECT ls_asg_person INTO: lt_asg_persnam, lt_asg_persnpm.
            ENDIF.
* 2.Starts today
          ELSE.

* 2.1 Starts Today am
            IF <fs_oper_assignments>-begtime <= '115959'.
* 2.1.1 Ends today am
              IF <fs_oper_assignments>-endtime <= '115959'.
                COLLECT ls_asg_person INTO: lt_asg_persnam.
* 2.1.2 Ends Today pm
              ELSE.
                COLLECT ls_asg_person INTO: lt_asg_persnam, lt_asg_persnpm.
              ENDIF.

* 2.2 Starts Today pm
            ELSE.
              COLLECT ls_asg_person INTO lt_asg_persnpm.
            ENDIF.
          ENDIF.
        ENDIF.
*--------------------------------------------------------------------*
*====================================================================*
*--------------------------------------------------------------------*
        IF NOT <fs_oper_assignments>-nn_res IS INITIAL.
          ls_asg_nnres-name = <fs_oper_assignments>-nn_res.
          ls_asg_nnres-note = <fs_oper_assignments>-note.
* Cases:
* 1.Starts before today
          IF <fs_oper_assignments>-begdate < iv_date.
* 1.1 Ends today
            IF <fs_oper_assignments>-enddate = iv_date.
* 1.1.1 Ends Today am -> am
              IF <fs_oper_assignments>-endtime <= '115959'.
                COLLECT ls_asg_nnres INTO: lt_asg_nnresam.
* 1.1.2 Ends Today pm -> am and pm
              ELSE.
                COLLECT ls_asg_nnres INTO: lt_asg_nnresam, lt_asg_nnrespm.
              ENDIF.

* 1.2 Ends Tomorrow of after -> am and pm
            ELSE.
              COLLECT ls_asg_nnres INTO: lt_asg_nnresam, lt_asg_nnrespm.
            ENDIF.
* 2.Starts today
          ELSE.

* 2.1 Starts Today am
            IF <fs_oper_assignments>-begtime <= '115959'.
* 2.1.1 Ends today am
              IF <fs_oper_assignments>-endtime <= '115959'.
                COLLECT ls_asg_nnres INTO: lt_asg_nnresam.
* 2.1.2 Ends Today pm
              ELSE.
                COLLECT ls_asg_nnres INTO: lt_asg_nnresam, lt_asg_nnrespm.
              ENDIF.

* 2.2 Starts Today pm
            ELSE.
              COLLECT ls_asg_nnres INTO: lt_asg_nnrespm.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
      IF <fs_oper_assignments> IS ASSIGNED.
        UNASSIGN <fs_oper_assignments>.
      ENDIF.

      IF NOT lt_asg_persnam IS INITIAL
      OR NOT lt_asg_persnpm IS INITIAL.
        SORT:
        lt_asg_persnam BY name,
        lt_asg_persnpm BY name.
* Build HTML String
        CLEAR: lv_html_person.
        lv_html_person = '<table class="PernrTable" style="width:100%">'.
*--------------------------------------------------------------------*
        IF lines( lt_asg_persnam ) > lines( lt_asg_persnpm ).
          LOOP AT lt_asg_persnam ASSIGNING FIELD-SYMBOL(<fs_asg_am>).
            lv_tabix = sy-tabix.
            lv_work_str = mv_html_restab.
            REPLACE ALL OCCURRENCES OF:
            '{RESOURCEAM}' IN lv_work_str WITH <fs_asg_am>-name,
            '{NOTEAM}' IN lv_work_str WITH <fs_asg_am>-note.
            READ TABLE lt_asg_persnpm ASSIGNING FIELD-SYMBOL(<fs_asg_pm>) INDEX lv_tabix.
            IF <fs_asg_pm> IS ASSIGNED.
              REPLACE ALL OCCURRENCES OF:
              '{RESOURCEPM}' IN lv_work_str WITH <fs_asg_pm>-name,
              '{NOTEPM}' IN lv_work_str WITH <fs_asg_pm>-note.
              UNASSIGN <fs_asg_pm>.
            ELSE.
              REPLACE ALL OCCURRENCES OF:
              '{RESOURCEPM}' IN lv_work_str WITH cl_abap_char_utilities=>horizontal_tab,
              '{NOTEPM}' IN lv_work_str WITH cl_abap_char_utilities=>horizontal_tab.
            ENDIF.
            lv_html_person = lv_html_person && lv_work_str.
          ENDLOOP.
        ELSE.
          LOOP AT lt_asg_persnpm ASSIGNING <fs_asg_pm>.
            lv_tabix = sy-tabix.
            lv_work_str = mv_html_restab.
            REPLACE ALL OCCURRENCES OF:
            '{RESOURCEPM}' IN lv_work_str WITH <fs_asg_pm>-name,
            '{NOTEPM}' IN lv_work_str WITH <fs_asg_pm>-note.
            READ TABLE lt_asg_persnam ASSIGNING <fs_asg_am> INDEX lv_tabix.
            IF <fs_asg_am> IS ASSIGNED.
              REPLACE ALL OCCURRENCES OF:
              '{RESOURCEAM}' IN lv_work_str WITH <fs_asg_am>-name,
              '{NOTEAM}' IN lv_work_str WITH <fs_asg_am>-note.
              UNASSIGN <fs_asg_am>.
            ELSE.
              REPLACE ALL OCCURRENCES OF:
              '{RESOURCEAM}' IN lv_work_str WITH cl_abap_char_utilities=>horizontal_tab,
              '{NOTEAM}' IN lv_work_str WITH cl_abap_char_utilities=>horizontal_tab.
            ENDIF.
            lv_html_person = lv_html_person && lv_work_str.
          ENDLOOP.
        ENDIF.
*--------------------------------------------------------------------*
        lv_html_person = lv_html_person && '</table>'.
        IF <fs_asg_am> IS ASSIGNED.
          UNASSIGN <fs_asg_am>.
        ENDIF.
        IF <fs_asg_pm> IS ASSIGNED.
          UNASSIGN <fs_asg_pm>.
        ENDIF.
      ENDIF.

      IF NOT lv_html_person IS INITIAL.
        rv_assignments =  lv_html_person.
      ENDIF.
      IF NOT lv_html_nnres IS INITIAL.
        rv_assignments = rv_assignments && |<br/>{ lv_html_nnres }|.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD GET_ASSIGNMENTS.
*--------------------------------------------------------------------*
    DATA:
      ls_operation   TYPE /mrss/t_order_oper,
      lt_assignments TYPE /mrss/t_api_assmnt_exp_tab.
    CLEAR: rv_exist.
    rv_exist = abap_true.
    ls_operation-orderno = is_operation-aufnr.
    ls_operation-operationno = is_operation-vornr.
    CALL FUNCTION '/MRSS/SGE_API_ASSIGNMENT_GET'
      EXPORTING
        is_order_oper  = ls_operation
        is_interval    = is_interval
      IMPORTING
        et_assignments = lt_assignments.
    IF lt_assignments IS INITIAL.
      rv_exist = abap_false.
      RETURN.
    ENDIF.
*--------------------------------------------------------------------*
    LOOP AT lt_assignments ASSIGNING FIELD-SYMBOL(<fs_assignments>).
      APPEND INITIAL LINE TO mt_oper_assignments ASSIGNING FIELD-SYMBOL(<fs_oper_assignments>).
*--------------------------------------------------------------------*
      <fs_oper_assignments>-order = is_operation-aufnr.
      <fs_oper_assignments>-operation = is_operation-vornr.
      CONVERT:
      TIME STAMP <fs_assignments>-beg_tstmp TIME ZONE 'AUSVIC'
      INTO DATE <fs_oper_assignments>-begdate TIME <fs_oper_assignments>-begtime,
      TIME STAMP <fs_assignments>-end_tstmp TIME ZONE 'AUSVIC'
      INTO DATE <fs_oper_assignments>-enddate TIME <fs_oper_assignments>-endtime.
      <fs_oper_assignments>-person = get_person_name( iv_reskey = <fs_assignments>-resource_key iv_date = is_operation-gstrp ).
      <fs_oper_assignments>-nn_res = get_nnres_name( iv_reskey = <fs_assignments>-resource_key iv_date = is_operation-gstrp ).
      <fs_oper_assignments>-note = <fs_assignments>-note.
*--------------------------------------------------------------------*
* MOCK - remove later
      IF <fs_assignments>-note is INITIAL.
        <fs_oper_assignments>-note = 'Cards'(mn1).
      ENDIF.
*--------------------------------------------------------------------*
*--------------------------------------------------------------------*
      IF <fs_oper_assignments> IS ASSIGNED.
        UNASSIGN <fs_oper_assignments>.
      ENDIF.
    ENDLOOP.
    SORT mt_oper_assignments BY order operation begdate begtime enddate endtime.
*--------------------------------------------------------------------*


  ENDMETHOD.


  METHOD get_date_timestamp.
    DATA: lv_tzone TYPE tznzone.
    IF iv_utc = abap_true.
      lv_tzone = 'UTC   '.
    ELSE.
* TO-DO: figure out a way to get the Timezone
      lv_tzone = 'AUSVIC'.
    ENDIF.
    CLEAR: rv_timestamp.
    CONVERT DATE iv_date TIME iv_time
*   DAYLIGHT SAVING TIME abap_true
    INTO TIME STAMP rv_timestamp TIME ZONE lv_tzone.
  ENDMETHOD.


  METHOD get_formatted_tstmp.

    DATA:
      lv_locdate TYPE syst_datum,
      lv_loctime TYPE syst_uzeit.

    CLEAR:
    rv_timestamp,
    mv_alloctime.
    CONVERT TIME STAMP iv_timestamp TIME ZONE 'AUSVIC' INTO
    DATE lv_locdate TIME lv_loctime.
    mv_alloctime = |{ lv_locdate+6(2) }.{ lv_locdate+4(2) } - { lv_loctime+0(2) }:{ lv_loctime+2(2) }|.
    IF iv_midnight = abap_true.
      lv_loctime = '000000'.
    ELSE.
      lv_loctime = '235959'.
    ENDIF.
    rv_timestamp = get_date_timestamp( iv_date = lv_locdate iv_time = lv_loctime ).

  ENDMETHOD.


  METHOD get_html_wrappers.
    DATA:
      lt_html_table TYPE tlinet.
    DATA(lv_spras) = cl_abap_syst=>get_logon_language( ).
    IF lv_spras IS INITIAL.
      lv_spras = 'E'.
    ENDIF.
    REFRESH: lt_html_table.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'
        language                = lv_spras
        name                    = mc_html_wrc
        object                  = 'TEXT'
      TABLES
        lines                   = lt_html_table
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      CLEAR: mv_html_wrc.
    ELSE.
      LOOP AT lt_html_table ASSIGNING FIELD-SYMBOL(<fs_html>).
        IF mv_html_wrc IS INITIAL.
          mv_html_wrc = <fs_html>-tdline.
        ELSE.
          mv_html_wrc = mv_html_wrc && <fs_html>-tdline.
        ENDIF.
      ENDLOOP.
      IF <fs_html> IS ASSIGNED.
        UNASSIGN <fs_html>.
      ENDIF.
    ENDIF.
*--------------------------------------------------------------------*
    REFRESH: lt_html_table.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'
        language                = lv_spras
        name                    = mc_html_restab
        object                  = 'TEXT'
      TABLES
        lines                   = lt_html_table
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      CLEAR: mv_html_restab.
    ELSE.
      LOOP AT lt_html_table ASSIGNING <fs_html>.
        IF mv_html_restab IS INITIAL.
          mv_html_restab = <fs_html>-tdline.
        ELSE.
          mv_html_restab = mv_html_restab && <fs_html>-tdline.
        ENDIF.
      ENDLOOP.
      IF <fs_html> IS ASSIGNED.
        UNASSIGN <fs_html>.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_nnres_name.

    DATA: ls_nn_res TYPE /mrss/d_nn_res.

    CLEAR: rv_name.
    SELECT SINGLE description FROM /mrss/d_nn_res INTO ls_nn_res
      WHERE guid = iv_reskey.
    IF ls_nn_res-hiring_date <= iv_date
    AND ls_nn_res-leaving_date >= iv_date.
      IF ls_nn_res-description IS INITIAL.
        rv_name = ls_nn_res-nn_res_number.
      ELSE.
        rv_name = ls_nn_res-description.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_operations.
    DATA:
      ls_selcrit_values TYPE rsparams,
      lt_selcrit_values TYPE rsparams_tt.
    ls_selcrit_values-sign = 'I'.
    ls_selcrit_values-option = 'EQ'.
    ls_selcrit_values-kind = 'P'.
    ls_selcrit_values-low = abap_true.
    ls_selcrit_values-selname = 'SP_OFN'. APPEND ls_selcrit_values TO lt_selcrit_values.
    ls_selcrit_values-selname = 'SP_IAR'. APPEND ls_selcrit_values TO lt_selcrit_values.
    ls_selcrit_values-selname = 'SP_MAB'. APPEND ls_selcrit_values TO lt_selcrit_values.
    ls_selcrit_values-selname = 'SP_HIS'. APPEND ls_selcrit_values TO lt_selcrit_values.
    cl_rplm_qimt_report_launcher=>submit_ri_order_operation_list(
      EXPORTING
        i_sel_crit     = lt_selcrit_values
      IMPORTING
        e_return_order = mt_order_operations ).
  ENDMETHOD.


  METHOD get_person_name.

    CLEAR: rv_name.
    DATA:
      ls_guid_pernr TYPE /mrss/t_api_guid_pernr,
      lt_guid_pernr TYPE /mrss/t_api_guid_pernr_tab.
*--------------------------------------------------------------------*
* MRS master
    IF mt_resources IS INITIAL.
      SELECT * FROM /mrss/d_bas_res INTO TABLE mt_resources WHERE resource_type = '00'.
      SORT mt_resources BY resource_key.
    ENDIF.
    READ TABLE mt_resources ASSIGNING FIELD-SYMBOL(<fs_resource>) WITH KEY
    resource_key = iv_reskey BINARY SEARCH.
    IF <fs_resource> IS ASSIGNED.
      rv_name = |{ <fs_resource>-description CASE = (cl_abap_format=>c_upper) }|.
    ENDIF.
    IF NOT rv_name IS INITIAL.
      RETURN.
    ENDIF.
*--------------------------------------------------------------------*
* HR master
    READ TABLE mt_guid_pernr INTO ls_guid_pernr WITH KEY guid = iv_reskey BINARY SEARCH.
    IF sy-subrc <> 0.
      lt_guid_pernr = VALUE #( ( guid = iv_reskey ) ).
      CALL FUNCTION '/MRSS/SGE_API_GUID_PERNR'
        CHANGING
          ct_pernr_guid = lt_guid_pernr.
      SORT lt_guid_pernr BY guid.
      READ TABLE lt_guid_pernr INTO ls_guid_pernr WITH KEY guid = iv_reskey BINARY SEARCH.
      ls_guid_pernr-guid = iv_reskey.
      COLLECT ls_guid_pernr INTO mt_guid_pernr.
      SORT mt_guid_pernr BY guid.
    ENDIF.
    IF ls_guid_pernr-pernr IS INITIAL.
      RETURN.
    ENDIF.
    DATA:
      lv_tabix TYPE syst_tabix.
    READ TABLE mt_pernr_names ASSIGNING FIELD-SYMBOL(<fs_pernr_names>)
    WITH KEY pernr = CONV #( ls_guid_pernr-pernr ) BINARY SEARCH.
    IF <fs_pernr_names> IS ASSIGNED.
      UNASSIGN <fs_pernr_names>.
      lv_tabix = sy-tabix.
    ELSE.
      SELECT * FROM v_bw_pa0001_enm APPENDING TABLE mt_pernr_names
        WHERE pernr = ls_guid_pernr-pernr.
      IF sy-subrc <> 0.
        CLEAR: lv_tabix.
        RETURN.
      ELSE.
        SORT mt_pernr_names BY pernr dateto datefrom.
        READ TABLE mt_pernr_names ASSIGNING <fs_pernr_names>
        WITH KEY pernr = CONV #( ls_guid_pernr-pernr ) BINARY SEARCH.
        IF <fs_pernr_names> IS ASSIGNED.
          UNASSIGN <fs_pernr_names>.
          lv_tabix = sy-tabix.
        ENDIF.
      ENDIF.
    ENDIF.
    LOOP AT mt_pernr_names ASSIGNING <fs_pernr_names> FROM lv_tabix
      WHERE dateto >= iv_date AND datefrom <= iv_date.
      IF <fs_pernr_names>-pernr <> ls_guid_pernr-pernr.
        EXIT.
      ENDIF.
      EXIT.
    ENDLOOP.
    IF <fs_pernr_names> IS ASSIGNED
    AND <fs_pernr_names>-pernr = ls_guid_pernr-pernr.
      rv_name =
      |{ <fs_pernr_names>-txtmd CASE = (cl_abap_format=>c_upper) }|.
    ENDIF.

  ENDMETHOD.


  METHOD get_timeallocations.
*--------------------------------------------------------------------*
* MRS master
    IF mt_resources IS INITIAL.
      SELECT * FROM /mrss/d_bas_res INTO TABLE mt_resources WHERE resource_type = '00'.
      SORT mt_resources BY resource_key.
    ENDIF.
*--------------------------------------------------------------------*
    IF mt_resources is INITIAL. RETURN.  ENDIF.
    DATA: lt_resources TYPE /mrss/t_guid_struc_tab.
    lt_resources = VALUE #( FOR <fs_resource> IN mt_resources ( guid = <fs_resource>-resource_key ) ).
    CALL FUNCTION '/MRSS/SGE_API_TIMESPEC_GET'
      EXPORTING
        it_resources       = lt_resources
        is_interval        = ms_interval
        iv_global_timespec = abap_true
      IMPORTING
        et_timespecs       = mt_timeallocations.

  ENDMETHOD.


  METHOD get_workcenter_name.
    CLEAR:
    rv_workcenter.

    IF mt_workcenter_names IS INITIAL.
      DATA(lv_spras) = cl_abap_syst=>get_logon_language( ).
      IF lv_spras IS INITIAL.
        lv_spras = 'E'.
      ENDIF.
      SELECT * FROM wctxt_bw_v INTO TABLE mt_workcenter_names WHERE
        spras = lv_spras.
      SORT mt_workcenter_names BY arbpl.
    ENDIF.
    READ TABLE mt_workcenter_names ASSIGNING FIELD-SYMBOL(<fs_workcenter_names>)
    WITH KEY arbpl = is_operation-v_arbpl BINARY SEARCH.
    IF NOT <fs_workcenter_names> IS ASSIGNED.
      RETURN.
    ENDIF.
    IF <fs_workcenter_names>-txtmd IS INITIAL. RETURN.  ENDIF.
*--------------------------------------------------------------------*
* Wrap Text around HTML
    rv_workcenter = mv_html_wrc.
    IF rv_workcenter IS INITIAL. RETURN.  ENDIF.
    DATA: lv_workcenter TYPE string.
    lv_workcenter = |WRC : { <fs_workcenter_names>-txtmd }|.
    REPLACE ALL OCCURRENCES OF '{WORKCENTER}' IN rv_workcenter WITH lv_workcenter.
*--------------------------------------------------------------------*

  ENDMETHOD.
ENDCLASS.
