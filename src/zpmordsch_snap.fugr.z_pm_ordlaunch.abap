FUNCTION z_pm_ordlaunch.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_AUFNR) TYPE  AUFNR
*"----------------------------------------------------------------------


*       authority check
  CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
    EXPORTING
      tcode  = 'IW33'
    EXCEPTIONS
      ok     = 1
      not_ok = 2
      OTHERS = 3.
  IF sy-subrc <> 1.
    MESSAGE e147(/mrss/sgu) WITH 'IW33'.
  ENDIF.

  SET PARAMETER ID 'ANR' FIELD iv_aufnr.
  CALL TRANSACTION 'IW33' AND SKIP FIRST SCREEN.



ENDFUNCTION.
