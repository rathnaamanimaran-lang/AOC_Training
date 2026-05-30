CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA : ENTITY TYPE STRUCTURE FOR CREATE zats_rm_travel,
           TRAVELID_MAX TYPE /dmo/travel_id.

      LOOP AT entities INTO entity WHERE TravelId IS NOT INITIAL.
        APPEND CORRESPONDING #( entity ) TO mapped-travel.
      ENDLOOP.

    DATA(ENT_WO_TRAVELID) = entities.
    DELETE ent_wo_travelid WHERE TravelId IS NOT INITIAL.

    try.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*            ignore_buffer     =
            nr_range_nr       = '01'
            object            = CONV #( '/DMO/TRAVL' )
            quantity          = CONV #( lines( ent_wo_travelid ) )
*            subobject         =
*            toyear            =
          IMPORTING
            number            = DATA(NUMBER_KEY)
            returncode        = DATA(RETURNCODE)
            returned_quantity = DATA(RETQTY)
        ).
*        CATCH cx_nr_object_not_found.
        CATCH cx_number_ranges INTO DATA(LX_NUMBER_CHANGES).

            LOOP AT ent_wo_travelid INTO entity.
                APPEND VALUE #( %CID = entity-%cid %KEY = entity-%key %MSG = lx_number_changes ) TO reported-travel.

                APPEND VALUE #( %CID = entity-%cid %KEY = entity-%key ) TO failed-travel.
            ENDLOOP.

    endtry.

    case returncode.
      when 1.
        APPEND VALUE #(  %CID = entity-%cid %KEY = entity-%key %MSG = NEW /dmo/cm_flight_messages(
          textid                = /dmo/cm_flight_messages=>not_sufficient_numbers
          severity              =  if_abap_behv_message=>severity-warning
        ) ) TO reported-travel.
      WHEN 2 OR 3.
        APPEND VALUE #(  %CID = entity-%cid %KEY = entity-%key %FAIL-CAUSE = if_abap_behv=>cause-conflict ) TO failed-travel.
    endcase.

    ASSERT retqty = LINES( ent_wo_travelid ).

    travelid_max = number_key - retqty.

    LOOP AT ent_wo_travelid INTO entity.
        travelid_max += 1.
        entity-TravelId = travelid_max.

        APPEND VALUE #( %CID = entity-%cid %KEY = entity-%key ) TO mapped-travel.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
