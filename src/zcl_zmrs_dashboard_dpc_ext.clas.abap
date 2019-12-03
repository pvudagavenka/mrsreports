class ZCL_ZMRS_DASHBOARD_DPC_EXT definition
  public
  inheriting from ZCL_ZMRS_DASHBOARD_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
protected section.

  methods PERSONSET_GET_ENTITYSET
    redefinition .
  methods TIMEALLOCATIONTY_GET_ENTITYSET
    redefinition .
  methods WORKCENTERSET_GET_ENTITYSET
    redefinition .
  methods NNRESOURCESET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMRS_DASHBOARD_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
*--------------------------------------------------------------------*
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_filter_select_options =
**    it_order                 =
**    is_paging                =
**    it_navigation_path       =
**    it_key_tab               =
**    iv_filter_string         =
**    iv_search_string         =
**    io_expand                =
**    io_tech_request_context  =
**  IMPORTING
**    er_entityset             =
**    et_expanded_clauses      =
**    et_expanded_tech_clauses =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
*--------------------------------------------------------------------*
    IF NOT iv_entity_name = 'DailyView'.
      RETURN.
    ENDIF.
**    DATA:
**    lt_dailyview TYPE STANDARD TABLE OF zcl_zmrs_dashboard_mpc_ext=>ts_dailyview_deep.
**    APPEND INITIAL LINE TO lt_dailyview ASSIGNING FIELD-SYMBOL(<fs_dailyview>).
***    <fs_dailyview>-seldatefrom = '20190301000000'.
***    <fs_dailyview>-seldateto = '20190331235959'.
**    CONVERT DATE '20190301' TIME '000000' DAYLIGHT SAVING TIME abap_true INTO TIME STAMP <fs_dailyview>-seldatefrom TIME ZONE 'AUSVIC'.
**    CONVERT DATE '20190331' TIME '235959' DAYLIGHT SAVING TIME abap_true INTO TIME STAMP <fs_dailyview>-seldateto TIME ZONE 'AUSVIC'.
**    APPEND INITIAL LINE TO <fs_dailyview>-dailyview_sections ASSIGNING FIELD-SYMBOL(<fs_sections>).
**    <fs_sections>-row_id = '0'.
**    APPEND INITIAL LINE TO <fs_sections>-section_operallocs ASSIGNING FIELD-SYMBOL(<fs_operallocs>).
**    <fs_operallocs>-row_id = '0'.
***    <fs_operallocs>-operallocstart = '20190301000000'.
***    <fs_operallocs>-operallocend = '20190301235959'.
**    CONVERT DATE '20190301' TIME '000000' DAYLIGHT SAVING TIME abap_true INTO TIME STAMP <fs_operallocs>-operallocstart TIME ZONE 'AUSVIC'.
**    CONVERT DATE '20190301' TIME '235959' DAYLIGHT SAVING TIME abap_true INTO TIME STAMP <fs_operallocs>-operallocend TIME ZONE 'AUSVIC'.
**    <fs_operallocs>-operresource = 'OrderS4H/operationS4H'.
**    <fs_operallocs>-operallocinfo = 'Operation Short Text S4H'.
**    <fs_operallocs>-operallocstatus = 'Type08'.
**    <fs_operallocs>-operallocdetails = 'Some HTML code'.

    DATA: lo_dashboard TYPE REF TO zcl_zmrs_dashboard_data.
    CREATE OBJECT lo_dashboard.


    APPEND INITIAL LINE TO et_expanded_tech_clauses ASSIGNING FIELD-SYMBOL(<fs_expanded>).
    <fs_expanded> = 'DailyView_Sections/Section_OperAllocs'.
    copy_data_to_ref( EXPORTING is_data = lo_dashboard->mt_dailyview
                      CHANGING cr_data = er_entityset ).

  ENDMETHOD.


  METHOD nnresourceset_get_entityset.
    DATA: lt_nn_res TYPE /mrss/t_nn_res_tab.
    CALL FUNCTION '/MRSS/NN_RES_READ'
      IMPORTING
        et_nn_res = lt_nn_res.
    IF lt_nn_res IS INITIAL.
      RETURN.
    ENDIF.
    LOOP AT lt_nn_res ASSIGNING FIELD-SYMBOL(<fs_nn_res>).
      APPEND INITIAL LINE TO et_entityset ASSIGNING FIELD-SYMBOL(<fs_entity>).
      MOVE-CORRESPONDING <fs_nn_res> TO <fs_entity>.
      IF <fs_entity> IS ASSIGNED.
        UNASSIGN <fs_entity>.
      ENDIF.
    ENDLOOP.
    IF <fs_nn_res> IS ASSIGNED.
      UNASSIGN <fs_nn_res>.
    ENDIF.

  ENDMETHOD.


  METHOD personset_get_entityset.
    DATA: lt_persons TYPE STANDARD TABLE OF v_bw_pa0001_enm.
    SELECT * FROM v_bw_pa0001_enm INTO TABLE lt_persons.
    IF lt_persons IS INITIAL.
      RETURN.
    ENDIF.
    SORT lt_persons BY pernr.
    DELETE ADJACENT DUPLICATES FROM lt_persons COMPARING pernr.
    LOOP AT lt_persons ASSIGNING FIELD-SYMBOL(<fs_persons>).
      APPEND INITIAL LINE TO et_entityset ASSIGNING FIELD-SYMBOL(<fs_entity>).
      MOVE-CORRESPONDING <fs_persons> TO <fs_entity>.
      IF <fs_entity> IS ASSIGNED.
        UNASSIGN <fs_entity>.
      ENDIF.
    ENDLOOP.
    IF <fs_persons> IS ASSIGNED.
      UNASSIGN <fs_persons>.
    ENDIF.
  ENDMETHOD.


  METHOD timeallocationty_get_entityset.

    DATA: lt_tatypes TYPE /mrss/t_rm_ta_text_tab.
    CALL FUNCTION '/MRSS/RMS_GET_TIMESPECTYPE_ALL'
      IMPORTING
        et_timespec_text = lt_tatypes.
    IF lt_tatypes IS INITIAL.
      RETURN.
    ENDIF.
    LOOP AT lt_tatypes ASSIGNING FIELD-SYMBOL(<fs_tatypes>).
      APPEND INITIAL LINE TO et_entityset ASSIGNING FIELD-SYMBOL(<fs_entity>).
      MOVE-CORRESPONDING <fs_tatypes> TO <fs_entity>.
      IF <fs_entity> IS ASSIGNED.
        UNASSIGN <fs_entity>.
      ENDIF.
    ENDLOOP.
    IF <fs_tatypes> IS ASSIGNED.
      UNASSIGN <fs_tatypes>.
    ENDIF.


  ENDMETHOD.


  METHOD workcenterset_get_entityset.
    DATA:
      lv_spras       TYPE spras,
      lt_workcenters TYPE STANDARD TABLE OF wctxt_bw_v.
    lv_spras = cl_abap_syst=>get_logon_language( ).
    IF lv_spras IS INITIAL.
      lv_spras = 'E'.
    ENDIF.
    SELECT * FROM wctxt_bw_v INTO TABLE lt_workcenters WHERE spras = lv_spras.
    IF lt_workcenters IS INITIAL.
      RETURN.
    ENDIF.
    LOOP AT lt_workcenters ASSIGNING FIELD-SYMBOL(<fs_workcenters>).
      APPEND INITIAL LINE TO et_entityset ASSIGNING FIELD-SYMBOL(<fs_entity>).
      MOVE-CORRESPONDING <fs_workcenters> TO <fs_entity>.
      <fs_entity>-ktext = <fs_workcenters>-txtmd.
      IF <fs_entity> IS ASSIGNED.
        UNASSIGN <fs_entity>.
      ENDIF.
    ENDLOOP.
    IF <fs_workcenters> IS ASSIGNED.
      UNASSIGN <fs_workcenters>.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
