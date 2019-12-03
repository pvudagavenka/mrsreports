@AbapCatalog.sqlViewName: 'ZPMVICNFOPR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'MRS Confirmed Operations'
define view ZPMVI_CONFOPER as select from afru
inner join aufk on afru.aufnr = aufk.aufnr
{

    afru.aufnr as orderno,
    aplzl as oper_counter,
    vornr as operation,
    max(iedd)  as actual_conf
    
}where autyp = '30' group by afru.aufnr, aplzl, vornr
