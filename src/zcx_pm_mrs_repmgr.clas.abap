class ZCX_PM_MRS_REPMGR definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of START_DATE_BLANK,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '006',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of START_DATE_BLANK .
  constants:
    begin of END_DATE_BLANK,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '007',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of END_DATE_BLANK .
  constants:
    begin of INVALID_START_DATE,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '008',
      attr1 type scx_attrname value 'G_BEGDA',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_START_DATE .
  constants:
    begin of INVALID_END_DATE,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '009',
      attr1 type scx_attrname value 'G_ENDDA',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_END_DATE .
  constants:
    begin of SNAPSHOT_TYPE_BLANK,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '010',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SNAPSHOT_TYPE_BLANK .
  constants:
    begin of SNAP_TYPE_WEEK_BLANK,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '011',
      attr1 type scx_attrname value 'G_SNAPSHOT_TYPE',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SNAP_TYPE_WEEK_BLANK .
  constants:
    begin of WEEK_RANGE_INVALID,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '012',
      attr1 type scx_attrname value 'G_BEGDA',
      attr2 type scx_attrname value 'G_ENDDA',
      attr3 type scx_attrname value 'G_SNAPSHOT_TYPE',
      attr4 type scx_attrname value '',
    end of WEEK_RANGE_INVALID .
  constants:
    begin of DELETE_NOT_POSSIBLE,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '016',
      attr1 type scx_attrname value 'G_BEGDA',
      attr2 type scx_attrname value 'G_ENDDA',
      attr3 type scx_attrname value 'G_SNAPSHOT_TYPE',
      attr4 type scx_attrname value '',
    end of DELETE_NOT_POSSIBLE .
  constants:
    begin of CREATION_NOT_POSSIBLE,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '003',
      attr1 type scx_attrname value 'G_BEGDA',
      attr2 type scx_attrname value 'G_ENDDA',
      attr3 type scx_attrname value 'G_SNAPSHOT_TYPE',
      attr4 type scx_attrname value '',
    end of CREATION_NOT_POSSIBLE .
  constants:
    begin of CREATION_OVERLAP,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '004',
      attr1 type scx_attrname value 'G_BEGDA',
      attr2 type scx_attrname value 'G_ENDDA',
      attr3 type scx_attrname value 'G_SNAPSHOT_TYPE',
      attr4 type scx_attrname value '',
    end of CREATION_OVERLAP .
  constants:
    begin of MAIN_PLANT_BLANK,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '020',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of MAIN_PLANT_BLANK .
  constants:
    begin of REPWEEK_START_DATE_BLANK,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '021',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of REPWEEK_START_DATE_BLANK .
  constants:
    begin of REPWEEK_END_DATE_BLANK,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '022',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of REPWEEK_END_DATE_BLANK .
  constants:
    begin of RESULTS_EMPTY,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '023',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of RESULTS_EMPTY .
  constants:
    begin of INVALID_WRKCTR_HIER,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '024',
      attr1 type scx_attrname value 'G_HIER',
      attr2 type scx_attrname value 'G_IWERK',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_WRKCTR_HIER .
  constants:
    begin of INVALID_WRKCTR_NODE,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '025',
      attr1 type scx_attrname value 'G_NODE',
      attr2 type scx_attrname value 'G_HIER',
      attr3 type scx_attrname value 'G_IWERK',
      attr4 type scx_attrname value '',
    end of INVALID_WRKCTR_NODE .
  constants:
    begin of UI_CONTROL_LOAD_FAILED,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '029',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of UI_CONTROL_LOAD_FAILED .
  constants:
    begin of ORDER_LIST_EMPTY,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '039',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ORDER_LIST_EMPTY .
  constants:
    begin of NOTI_OBJECTS_MISSING,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '040',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NOTI_OBJECTS_MISSING .
  constants:
    begin of GIS_DATA_MISSING,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '041',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of GIS_DATA_MISSING .
  constants:
    begin of DATE_RANGE_INVALID,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '043',
      attr1 type scx_attrname value 'G_BEGDA',
      attr2 type scx_attrname value 'G_ENDDA',
      attr3 type scx_attrname value 'G_MONTHS',
      attr4 type scx_attrname value '',
    end of DATE_RANGE_INVALID .
  constants:
    begin of CONTRL_AREA_MISSING,
      msgid type symsgid value 'ZPMMC_MRSWRK',
      msgno type symsgno value '044',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of CONTRL_AREA_MISSING .
  data G_BEGDA type CHAR10 .
  data G_ENDDA type CHAR10 .
  data G_SNAPSHOT_TYPE type ZPMDE_SNAP_TYPE .
  data G_HIER type CRHH-NAME .
  data G_NODE type CRHD-ARBPL .
  data G_IWERK type CRHH-WERKS .
  data G_MONTHS type I .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !G_BEGDA type CHAR10 optional
      !G_ENDDA type CHAR10 optional
      !G_SNAPSHOT_TYPE type ZPMDE_SNAP_TYPE optional
      !G_HIER type CRHH-NAME optional
      !G_NODE type CRHD-ARBPL optional
      !G_IWERK type CRHH-WERKS optional
      !G_MONTHS type I optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_PM_MRS_REPMGR IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->G_BEGDA = G_BEGDA .
me->G_ENDDA = G_ENDDA .
me->G_SNAPSHOT_TYPE = G_SNAPSHOT_TYPE .
me->G_HIER = G_HIER .
me->G_NODE = G_NODE .
me->G_IWERK = G_IWERK .
me->G_MONTHS = G_MONTHS .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
