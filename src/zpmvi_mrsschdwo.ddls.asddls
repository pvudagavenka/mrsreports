@AbapCatalog.sqlViewName: 'ZPMVISCHWO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'MRS Scheduled Work Orders'
define view ZPMVI_MRSSCHDWO 
with parameters
p_schd : j_estat,
p_lang : abap.lang
as select from aufk 
inner join afko  on aufk.aufnr = afko.aufnr
inner join afvc  on afko.aufpl = afvc.aufpl
inner join afvv  on afvc.aufpl = afvv.aufpl and afvc.aplzl = afvv.aplzl
inner join jsto  on aufk.objnr = jsto.objnr
inner join tj30t on jsto.stsma = tj30t.stsma and spras = $parameters.p_lang and tj30t.txt04 = $parameters.p_schd
inner join jest  on aufk.objnr = jest.objnr and jest.stat = tj30t.estat {
    
    key aufk.aufnr as orderno,
    key afvc.aplzl as oper_counter,
    aufk.objnr as ord_objnr,
    afvc.objnr as oper_objnr,
    vornr      as operation ,
    ssedd      as latest_finish
    
} where autyp = '30' and inact = ''
