CLASS zcl_rath_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rath_demo IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  select * from I_Country into TABLE @data(itab).

  out->write(
    EXPORTING
      data   = itab
*      name   =
*    RECEIVING
*      output =
  ).

  ENDMETHOD.
ENDCLASS.
