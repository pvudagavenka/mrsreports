FUNCTION z_pm_ordsch_snapshot_save.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_HEADER) TYPE  ZPMTTSNAPSHOT OPTIONAL
*"     VALUE(I_HEADER_DEL) TYPE  ZPMTTSNAPSHOT OPTIONAL
*"     VALUE(I_ORDSCH) TYPE  ZPMTY_SNAP_ORDSCH OPTIONAL
*"     VALUE(I_ORDSCH_DEL) TYPE  ZPMTY_SNAP_ORDSCH OPTIONAL
*"----------------------------------------------------------------------

IF i_header_del IS NOT INITIAL.
  DELETE zpmttsnapshot FROM i_header_del.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE a014(zpmmc_mrswrk).
  ENDIF.
ENDIF.

IF i_header IS NOT INITIAL.
  MODIFY zpmttsnapshot FROM i_header.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE a014(zpmmc_mrswrk).
  ENDIF.
ENDIF.

IF i_ordsch_del[] IS NOT INITIAL.
  DELETE zpmttsnap_wrk FROM TABLE i_ordsch_del.
    IF sy-subrc IS NOT INITIAL.
    MESSAGE a015(zpmmc_mrswrk).
  ENDIF.
ENDIF.

IF i_ordsch[] IS NOT INITIAL.
  INSERT zpmttsnap_wrk FROM TABLE i_ordsch.
    IF sy-subrc IS NOT INITIAL.
    MESSAGE a015(zpmmc_mrswrk).
  ENDIF.
ENDIF.
ENDFUNCTION.
