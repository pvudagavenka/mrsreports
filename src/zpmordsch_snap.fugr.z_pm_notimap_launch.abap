FUNCTION z_pm_notimap_launch.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_AUFNR) TYPE  AUFNR
*"----------------------------------------------------------------------

  DATA: l_abs_url TYPE c LENGTH 1024.

*  Check if the latitude and longitude details are maintained for the notifications
*  Check if the Google maps Javascript API key is available

*  Get the BSP application URL
  CALL METHOD cl_http_ext_webapp=>create_url_for_bsp_application
    EXPORTING
*     bsp_protocol         =
*     bsp_service          =
      bsp_application      = 'ZTEST_MAP'
      bsp_start_page       = 'main.htm'
      bsp_start_parameters = VALUE #(
                                       ( name = 'sap-client' value = sy-mandt )
                                       ( name = 'ORDER' value = i_aufnr )
                                       "( Name = 'sap-sessioncmd' value = 'open' )
                                        )
    IMPORTING
      local_url            = DATA(l_loc_url)
      abs_url              = DATA(l_url)
*     host                 =
*     port                 =
*     protocol             =
    .
*
  CHECK l_url IS NOT INITIAL.
  l_abs_url = l_url.
  CALL FUNCTION 'CALL_BROWSER'
    EXPORTING
      url                    = l_abs_url
*     WINDOW_NAME            = ' '
      new_window             = 'X'
*     BROWSER_TYPE           =
*     CONTEXTSTRING          =
    EXCEPTIONS
      frontend_not_supported = 1
      frontend_error         = 2
      prog_not_found         = 3
      no_batch               = 4
      unspecified_error      = 5
      OTHERS                 = 6.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFUNCTION.
