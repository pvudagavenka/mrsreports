CLASS zcl_zmrs_dashboard_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zmrs_dashboard_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ts_section_deep,
        row_id             TYPE string,
        section_operallocs TYPE STANDARD TABLE OF ts_operalloc WITH DEFAULT KEY,
      END OF ts_section_deep .
    TYPES:
      BEGIN OF ts_dailyview_deep,
        seldatefrom        TYPE timestamp,
        seldateto          TYPE timestamp,
        selfilters         TYPE string,
        dailyview_sections TYPE STANDARD TABLE OF ts_section_deep WITH DEFAULT KEY,
      END OF ts_dailyview_deep .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZMRS_DASHBOARD_MPC_EXT IMPLEMENTATION.
ENDCLASS.
