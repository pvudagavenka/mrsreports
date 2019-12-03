class ZCL_PM_MRS_PLBOORGSRV definition
  public
  final
  create public .

public section.

  types:
    ty_t_objlist TYPE TABLE OF zpmstordnotilst .

  class-methods HANDLE_DEM_DISP_MAP
    importing
      value(I_WORKLIST) type ref to CL_GUI_COLUMN_TREE
      value(I_WORKITEMS) type ref to /MRSS/CL_SGU_COL_WORKITEMS .
  class-methods DISPLAY_ORD_MAP
    importing
      value(I_ORDER_LIST) type TY_T_P_AUFNR .
  class-methods GET_OBJECT_LIST_FOR_ORDERS
    importing
      value(I_ORDER_LIST) type TY_T_P_AUFNR
    exporting
      value(E_NOTIMAP_LIST) type TY_T_OBJLIST
    raising
      ZCX_PM_MRS_REPMGR .
  class-methods CONVERSION_OPERNO
    importing
      value(I_OBJ_SORTF) type OBSORT
    returning
      value(R_VORNR) type VORNR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PM_MRS_PLBOORGSRV IMPLEMENTATION.


  METHOD conversion_operno.
    CHECK i_obj_sortf IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
      EXPORTING
        input  = i_obj_sortf
      IMPORTING
        output = r_vornr.
  ENDMETHOD.


  METHOD display_ord_map.
    DATA: l_abs_url TYPE c LENGTH 1024.

    DATA l_container TYPE REF TO cl_gui_container.
    DATA l_viewer    TYPE REF TO cl_gui_html_viewer.

    IF i_order_list[] IS INITIAL.
      MESSAGE w036(zpmmc_mrswrk) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    IF lines( i_order_list ) GT 60."NUMBER_OK"Not supported
      MESSAGE w037(zpmmc_mrswrk) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

* Remove duplicate orders
    DATA(lt_order_list) = i_order_list[].
    SORT lt_order_list .
    DELETE ADJACENT DUPLICATES FROM lt_order_list COMPARING ALL FIELDS.

*  Check if the latitude and longitude details are maintained for the notifications
    TRY .
        CALL METHOD zcl_pm_mrs_plboorgsrv=>get_object_list_for_orders
          EXPORTING
            i_order_list   = lt_order_list
          IMPORTING
            e_notimap_list = DATA(l_notimap_list).
      CATCH zcx_pm_mrs_repmgr INTO DATA(lo_exc).
        MESSAGE lo_exc->get_text( ) TYPE 'I' DISPLAY LIKE 'E'.
        RETURN.
    ENDTRY.

*  Check if the Google maps Javascript API key is available. This will be a TVARV entry
    SELECT SINGLE low FROM tvarvc INTO @DATA(lv_apikey)
     WHERE name EQ 'Z_PM_GIS_APIKEY' AND type EQ 'P'.
    IF sy-subrc IS NOT INITIAL OR lv_apikey IS INITIAL.
      MESSAGE w038(zpmmc_mrswrk) DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

*  Get the BSP application URL
    CALL METHOD cl_http_ext_webapp=>create_url_for_bsp_application
      EXPORTING
        bsp_application      = 'ZTEST_MAP'
        bsp_start_page       = 'main.htm'
        bsp_start_parameters = VALUE #( ( name = 'sap-client' value = sy-mandt )
                                        ( name = 'ORDERS' value = concat_lines_of( table = lt_order_list sep = `,` ) ) )
      IMPORTING
        local_url            = DATA(l_loc_url)
        abs_url              = DATA(l_url).

* Load the map in a new browser window
    IF l_url IS INITIAL.
      MESSAGE i027(bsp_wd) WITH 'ZTEST_MAP' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    CREATE OBJECT l_viewer
      EXPORTING
        parent             = l_container
      EXCEPTIONS
        cntl_error         = 1
        cntl_install_error = 2
        dp_install_error   = 3
        dp_error           = 4
        OTHERS             = 5.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.


    l_abs_url = l_url.
    CALL METHOD l_viewer->detach_url_in_browser
      EXPORTING
        url        = l_abs_url
      EXCEPTIONS
        cntl_error = 1
        OTHERS     = 2.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2
        OTHERS            = 3.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD get_object_list_for_orders.

    DATA: lt_objlst  TYPE riwol_opr_t,
          ls_caufvd  TYPE caufvd,
          lv_vornr   TYPE vornr,
          lt_rng_ord TYPE RANGE OF aufnr.

    IF i_order_list IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>order_list_empty.
    ENDIF.

* Remove duplicate orders
    DATA(lt_order_list) = i_order_list[].
    SORT lt_order_list .
    DELETE ADJACENT DUPLICATES FROM lt_order_list COMPARING ALL FIELDS.
    lt_rng_ord = VALUE #( FOR ls_order IN lt_order_list ( sign = 'I' option = 'EQ' low = ls_order ) ).

* Get the object list - only notifications.
    LOOP AT lt_order_list INTO DATA(lv_aufnr).

* Get the object list for the current order.
      CLEAR: ls_caufvd. REFRESH: lt_objlst.
      CALL FUNCTION 'IWOL_GET_OBJECT_LIST_ALL'
        EXPORTING
          i_aufnr        = lv_aufnr
          caufvd_imp     = ls_caufvd
        IMPORTING
          et_riwol_opr   = lt_objlst
        EXCEPTIONS
          no_object_list = 1
          no_order       = 2
          OTHERS         = 3.
      CASE sy-subrc.
        WHEN 0."No issue
        WHEN OTHERS.
          CONTINUE.
      ENDCASE.

      DELETE lt_objlst WHERE ihnum IS INITIAL.
      IF lt_objlst[] IS INITIAL.
        CONTINUE.
      ENDIF.

      e_notimap_list = VALUE #( BASE e_notimap_list  FOR ls_object IN lt_objlst
                              ( aufnr = lv_aufnr asttx = ls_caufvd-asttx qmnum = ls_object-ihnum
                                vornr = conversion_operno( i_obj_sortf = ls_object-sortf )
                                qmtxt = ls_object-qmtxt ) ).

    ENDLOOP.

**********************************************************************
    IF e_notimap_list IS INITIAL.
      RAISE EXCEPTION TYPE zcx_pm_mrs_repmgr
        EXPORTING
          textid = zcx_pm_mrs_repmgr=>noti_objects_missing.
    ENDIF.

**********************************************************************
*****    Get GIS co-ordinates for the notifications in the object list, where wither the latitude is not blank or longitude is not blank
**********************************************************************


*    Get the operation information for the work orders.
    SELECT ord~aufnr, or1~objnr, opr~vornr, opr~ltxa1, wrk~workcenter,  wrk~workcentertext

      FROM afko AS ord INNER JOIN aufk AS or1 ON ord~aufnr EQ or1~aufnr
     INNER JOIN afvc AS opr ON ord~aufpl EQ opr~aufpl
     INNER JOIN i_workcentertextbysemantickey AS wrk ON opr~arbid EQ wrk~workcenterinternalid
          AND wrk~language EQ @sy-langu
     WHERE ord~aufnr IN @lt_rng_ord
      INTO TABLE @DATA(lt_oper_det)
      .

    LOOP AT e_notimap_list ASSIGNING FIELD-SYMBOL(<ls_noti_mapdet>).

**********************************************************************
* Populate dummy values for now... this will be replaced with logic which is customer specific
**********************************************************************
*      Populate the latitude and longitude details from notification custom table
      CASE sy-tabix.
        WHEN 1.
          <ls_noti_mapdet>-latitude = '-33.890542'.
          <ls_noti_mapdet>-longitude = '151.274856'.
        WHEN 2.
          <ls_noti_mapdet>-latitude = '-33.923036'.
          <ls_noti_mapdet>-longitude = '151.259052'.
        WHEN 3.
          <ls_noti_mapdet>-latitude = '-34.028249'.
          <ls_noti_mapdet>-longitude = '151.157507'.
        WHEN 4.
          <ls_noti_mapdet>-latitude = '-33.80010128657071'.
          <ls_noti_mapdet>-longitude = '151.28747820854187'.
        WHEN 5.
          <ls_noti_mapdet>-latitude = '-33.950198'.
          <ls_noti_mapdet>-longitude = '151.259302'.
        WHEN OTHERS.
          CLEAR <ls_noti_mapdet>-qmnum.
          CONTINUE."ignore record which do not have GIS co-=ordinates
      ENDCASE. .
**********************************************************************

* Populate the operation details if the object is linked to operation
      TRY .
          IF <ls_noti_mapdet>-vornr IS NOT INITIAL.
            DATA(ls_operdet) = lt_oper_det[ aufnr = <ls_noti_mapdet>-aufnr vornr = <ls_noti_mapdet>-vornr ].
            <ls_noti_mapdet>-ltxa1 = ls_operdet-ltxa1.
            <ls_noti_mapdet>-arbpl = ls_operdet-workcenter.
            <ls_noti_mapdet>-ktext = ls_operdet-workcentertext.

            CALL FUNCTION 'STATUS_TEXT_EDIT'
              EXPORTING
                flg_user_stat    = 'X'
                objnr            = ls_operdet-objnr
                spras            = sy-langu
              IMPORTING
                user_line        = <ls_noti_mapdet>-asttx
              EXCEPTIONS
                object_not_found = 1
                OTHERS           = 2.
            IF sy-subrc <> 0.
* Implement suitable error handling here
              CLEAR:<ls_noti_mapdet>-asttx.
            ENDIF.
          ENDIF.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDLOOP.

    DELETE e_notimap_list WHERE qmnum IS INITIAL.
  ENDMETHOD.


  METHOD handle_dem_disp_map.

    DATA: lt_zzsel_nodes TYPE treev_nks,
          ls_zzworkitem  TYPE /mrss/t_sgu_workitem,
          lt_orderno     TYPE TABLE OF aufnr.

* Get the selected node and the info about the selected nodes from the demand view
    CHECK i_workitems IS BOUND AND i_worklist IS BOUND.
    CALL METHOD i_worklist->get_selected_nodes
      CHANGING
        node_key_table = lt_zzsel_nodes.

    LOOP AT lt_zzsel_nodes INTO ls_zzworkitem-node_key.
      CALL METHOD i_workitems->convert_single
        CHANGING
          cs_item   = ls_zzworkitem
        EXCEPTIONS
          not_found = 1.

      IF sy-subrc = 0.
        APPEND COND #( WHEN strlen( ls_zzworkitem-workitem-demand_debug ) GT 12
                        THEN ls_zzworkitem-workitem-demand_debug(12)"Order + Operation....use only order
                        ELSE ls_zzworkitem-workitem-demand_debug ) "Only order
         TO lt_orderno.
      ENDIF.
      CLEAR ls_zzworkitem.
    ENDLOOP.

    display_ord_map( i_order_list = lt_orderno ).
  ENDMETHOD.
ENDCLASS.
