@AbapCatalog.sqlViewName: 'ZPMVICOMLOP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'MRS Compliance Operations'
define view ZPMVI_COMLOPER as select from ZPMVI_CONFOPER
inner join zpmttsnap_wrk on (ZPMVI_CONFOPER.orderno = zpmttsnap_wrk.aufnr 
  and ZPMVI_CONFOPER.oper_counter = zpmttsnap_wrk.aplzl)
   {
    orderno,
    oper_counter,
    operation,
    'X' as schd_ind,
    ssedd as latest_finish,
    actual_conf    
}
