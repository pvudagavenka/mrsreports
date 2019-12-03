*&---------------------------------------------------------------------*
*& Include          ZXWOCU13
*&---------------------------------------------------------------------*

CHECK actyp EQ 'V' AND afvgd_imp-usr04 IS NOT INITIAL. "Change mode
IF afvgd_imp-use04 IS INITIAL.
  MESSAGE e026(zpmmc_mrswrk) WITH afvgd_imp-vornr.
ELSE.
  IF NOT ( afvgd_imp-use04 EQ 'H' OR afvgd_imp-use04 EQ '10' ).
    MESSAGE e027(zpmmc_mrswrk) WITH afvgd_imp-use04.
  ENDIF.
ENDIF.
