CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE travel\_booking.
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
*    out->write( number_key ).
    case returncode.
      when 1.
        LOOP AT ent_wo_travelid INTO entity.
            APPEND VALUE #(  %CID = entity-%cid %KEY = entity-%key %MSG = NEW /dmo/cm_flight_messages(
              textid                = /dmo/cm_flight_messages=>not_sufficient_numbers
              severity              =  if_abap_behv_message=>severity-warning
            ) ) TO reported-travel.
        ENDLOOP.
      WHEN 2 OR 3.
        DATA(lt_success) = ent_wo_travelid.
        if retqty > 0.
            DELETE lt_success FROM retqty + 1.
        ELSE.
            CLear lt_success.
        ENDIF.

        DATA(lt_fail) = ent_wo_travelid.
        DELETE lt_fail to retqty.

        LOOP AT lt_fail INTO entity.
            APPEND VALUE #(  %CID = entity-%cid %KEY = entity-%key %MSG = NEW /dmo/cm_flight_messages(
              textid                = /dmo/cm_flight_messages=>not_sufficient_numbers
              severity              =  if_abap_behv_message=>severity-warning
            ) ) TO reported-travel.
            APPEND VALUE #(  %CID = entity-%cid %KEY = entity-%key %FAIL-CAUSE = if_abap_behv=>cause-conflict ) TO failed-travel.
        ENDLOOP.

        ent_wo_travelid = lt_success.
    endcase.

    ASSERT retqty = LINES( ent_wo_travelid ).

    travelid_max = number_key - retqty.

    LOOP AT ent_wo_travelid INTO entity.
        travelid_max += 1.
        entity-TravelId = travelid_max.

        APPEND VALUE #( %CID = entity-%cid %KEY = entity-%key ) TO mapped-travel.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

  TYPES:BEGIN OF ty_max_book,
        travelid TYPE /dmo/travel_id,
        max_bookingid TYPE /dmo/booking_id,
        END OF TY_MAX_BOOK.

  DATA: booking_max_id TYPE /dmo/booking_id,
        lt_max_book TYPE HASHED TABLE OF ty_max_book WITH UNIQUE KEY travelid.

  READ ENTITIES OF zats_rm_travel IN LOCAL MODE ENTITY Travel BY \_Booking
    FROM CORRESPONDING #( entities ) LINK DATA(lt_bookings).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<tr_grp>) GROUP BY <tr_grp>-TravelId.
        clear booking_max_id.
        LOOP AT lt_bookings INTO DATA(ls_booking) USING KEY entity
                WHERE source-TravelId = <tr_grp>-TravelId.

                if booking_max_id < ls_booking-target-TravelId.
                    booking_max_id = ls_booking-target-TravelId.
                ENDIF.
        ENDLOOP.

        LOOP AT <tr_grp>-%target ASSIGNING FIELD-SYMBOL(<wo_book_id>).
            APPEND CORRESPONDING #( <wo_book_id> ) TO mapped-booking ASSIGNING FIELD-SYMBOL(<mapped_booking>).
            if <mapped_booking>-BookingId is INITIAL.
                booking_max_id += 10.
                <mapped_booking>-BookingId = booking_max_id.
            ENDIF.
        ENDLOOP.
     ENDLOOP.

  ENDMETHOD.

ENDCLASS.
