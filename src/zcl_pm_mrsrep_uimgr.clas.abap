class ZCL_PM_MRSREP_UIMGR definition
  public
  final
  create public .

public section.

  types:
    TY_T_WKCTR_TA TYPE STANDARD TABLE OF zpmstwkctr_ta .
  types:
    ty_t_wkctr_avail TYPE STANDARD TABLE OF zpmstwkctr_avail .
  types:
    ty_t_notimap_list TYPE TABLE OF zpmstordnotilst .
  types:
    BEGIN OF ty_s_wrkctr_desc,
        arbpl TYPE crhd-arbpl,
        ktext TYPE crtx-ktext,
      END OF ty_s_wrkctr_desc .
  types:
    ty_t_wrkctr_desc TYPE TABLE OF ty_s_wrkctr_desc .

  data G_CONTAINER_NAME type CHAR45 read-only .
  data G_REPID type SY-REPID read-only .
  data G_DYNNR type SY-DYNNR read-only .
  data G_SPLITTER_CONT_TOP type ref to CL_GUI_CONTAINER read-only .
  data G_SPLITTER_CONT_BOTTOM type ref to CL_GUI_CONTAINER read-only .
  data G_CUST_CONTAINER type ref to CL_GUI_CUSTOM_CONTAINER read-only .
  data G_NODETAB type TREEV_NTAB read-only .
  data G_ITEMTAB type SRMITEMTAB read-only .
  data G_ALV_FCAT type LVC_T_FCAT read-only .
  data G_WRKCMPL_OBJ type ref to ZCL_PM_MRSWRK_COMPLIANCE read-only .
  data G_WRKPLNKPI type ref to ZCL_PM_MRSWRK_KPI read-only .
  data G_DISP_WRKCMPL type ZCL_PM_MRSWRK_COMPLIANCE=>TY_T_WRKCOMP read-only .
  data G_DISP_OPERKPI type ZCL_PM_MRSWRK_KPI=>TY_T_OPERKPI read-only .
  data G_DISP_ILAKPI type ZCL_PM_MRSWRK_KPI=>TY_T_ILAKPI read-only .
  data G_DISP_WKCTRKPI type ZCL_PM_MRSWRK_KPI=>TY_T_WCTRKPI read-only .
  data G_ALV_WRKCMPL type ref to CL_GUI_ALV_GRID read-only .
  data G_ALV_ILAKPI type ref to CL_GUI_ALV_GRID read-only .
  data G_ALV_WCTRKPI type ref to CL_GUI_ALV_GRID read-only .
  data G_ALV_OPERKPI type ref to CL_GUI_ALV_GRID read-only .
  data G_HTML_TAB type CL_ABAP_BROWSER=>HTML_TABLE read-only .
  data G_HTML_VIEWER type ref to CL_GUI_HTML_VIEWER read-only .
  data G_MRS_AVAIL type ref to ZCL_PM_MRS_AVAILABILITY read-only .
  data G_DISP_WKCTR_TA type TY_T_WKCTR_TA read-only .
  data G_DISP_WKCTR_AVAIL type TY_T_WKCTR_AVAIL read-only .
  data G_ALV_WKCTR_TA type ref to CL_GUI_ALV_GRID read-only .
  data G_ALV_WKCTR_AVAIL type ref to CL_GUI_ALV_GRID read-only .

  methods CONSTRUCTOR
    importing
      value(I_CONTAINER_NAME) type STRING optional
      value(I_REPID) type SYREPID
      value(I_DYNNR) type SYDYNNR
      value(I_SPLITTER) type BOOLE_D optional
      value(I_DOCK_SIDE) type I optional .
  methods BUILD_WKCTR_TREEHIER
    raising
      ZCX_PM_MRS_REPMGR .
  methods DISPLAY_WORKCMPL_OUTPUT
    importing
      !I_WRKCMPL_OBJ type ref to ZCL_PM_MRSWRK_COMPLIANCE .
  methods DISPLAY_PLNKPI_OUTPUT
    importing
      value(I_PLNKPI) type ref to ZCL_PM_MRSWRK_KPI
      value(I_KPISEL) type C default 'I'
      value(I_DISP_OPERKPI) type ZCL_PM_MRSWRK_KPI=>TY_T_OPERKPI optional .
  methods DISPLAY_AVAIL_SUMMARY
    importing
      !I_AVAIL type BOOLE_D
      !I_MRS_AVAIL type ref to ZCL_PM_MRS_AVAILABILITY .
  methods COMPLALV_DBLCLK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods ILAKPI_ALVDBLCLK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods WKCTRKPI_ALVDBLCLK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
protected section.

  methods HIERTREE_NODEDBLK
    for event NODE_DOUBLE_CLICK of CL_GUI_COLUMN_TREE
    importing
      !NODE_KEY .
  methods HIERTREE_ITEMDBLK
    for event ITEM_DOUBLE_CLICK of CL_GUI_COLUMN_TREE
    importing
      !NODE_KEY
      !ITEM_NAME .
  methods GET_TREE_HIER_LAYOUT
    importing
      value(I_CONTAINER) type ref to CL_GUI_CONTAINER
    exporting
      value(E_SIMP_TREE) type ref to CL_GUI_COLUMN_TREE
    raising
      zcx_pm_mrs_repmgr .
private section.

  methods KPI_COLUMN_CHART_DISPLAY
    importing
      !I_CONTAINER type ref to CL_GUI_CONTAINER
      !I_SCP_BNCH type VPKRATIO
      !I_ASG_BNCH type VPKRATIO
      !I_ACT_BNCH type VPKRATIO
      !I_ASG_SCP type VPKRATIO
      !I_ACT_SCP type VPKRATIO
      !I_ACT_ASG type VPKRATIO
      !I_TITLE type STRING .
  methods GET_HTML_COMPL_CHART
    importing
      value(IV_DAILY_COMPL) type I
      value(IV_WEEKLY_COMPL) type I
      value(IV_BREAKIN) type I .
  methods GET_HTML_KPI_CHART
    importing
      value(I_SCP_BNCH) type STRING
      value(I_ASG_BNCH) type STRING
      value(I_ACT_BNCH) type STRING
      value(I_ASG_SCP) type STRING
      value(I_ACT_SCP) type STRING
      value(I_ACT_ASG) type STRING
      value(I_TITLE) type STRING .
  methods GAUGE_CHART_DISPLAY
    importing
      !I_CONTAINER type ref to CL_GUI_CONTAINER .
  methods DISPLAY_TREEHIER
    importing
      !I_POS type C
    raising
      ZCX_PM_MRS_REPMGR .
  methods BUILD_WKCTR_NESTED
    importing
      value(I_WRKHIER) type ZCL_PM_MRSWRK_COMPLIANCE=>TY_T_CRHS
      value(I_NODE) type CRHD-ARBPL
      value(I_WRKCTR_DET) type RFC_WKC_DETAIL_TAB
      value(I_LEVEL) type I
    changing
      value(C_NODETAB) type TREEV_NTAB
      value(C_ITEMTAB) type SRMITEMTAB .
  methods SPLIT_LAYOUT_TOP_BOTTOM
    importing
      value(I_SIDE) type I optional
      value(I_SINGLE_ROW) type BOOLE_D optional .
  methods FILL_WRKCMPL_FCAT
    importing
      !I_STRUCNAME type DD02L-TABNAME .
  methods GET_ALV_FCAT
    importing
      value(I_STRUCNAME) type DD02L-TABNAME
    returning
      value(R_FCAT) type LVC_T_FCAT .
ENDCLASS.



CLASS ZCL_PM_MRSREP_UIMGR IMPLEMENTATION.


  METHOD BUILD_WKCTR_NESTED.

    CHECK i_level < 50.
*  Get the node internal id
    DATA(lv_node_id) = i_wrkctr_det[ workcenter_name = i_node ]-workcenter_id.

    LOOP AT i_wrkhier INTO DATA(ls_wrkhier) WHERE objid_up = lv_node_id.
      DATA(lv_wrkctr_name) = i_wrkctr_det[ workcenter_id = ls_wrkhier-objid_ho ]-workcenter_name.
      DATA(lv_wrkctr_desc) = i_wrkctr_det[ workcenter_id = ls_wrkhier-objid_ho ]-workcenter_desc.
      c_nodetab = VALUE #( BASE c_nodetab
                          ( node_key =  lv_wrkctr_name  hidden = ' ' disabled = ' ' isfolder = abap_true
                            relatkey = i_node relatship = cl_gui_column_tree=>relat_last_child  ) ).
      c_itemtab = VALUE #( BASE c_itemtab
                          ( node_key = lv_wrkctr_name item_name = 'ARBPL' class = cl_gui_column_tree=>item_class_text text = lv_wrkctr_name )
                          ( node_key = lv_wrkctr_name item_name = 'KTEXT' class = cl_gui_column_tree=>item_class_text text = lv_wrkctr_desc )
                          ).
      build_wkctr_nested( EXPORTING i_wrkhier = i_wrkhier i_node = lv_wrkctr_name i_wrkctr_det = i_wrkctr_det i_level = i_level + 1
                             CHANGING  c_nodetab = c_nodetab c_itemtab = c_itemtab ).
    ENDLOOP.


  ENDMETHOD.


  METHOD BUILD_WKCTR_TREEHIER.

    DATA: lt_wkctr_desc TYPE TABLE OF ty_s_wrkctr_desc.


* Build the tree node and item data using the wirk compliance data
    IF g_wrkcmpl_obj->g_wrkctr_hier IS INITIAL.
      lt_wkctr_desc = VALUE #( FOR GROUPS ls_wrkcomp_grp OF ls_wrkcmp IN g_wrkcmpl_obj->g_wrkcmpl
                                  GROUP BY ( wrkctr = ls_wrkcmp-arbpl desc = ls_wrkcmp-ktext )
                                  ( arbpl = ls_wrkcomp_grp-wrkctr ktext = ls_wrkcomp_grp-desc ) ).
      g_nodetab = VALUE treev_ntab( FOR ls_wkctr_desc IN lt_wkctr_desc
                          ( node_key = ls_wkctr_desc-arbpl hidden = ' ' disabled = ' ' isfolder = abap_true ) ).
      g_itemtab = VALUE srmitemtab( FOR ls_wkctr_desc IN lt_wkctr_desc
                          ( node_key = ls_wkctr_desc-arbpl item_name = 'ARBPL' class = cl_gui_column_tree=>item_class_text text = ls_wkctr_desc-arbpl )
                          ( node_key = ls_wkctr_desc-arbpl item_name = 'KTEXT' class = cl_gui_column_tree=>item_class_text text = ls_wkctr_desc-ktext )
                          ).
    ELSE.
*    USE THE first record as the root of the tree
      DATA(lv_wrkctr_name) = g_wrkcmpl_obj->g_wrkctr_det[ 1 ]-workcenter_name.
      DATA(lv_wrkctr_desc) = g_wrkcmpl_obj->g_wrkctr_det[ 1 ]-workcenter_desc.

      g_nodetab = VALUE #( ( node_key = lv_wrkctr_name hidden = ' ' disabled = ' ' isfolder = abap_true  ) ).
      g_itemtab = VALUE #( ( node_key = lv_wrkctr_name item_name = 'ARBPL' class = cl_gui_column_tree=>item_class_text text = lv_wrkctr_name )
                          ( node_key = lv_wrkctr_name item_name = 'KTEXT' class = cl_gui_column_tree=>item_class_text text = lv_wrkctr_desc )
                          ).
      build_wkctr_nested( EXPORTING i_wrkhier = g_wrkcmpl_obj->g_wrkctr_hier i_node = lv_wrkctr_name  i_level = 1
                                  i_wrkctr_det = g_wrkcmpl_obj->g_wrkctr_det
                       CHANGING  c_nodetab = g_nodetab c_itemtab = g_itemtab ).
    ENDIF.
  ENDMETHOD.


  METHOD COMPLALV_DBLCLK.
    CHECK line_exists( g_disp_wrkcmpl[ e_row-index ] ).
    CALL FUNCTION 'Z_PM_ORDLAUNCH' STARTING NEW TASK 'ZORD' DESTINATION 'NONE'
      EXPORTING
        iv_aufnr = g_disp_wrkcmpl[ e_row-index ]-aufnr.


  ENDMETHOD.


  METHOD CONSTRUCTOR.

    g_container_name = i_container_name.
    g_repid = i_repid.
    g_dynnr = i_dynnr.

    CREATE OBJECT g_cust_container
      EXPORTING
        container_name              =  g_container_name
*       style                       =
*       lifetime                    = lifetime_default
        repid                       = g_repid
        dynnr                       = g_dynnr
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.


    CHECK i_splitter EQ abap_true.
    split_layout_top_bottom( i_side = i_dock_side ).
  ENDMETHOD.


  METHOD display_avail_summary.

    IF i_mrs_avail IS NOT BOUND.
      RETURN.
    ENDIF.
    g_mrs_avail = i_mrs_avail.

    IF i_avail EQ abap_true.
*    Display the ALV Grid with Availability Summary
      g_disp_wkctr_avail = g_mrs_avail->g_wkctr_avail.
      CREATE OBJECT g_alv_wkctr_avail
        EXPORTING
          i_parent          = g_cust_container
        EXCEPTIONS
          error_cntl_create = 1
          error_cntl_init   = 2
          error_cntl_link   = 3
          error_dp_create   = 4
          OTHERS            = 5.
      IF sy-subrc <> 0.
        MESSAGE e029(zpmmc_mrswrk).
      ENDIF.

* assign event handlers in the application class to each desired event
      DATA(lt_fcat) = me->get_alv_fcat( EXPORTING i_strucname = 'ZPMSTWKCTR_AVAIL' ).
      CALL METHOD g_alv_wkctr_avail->set_table_for_first_display
        EXPORTING
          i_save                        = 'A'
          is_layout                     = VALUE #( zebra = abap_true cwidth_opt = abap_true sel_mode = 'D' )
        CHANGING
          it_outtab                     = g_disp_wkctr_avail
          it_fieldcatalog               = lt_fcat
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.
      IF sy-subrc <> 0.
        MESSAGE e029(zpmmc_mrswrk).
      ENDIF.
    ELSE.
*    Display the ALV Grid with UnAvailability Details
      g_disp_wkctr_ta = g_mrs_avail->g_wkctr_ta.
      CREATE OBJECT g_alv_wkctr_ta
        EXPORTING
          i_parent          = g_cust_container
        EXCEPTIONS
          error_cntl_create = 1
          error_cntl_init   = 2
          error_cntl_link   = 3
          error_dp_create   = 4
          OTHERS            = 5.
      IF sy-subrc <> 0.
        MESSAGE e029(zpmmc_mrswrk).
      ENDIF.

      lt_fcat = me->get_alv_fcat( EXPORTING i_strucname = 'ZPMSTWKCTR_TA' ).
      CALL METHOD g_alv_wkctr_ta->set_table_for_first_display
        EXPORTING
          i_save                        = 'A'
          is_layout                     = VALUE #( zebra = abap_true cwidth_opt = abap_true sel_mode = 'D' )
        CHANGING
          it_outtab                     = g_disp_wkctr_ta
          it_fieldcatalog               = lt_fcat
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.
      IF sy-subrc <> 0.
        MESSAGE e029(zpmmc_mrswrk).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD display_plnkpi_output.
    IF i_plnkpi IS  NOT BOUND.
      RETURN.
    ENDIF.

    g_wrkplnkpi = i_plnkpi.

* Display the KPI Groups and by operations
    CASE i_kpisel.
      WHEN 'I'.
*    Display the ALV Grid with Maint.Activity Summary
        g_disp_ilakpi = g_wrkplnkpi->g_ilawrk_kpi.
        CREATE OBJECT g_alv_ilakpi
          EXPORTING
            i_parent          = g_cust_container
          EXCEPTIONS
            error_cntl_create = 1
            error_cntl_init   = 2
            error_cntl_link   = 3
            error_dp_create   = 4
            OTHERS            = 5.
        IF sy-subrc <> 0.
          MESSAGE e029(zpmmc_mrswrk).
        ENDIF.

* assign event handlers in the application class to each desired event
        DATA(lt_fcat) = me->get_alv_fcat( EXPORTING i_strucname = 'ZPMSTOILAKPI' ).
        SET HANDLER me->ilakpi_alvdblclk  FOR g_alv_ilakpi.
        CALL METHOD g_alv_ilakpi->set_table_for_first_display
          EXPORTING
            i_save                        = 'A'
            is_layout                     = VALUE #( zebra = abap_true cwidth_opt = abap_true sel_mode = 'D' )
          CHANGING
            it_outtab                     = g_disp_ilakpi
            it_fieldcatalog               = lt_fcat
          EXCEPTIONS
            invalid_parameter_combination = 1
            program_error                 = 2
            too_many_lines                = 3
            OTHERS                        = 4.
        IF sy-subrc <> 0.
          MESSAGE e029(zpmmc_mrswrk).
        ENDIF.
      WHEN 'W'.
*    display the alv grid with work center summary
        g_disp_wkctrkpi = g_wrkplnkpi->g_wkctr_kpi.
        CREATE OBJECT g_alv_wctrkpi
          EXPORTING
            i_parent          = g_cust_container
          EXCEPTIONS
            error_cntl_create = 1
            error_cntl_init   = 2
            error_cntl_link   = 3
            error_dp_create   = 4
            OTHERS            = 5.
        IF sy-subrc <> 0.
          MESSAGE e029(zpmmc_mrswrk).
        ENDIF.

* assign event handlers in the application class to each desired event
        lt_fcat = me->get_alv_fcat( EXPORTING i_strucname = 'ZPMSTOWCTRKPI' ).
        SET HANDLER me->wkctrkpi_alvdblclk  FOR g_alv_wctrkpi.
        CALL METHOD g_alv_wctrkpi->set_table_for_first_display
          EXPORTING
            i_save                        = 'A'
            is_layout                     = VALUE #( zebra = abap_true cwidth_opt = abap_true sel_mode = 'D' )
          CHANGING
            it_outtab                     = g_disp_wkctrkpi
            it_fieldcatalog               = lt_fcat
          EXCEPTIONS
            invalid_parameter_combination = 1
            program_error                 = 2
            too_many_lines                = 3
            OTHERS                        = 4.
        IF sy-subrc <> 0.
          MESSAGE e029(zpmmc_mrswrk).
        ENDIF.
      WHEN 'O'.
*    Display the ALV Grid with invidiual oepration KPIs
        lt_fcat = me->get_alv_fcat( EXPORTING i_strucname = 'ZPMSTOPERKPI' ).
        g_disp_operkpi = i_disp_operkpi.

        IF g_alv_operkpi IS NOT BOUND.
          CREATE OBJECT g_alv_operkpi
            EXPORTING
              i_parent          = g_cust_container
            EXCEPTIONS
              error_cntl_create = 1
              error_cntl_init   = 2
              error_cntl_link   = 3
              error_dp_create   = 4
              OTHERS            = 5.
          IF sy-subrc <> 0.
            MESSAGE e029(zpmmc_mrswrk).
          ENDIF.

* assign event handlers in the application class to each desired event
          CALL METHOD g_alv_operkpi->set_table_for_first_display
            EXPORTING
              i_save                        = 'A'
              is_layout                     = VALUE #( zebra = abap_true cwidth_opt = abap_true )
            CHANGING
              it_outtab                     = g_disp_operkpi
              it_fieldcatalog               = lt_fcat
            EXCEPTIONS
              invalid_parameter_combination = 1
              program_error                 = 2
              too_many_lines                = 3
              OTHERS                        = 4.
          IF sy-subrc <> 0.
            MESSAGE e029(zpmmc_mrswrk).
          ENDIF.

        ELSE.
          g_alv_operkpi->refresh_table_display( ).
        ENDIF.

      WHEN OTHERS.
        MESSAGE e029(zpmmc_mrswrk).
    ENDCASE.

    CHECK i_kpisel EQ 'I' OR i_kpisel EQ 'W'."Split the screen with docking container and display the column chart
    split_layout_top_bottom( i_side = cl_gui_docking_container=>dock_at_top i_single_row = abap_true ).
    CASE i_kpisel.
      WHEN 'I'. ilakpi_alvdblclk( EXPORTING e_row = VALUE #( index = 1 ) ).
      WHEN 'W'. wkctrkpi_alvdblclk( EXPORTING e_row = VALUE #( index = 1 ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD DISPLAY_TREEHIER.

    DATA: ls_event  TYPE cntl_simple_event,
          lt_events TYPE cntl_simple_events.


    IF g_nodetab[] IS INITIAL OR g_itemtab[] IS INITIAL."Have to be already built for display
      MESSAGE e030(zpmmc_mrswrk).
    ENDIF.

    get_tree_hier_layout( EXPORTING
                          i_container = SWITCH #( i_pos WHEN 'T' THEN g_splitter_cont_top WHEN 'B' THEN g_splitter_cont_bottom ELSE g_cust_container )
                          IMPORTING e_simp_tree = DATA(lo_simp_tree) ).


* define the events which will be passed to the backend
    " node double click
    ls_event-eventid = cl_gui_column_tree=>eventid_node_double_click.
    ls_event-appl_event = abap_true. " process PAI if event occurs
    APPEND ls_event TO lt_events.

    " item double click
    ls_event-eventid = cl_gui_column_tree=>eventid_item_double_click.
    ls_event-appl_event = abap_true.
    APPEND ls_event TO lt_events.

    CALL METHOD lo_simp_tree->set_registered_events
      EXPORTING
        events                    = lt_events
      EXCEPTIONS
        cntl_error                = 1
        cntl_system_error         = 2
        illegal_event_combination = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


* assign event handlers in the application class to each desired event
    SET HANDLER me->hiertree_nodedblk  FOR lo_simp_tree.
    SET HANDLER me->hiertree_itemdblk  FOR lo_simp_tree.


    CALL METHOD lo_simp_tree->add_nodes_and_items
      EXPORTING
        node_table                     = g_nodetab
        item_table                     = g_itemtab
        item_table_structure_name      = 'MTREEITM'
      EXCEPTIONS
        failed                         = 1
        cntl_system_error              = 3
        error_in_tables                = 4
        dp_error                       = 5
        table_structure_name_not_found = 6.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.

* expand the node with key 'Root'
    CALL METHOD lo_simp_tree->expand_node
      EXPORTING
        node_key            = g_nodetab[ 1 ]-node_key
        expand_subtree      = abap_true
      EXCEPTIONS
        failed              = 1
        illegal_level_count = 2
        cntl_system_error   = 3
        node_not_found      = 4
        cannot_expand_leaf  = 5.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.

  ENDMETHOD.


  METHOD display_workcmpl_output.

    IF i_wrkcmpl_obj IS NOT BOUND.
      RETURN.
    ENDIF.

    g_wrkcmpl_obj = i_wrkcmpl_obj.
    build_wkctr_treehier( ).
    fill_wrkcmpl_fcat( EXPORTING i_strucname = 'ZPMSTWRKCOMPL' ).

* Display the Work Center Tree Hierarchy
    display_treehier( i_pos = 'F' ).
    g_disp_wrkcmpl = g_wrkcmpl_obj->g_wrkcmpl[].

*    Display the ALV Grid with operation info
    CREATE OBJECT g_alv_wrkcmpl
      EXPORTING
*       i_lifetime        =
        i_parent          = g_splitter_cont_bottom
*       i_name            =
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.

* assign event handlers in the application class to each desired event
    SET HANDLER me->complalv_dblclk  FOR g_alv_wrkcmpl.
    CALL METHOD g_alv_wrkcmpl->set_table_for_first_display
      EXPORTING
        i_save                        = 'A'
        is_layout                     = VALUE #( zebra = abap_true cwidth_opt = abap_true )
      CHANGING
        it_outtab                     = g_disp_wrkcmpl
        it_fieldcatalog               = g_alv_fcat
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.

    gauge_chart_display( i_container = g_splitter_cont_top ).

  ENDMETHOD.


  METHOD FILL_WRKCMPL_FCAT.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = i_strucname
      CHANGING
        ct_fieldcat            = g_alv_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.

    LOOP AT g_alv_fcat ASSIGNING FIELD-SYMBOL(<ls_alv_fcat>).
      CASE <ls_alv_fcat>-fieldname.
        WHEN  'ARBPL' or 'KTEXT' or 'ARBID' or 'WERKS'. <ls_alv_fcat>-no_out = abap_true.
        WHEN 'VORNR' OR 'SSEDD' OR 'DAYCOMP' OR 'WEEKCOMP' or 'IEDD' or 'SCHIND' or 'ORDTXT' or 'LTXA1'. <ls_alv_fcat>-colddictxt = 'L'.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD gauge_chart_display.

* Calculate the gauge value based on the current work compliance output
    DATA: lv_url          TYPE c LENGTH 1024,
          lv_schd_compl   TYPE int2,
          lv_daily_compl  TYPE vpkratio,
          lv_weekly_compl TYPE vpkratio,
          lv_opercnf      TYPE int2,
          lv_breakin      TYPE vpkratio.

    LOOP AT g_disp_wrkcmpl INTO DATA(ls_compl).
      IF ls_compl-schind EQ 'SCHEDULED'.
        lv_schd_compl = lv_schd_compl + 1.

        IF ls_compl-daycomp EQ zcl_pm_mrswrk_compliance=>g_comstat_compliant .
          lv_daily_compl = lv_daily_compl + 1.
        ENDIF.

        IF ls_compl-weekcomp EQ zcl_pm_mrswrk_compliance=>g_comstat_compliant.
          lv_weekly_compl = lv_weekly_compl + 1.
        ENDIF.
      ENDIF.

      IF ls_compl-iedd IS NOT INITIAL.
        lv_opercnf = lv_opercnf + 1.
      ENDIF.

      IF ls_compl-daycomp EQ zcl_pm_mrswrk_compliance=>g_comstat_breakin.
        lv_breakin = lv_breakin + 1.
      ENDIF.
    ENDLOOP.

*      Get Daily and Weekly compliant based on shcd operations
    IF lv_schd_compl IS NOT INITIAL.
      lv_daily_compl = lv_daily_compl / lv_schd_compl * 100.
      lv_weekly_compl = lv_weekly_compl / lv_schd_compl * 100.
    ELSE.
      CLEAR: lv_daily_compl, lv_weekly_compl.
    ENDIF.

    IF lv_opercnf IS NOT INITIAL.
      lv_breakin = lv_breakin / lv_opercnf * 100.
    ENDIF.

    get_html_compl_chart( iv_daily_compl = CONV #( lv_daily_compl ) iv_weekly_compl = CONV #( lv_weekly_compl ) iv_breakin = CONV #( lv_breakin ) ).

*    Display Compliance Gauge
    IF g_html_viewer IS  BOUND.
      g_html_viewer->free( ).
      CLEAR g_html_viewer.
    ENDIF.

    g_html_viewer = NEW cl_gui_html_viewer( parent = i_container uiflag = cl_gui_html_viewer=>uiflag_noiemenu ).
    g_html_viewer->load_data(
     IMPORTING
       assigned_url = lv_url
     CHANGING
       data_table   =  g_html_tab ).

    g_html_viewer->show_url( EXPORTING url = lv_url ).

  ENDMETHOD.


  METHOD get_alv_fcat.

    DATA: lv_fldcnt TYPE i.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = i_strucname
      CHANGING
        ct_fieldcat            = r_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.

    LOOP AT r_fcat ASSIGNING FIELD-SYMBOL(<ls_alv_fcat>).
      <ls_alv_fcat>-no_out = COND #( WHEN i_strucname EQ 'ZPMSTWRKCOMPL'
                                      AND ( <ls_alv_fcat>-fieldname EQ 'ARBPL' OR <ls_alv_fcat>-fieldname EQ 'KTEXT' OR
                                            <ls_alv_fcat>-fieldname EQ 'ARBID' OR <ls_alv_fcat>-fieldname EQ 'WERKS' ) THEN abap_true
                                     WHEN i_strucname EQ 'ZPMSTOPERKPI'
                                     AND ( <ls_alv_fcat>-fieldname EQ 'ILART' OR <ls_alv_fcat>-fieldname EQ 'ILATX' OR
                                            <ls_alv_fcat>-fieldname EQ 'WORKCENTER' OR <ls_alv_fcat>-fieldname EQ 'WORKCENTERTEXT' ) THEN abap_true
                                     ELSE <ls_alv_fcat>-no_out ).
      <ls_alv_fcat>-colddictxt = COND #( WHEN ( <ls_alv_fcat>-fieldname EQ  'VORNR'
                                          AND ( i_strucname EQ 'ZPMSTWRKCOMPL'  OR i_strucname EQ 'ZPMSTOPERKPI' ) )
                                          OR ( <ls_alv_fcat>-fieldname EQ 'BNCHMRK' OR <ls_alv_fcat>-fieldname EQ 'SCOPE' OR
                                              <ls_alv_fcat>-fieldname EQ 'ASGND' OR <ls_alv_fcat>-fieldname EQ 'ACTUAL' OR
                                              <ls_alv_fcat>-fieldname EQ 'SCP_BNCH' OR <ls_alv_fcat>-fieldname EQ 'ASG_BNCH' OR
                                              <ls_alv_fcat>-fieldname EQ 'ACT_BNCH' OR <ls_alv_fcat>-fieldname EQ 'ASG_SCP' OR
                                              <ls_alv_fcat>-fieldname EQ 'ACT_SCP' OR <ls_alv_fcat>-fieldname EQ 'ACT_ASG' OR
                                              <ls_alv_fcat>-fieldname EQ 'KAPAH' OR <ls_alv_fcat>-fieldname EQ 'ASGND' OR
                                              <ls_alv_fcat>-fieldname EQ 'ALLOC' OR <ls_alv_fcat>-fieldname EQ 'REMAIN'  )
                                          THEN 'L'
                                         ELSE <ls_alv_fcat>-colddictxt ).
      <ls_alv_fcat>-fix_column = COND #( WHEN i_strucname EQ 'ZPMSTOILAKPI'
                                          AND ( <ls_alv_fcat>-fieldname EQ 'ILART' OR <ls_alv_fcat>-fieldname EQ 'ILATX' ) THEN abap_true
                                        WHEN i_strucname EQ 'ZPMSTOWCTRKPI'
                                          AND ( <ls_alv_fcat>-fieldname EQ 'WORKCENTER' OR <ls_alv_fcat>-fieldname EQ 'WORKCENTERTEXT' ) THEN abap_true
                                        ELSE <ls_alv_fcat>-fix_column ).

*      Get the field label
      IF <ls_alv_fcat>-fieldname CP 'MON+_DUR' or <ls_alv_fcat>-fieldname cp 'MON++_DUR'.
        CLEAR lv_fldcnt.
        IF <ls_alv_fcat>-fieldname CP 'MON+_DUR'.
          lv_fldcnt = <ls_alv_fcat>-fieldname+3(1).
        else.
          lv_fldcnt = <ls_alv_fcat>-fieldname+3(2).
        ENDIF.

        IF lv_fldcnt GT lines( g_mrs_avail->g_monfld ).
          <ls_alv_fcat>-no_out = abap_true.
        ELSE.
          TRY .
              DATA(lv_monyr) = g_mrs_avail->g_monfld[ lv_fldcnt ]-monyr.
              DATA(lv_mon_short) = SWITCH string( lv_monyr+4(2) WHEN '01' THEN 'Jan.' WHEN '02' THEN 'Feb.' WHEN '03' THEN 'Mar.'
                                                                WHEN '04' THEN 'Apr.' WHEN '05' THEN 'May.' WHEN '06' THEN 'Jun.'
                                                                WHEN '07' THEN 'Jul.' WHEN '08' THEN 'Aug.' WHEN '09' THEN 'Sep.'
                                                                WHEN '10' THEN 'Oct.' WHEN '11' THEN 'Nov.' WHEN '12' THEN 'Dec.' ).
              <ls_alv_fcat>-reptext = <ls_alv_fcat>-scrtext_s = <ls_alv_fcat>-scrtext_l = <ls_alv_fcat>-scrtext_m =  lv_mon_short && lv_monyr(4).
            CATCH cx_sy_itab_line_not_found.
              <ls_alv_fcat>-scrtext_l = <ls_alv_fcat>-scrtext_m = 'Duration in Hours'.
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD GET_HTML_COMPL_CHART.

    DATA: lt_tline TYPE TABLE OF tline,
          lv_repl  TYPE          string.

    REFRESH: g_html_tab.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'
        language                = sy-langu
        name                    = 'ZPMWRKCOMPLGAUGE'
        object                  = 'TEXT'
      TABLES
        lines                   = lt_tline
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0."Use the default from the below code instead of standard text
      APPEND '<html><head><script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>' TO g_html_tab.
      APPEND '<script type="text/javascript"> google.charts.load(''current'', {''packages'':[''gauge'']});' TO g_html_tab.
      APPEND 'google.charts.setOnLoadCallback(drawChart); function drawChart() {' TO g_html_tab.
*    Fill chart data
      APPEND 'var data1 = google.visualization.arrayToDataTable([ [''%''],[ ' && iv_daily_compl && '] ]);' TO g_html_tab.
      APPEND 'var data2 = google.visualization.arrayToDataTable([ [''%''],[ ' && iv_weekly_compl && '] ]);' TO g_html_tab.
      APPEND 'var data3 = google.visualization.arrayToDataTable([ [''%''],[ ' && iv_breakin && '] ]);' TO g_html_tab.
* Fill chart options
      APPEND 'var options1 = { width: 400, height: 200, greenFrom: 90, greenTo: 100, yellowFrom:75, yellowTo: 90, minorTicks: 5 };' TO g_html_tab.
      APPEND 'var options2 = { width: 400, height: 200, redFrom: 90, redTo: 100, yellowFrom:75, yellowTo: 90, minorTicks: 5 };' TO g_html_tab.
      APPEND 'var chart1 = new google.visualization.Gauge(document.getElementById(''chart1_div'')); ' TO g_html_tab.
      APPEND 'var chart2 = new google.visualization.Gauge(document.getElementById(''chart2_div'')); ' TO g_html_tab.
      APPEND 'var chart3 = new google.visualization.Gauge(document.getElementById(''chart3_div'')); ' TO g_html_tab.
      APPEND 'chart1.draw(data1, options1); chart2.draw(data2, options1); chart3.draw(data3, options2);'  TO g_html_tab.
      APPEND '  } </script>  </head>' TO g_html_tab.
      APPEND '<body><div id ="table_layo" style="width: 400px; height: 200px;"><table><tr>' TO g_html_tab.
      APPEND '<td style="width: 250px; height: 250px;">' to g_html_tab.
      APPEND '<h3 style="text-align:center">Daily Compliance</h3><div id="chart1_div"></div></td>' TO g_html_tab.
      APPEND '<td style="width: 250px; height: 250px;">' to g_html_tab.
      APPEND '<h3 style="text-align:center">Weekly Compliance</h3><div id="chart2_div"></div></td>' TO g_html_tab.
      APPEND '<td style="width: 250px; height: 250px;">' to g_html_tab.
      APPEND '<h3 style="text-align:center">Break-in Work</h3><div id="chart3_div" ></div></td>' TO g_html_tab.
      APPEND '</tr></table></div></body> </html>' TO g_html_tab.
      RETURN.
    ENDIF.

    g_html_tab = VALUE #( FOR ls_tline IN lt_tline ( ls_tline-tdline ) ).
    REPLACE ALL OCCURRENCES OF '&&DAY&&' IN TABLE g_html_tab WITH CONV char10( iv_daily_compl ).
    REPLACE ALL OCCURRENCES OF '&&WEEK&&' IN TABLE g_html_tab WITH CONV char10( iv_weekly_compl ).
    REPLACE ALL OCCURRENCES OF '&&BREAK&&' IN TABLE g_html_tab WITH CONV char10( iv_breakin ).

  ENDMETHOD.


  METHOD get_html_kpi_chart.

    DATA: lt_tline TYPE TABLE OF tline,
          lv_repl  TYPE          string.

    REFRESH: g_html_tab.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'
        language                = sy-langu
        name                    = 'ZPMKPICOLUMN'
        object                  = 'TEXT'
      TABLES
        lines                   = lt_tline
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0."Use the default from the below code instead of standard text
      MESSAGE w031(zpmmc_mrswrk).
      RETURN.
    ENDIF.

    g_html_tab = VALUE #( FOR ls_tline IN lt_tline ( ls_tline-tdline ) ).

    REPLACE ALL OCCURRENCES OF '&&SCP_BNCH&&' IN TABLE g_html_tab WITH i_scp_bnch.
    REPLACE ALL OCCURRENCES OF '&&ASGND_BNCH&&' IN TABLE g_html_tab WITH i_asg_bnch.
    REPLACE ALL OCCURRENCES OF '&&ACT_BNCH&&' IN TABLE g_html_tab WITH  i_act_bnch.
    REPLACE ALL OCCURRENCES OF '&&ASGND_SCP&&' IN TABLE g_html_tab WITH i_asg_scp.
    REPLACE ALL OCCURRENCES OF '&&ACT_SCP&&' IN TABLE g_html_tab WITH i_act_scp.
    REPLACE ALL OCCURRENCES OF '&&ACT_ASGND&& ' IN TABLE g_html_tab WITH i_act_asg.
    REPLACE ALL OCCURRENCES OF '&&TITLE&& ' IN TABLE g_html_tab WITH i_title.
  ENDMETHOD.


  METHOD GET_TREE_HIER_LAYOUT.

    CREATE OBJECT e_simp_tree
      EXPORTING
*       lifetime                    =
        parent                      = i_container
        node_selection_mode         = cl_gui_column_tree=>node_sel_mode_single
        item_selection              = abap_true
        hierarchy_column_name       = 'ARBPL'
        hierarchy_header            = VALUE #( heading = TEXT-001 width = 40 )
*       name                        =
      EXCEPTIONS
        lifetime_error              = 1
        cntl_system_error           = 2
        create_error                = 3
        illegal_node_selection_mode = 4
        failed                      = 5
        illegal_column_name         = 6
        OTHERS                      = 7.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.

* Column2
    CALL METHOD e_simp_tree->add_column
      EXPORTING
        name                         = 'KTEXT'
        width                        = 40
        header_text                  = TEXT-003
      EXCEPTIONS
        column_exists                = 1
        illegal_column_name          = 2
        too_many_columns             = 3
        illegal_alignment            = 4
        different_column_types       = 5
        cntl_system_error            = 6
        failed                       = 7
        predecessor_column_not_found = 8.
    IF sy-subrc <> 0.
      MESSAGE e029(zpmmc_mrswrk).
    ENDIF.


  ENDMETHOD.


  METHOD hiertree_itemdblk.

    DATA: lt_rng_arbid TYPE RANGE OF crhd-objid,
          lt_rng_sel   TYPE RANGE OF crhd-objid,
          lt_nodeid    TYPE TABLE OF crhd-objid.

    g_disp_wrkcmpl = g_wrkcmpl_obj->g_wrkcmpl[].
    IF g_wrkcmpl_obj->g_wrkctr_hier[] IS INITIAL."No Hierarchy selected
      DELETE g_disp_wrkcmpl WHERE arbpl NE node_key.
    ELSE."REsult is based on work center hierarchy. Accumulate all the records that sit undert the selected node
      TRY .
          APPEND g_wrkcmpl_obj->g_wrkctr_det[ workcenter_name = node_key ]-workcenter_id TO lt_nodeid.

          DO 50 TIMES." Max 50 levels
            lt_rng_sel = VALUE #( FOR ls_node IN   lt_nodeid ( sign = 'I' option = 'EQ' low = ls_node ) ).
            APPEND LINES OF lt_rng_sel TO lt_rng_arbid.
            REFRESH : lt_nodeid.

            LOOP AT g_wrkcmpl_obj->g_wrkctr_hier INTO DATA(ls_hier) WHERE objid_up IN lt_rng_sel.
              APPEND ls_hier-objid_ho TO lt_nodeid.
            ENDLOOP.
            IF sy-subrc IS NOT INITIAL OR lt_nodeid[] IS INITIAL.
              EXIT.
            ENDIF.
          ENDDO.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
      DELETE g_disp_wrkcmpl WHERE arbid NOT IN lt_rng_arbid.
    ENDIF.

    g_alv_wrkcmpl->refresh_table_display( ).
    gauge_chart_display( i_container = g_splitter_cont_top ).
  ENDMETHOD.


  method HIERTREE_NODEDBLK.
  endmethod.


  METHOD ilakpi_alvdblclk.
    CHECK line_exists( g_disp_ilakpi[ e_row-index ] ).
    DATA(ls_ilakpi) = g_disp_ilakpi[ e_row-index ].

    TRY .
        CONCATENATE ls_ilakpi-ilart ' - ' ls_ilakpi-ilatx INTO DATA(lv_title) RESPECTING BLANKS.
        kpi_column_chart_display( EXPORTING i_container = g_splitter_cont_top
          i_title =   lv_title
          i_scp_bnch = ls_ilakpi-scp_bnch         i_asg_bnch = ls_ilakpi-asg_bnch        i_act_bnch = ls_ilakpi-act_bnch
          i_asg_scp  = ls_ilakpi-asg_scp        i_act_scp  = ls_ilakpi-act_scp         i_act_asg  = ls_ilakpi-act_asg ).
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.


  METHOD kpi_column_chart_display.

* Calculate the gauge value based on the current work compliance output
    DATA: lv_url          TYPE c LENGTH 1024.

    CALL METHOD me->get_html_kpi_chart
      EXPORTING
        i_scp_bnch = conv #( i_scp_bnch )
        i_asg_bnch = conv #( i_asg_bnch )
        i_act_bnch = conv #( i_act_bnch )
        i_asg_scp  = conv #( i_asg_scp )
        i_act_scp  = conv #( i_act_scp )
        i_act_asg  = conv #( i_act_asg )
        i_title    = i_title.

*    Display Compliance Gauge
    IF g_html_viewer IS  BOUND.
      g_html_viewer->free( ).
      CLEAR g_html_viewer.
    ENDIF.

    g_html_viewer = NEW cl_gui_html_viewer( parent = i_container uiflag = cl_gui_html_viewer=>uiflag_noiemenu ).
    g_html_viewer->load_data(
     IMPORTING
       assigned_url = lv_url
     CHANGING
       data_table   =  g_html_tab ).

    g_html_viewer->show_url( EXPORTING url = lv_url ).

  ENDMETHOD.


  METHOD split_layout_top_bottom.

    DATA lo_docking  TYPE REF TO cl_gui_docking_container.
    DATA lo_splitter TYPE REF TO cl_gui_splitter_container.

* create a docking container
    CREATE OBJECT lo_docking
      EXPORTING
        repid = g_repid
        dynnr = g_dynnr
        side  = COND #( WHEN i_side IS NOT INITIAL THEN i_side ELSE cl_gui_docking_container=>dock_at_right )
*       extension = 300
        ratio = COND #( WHEN i_single_row EQ abap_true THEN 45 ELSE 72 ).

* create a splitter container
    CREATE OBJECT lo_splitter
      EXPORTING
        parent  = lo_docking
        rows    = COND #( WHEN i_single_row EQ abap_true THEN 1 ELSE 2 )
        columns = 1.

* set border (splitter)
    CALL METHOD lo_splitter->set_border
      EXPORTING
        border = space.               "gfw_false.

* set column mode (splitter)
    CALL METHOD lo_splitter->set_column_mode
      EXPORTING
        mode = lo_splitter->mode_absolute.

* set column width (splitter)
    IF i_side IS INITIAL.
      CALL METHOD lo_splitter->set_column_width
        EXPORTING
          id                = 1
          width             = 200
        EXCEPTIONS
          cntl_error        = 1
          cntl_system_error = 2
          OTHERS            = 3.
      IF sy-subrc <> 0.
        MESSAGE e029(zpmmc_mrswrk).
      ENDIF.
    ENDIF.


    CALL METHOD lo_splitter->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = g_splitter_cont_top.

    CHECK i_single_row EQ abap_false.
    CALL METHOD lo_splitter->get_container
      EXPORTING
        row       = 2
        column    = 1
      RECEIVING
        container = g_splitter_cont_bottom.
  ENDMETHOD.


  METHOD wkctrkpi_alvdblclk.
    CHECK line_exists( g_disp_wkctrkpi[ e_row ] ).
    DATA(ls_wkctrapi) = g_disp_wkctrkpi[ e_row ].
    TRY .
        CONCATENATE ls_wkctrapi-workcenter ' - ' ls_wkctrapi-workcentertext INTO DATA(lv_title) RESPECTING BLANKS.
        kpi_column_chart_display( EXPORTING i_container = g_splitter_cont_top
          i_title =  lv_title
          i_scp_bnch = ls_wkctrapi-scp_bnch         i_asg_bnch = ls_wkctrapi-asg_bnch        i_act_bnch = ls_wkctrapi-act_bnch
          i_asg_scp  = ls_wkctrapi-asg_scp        i_act_scp  = ls_wkctrapi-act_scp         i_act_asg  = ls_wkctrapi-act_asg ).
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
