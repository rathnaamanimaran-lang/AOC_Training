CLASS zcl_ats_rm_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    DATA: LV_OP TYPE C VALUE 'C'.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ats_rm_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    case LV_OP.
      when 'R'.

        READ ENTITIES OF zats_rm_travel ENTITY Travel FIELDS ( TravelId ) WITH VALUE #( ( TravelId = '00000019' ) ( TravelId = '555' ) ( TravelId = '5555545' ) )
            RESULT DATA(LT_RESULT)
            ENTITY Booking ALL FIELDS WITH VALUE #( ( TravelId = '555' BookingId = '1' ) ( TravelId = '555' BookingId = '2' ) )
            RESULT DATA(LT_RES_BOOKINGS)
            REPORTED DATA(LT_REPORTED) FAILED DATA(LT_FAILED) .

*        READ ENTITY zats_rm_booking ALL FIELDS WITH VALUE #( ( TravelId = '555' BookingId = '1' ) ( TravelId = '555' BookingId = '2' ) )
*            RESULT DATA(LT_RES_BOOKINGS)
*            REPORTED DATA(LT_REPORTED) FAILED DATA(LT_FAILED).

*        READ ENTITIES OF zats_rm_travel
*            ENTITY Booking ALL FIELDS WITH VALUE #( ( TravelId = '555' BookingId = '1' ) ( TravelId = '555' BookingId = '2' ) )
*            RESULT DATA(LT_RES_BOOKINGS)
*            REPORTED DATA(LT_REPORTED) FAILED DATA(LT_FAILED) .

*`  TO READ BOOKING THROUGH TRAVEL ASSOCIATION
*        READ ENTITIES OF zats_rm_travel
*            ENTITY Travel BY \_Booking ALL FIELDS WITH VALUE #( ( TravelId = '555' ) ( TravelId = '555' ) )
*            RESULT DATA(LT_RES_BOOKINGS)
*            REPORTED DATA(LT_REPORTED) FAILED DATA(LT_FAILED) .
 ""read dependent booking data fro travel
*            READ ENTITIES OF ZATS_AB_TRAVEL
*                ENTITY Travel
*                BY \_Booking ALL FIELDS WITH
*                CORRESPONDING #( lt_result )
*                RESULT data(lt_result_book)
*                FAILED lt_failed
*                REPORTED lt_reported
*                .
*
*        OUT->write(
*          EXPORTING
*            data   = LT_RESULT
*        ).

        OUT->write(
          EXPORTING
            data   = LT_RES_BOOKINGS
        ).

        OUT->write(
          EXPORTING
            data   = LT_REPORTED
        ).

        OUT->write(
          EXPORTING
            data   = LT_FAILED
        ).
      WHEN 'C'.

        data(lv_descr) = 'Create with EML ABAP'.
        data(lv_agency) = '070016'.
        data(lv_cust) = '000697'.

*        MODIFY entity zats_rm_travel CREATE AUTO FILL CID FIELDS ( TravelId AgencyId CustomerId Description BeginDate EndDate OverallStatus )
*            WITH VALUE #( (
**                %cid = 'CID1'
*                TravelId = '1213354'
*                AgencyId = lv_agency
*                CustomerId = lv_cust
*                Description = lv_descr
*                BeginDate = cl_abap_context_info=>get_system_date(  )
*                EndDate = cl_abap_context_info=>get_system_date(  ) + 5
*                OverallStatus = 'O'
*                ) )
*                    FAILED LT_FAILED MAPPED DATA(lt_mapped) REPORTED LT_REPORTED.

        MODIFY ENTITIES OF zats_rm_travel
            ENTITY Travel CREATE AUTO FILL CID FIELDS ( travelid agencyid customerid description overallstatus )
                WITH VALUE #(
                                (
*                                    %cid = 'CID1'
                                    travelid = '000123494'
                                    agencyid = lv_agency
                                    CustomerId = lv_cust
                                    BeginDate = cl_abap_context_info=>get_system_date(  )
                                    endDate = cl_abap_context_info=>get_system_date(  ) + 30
                                    Description = lv_descr
                                    OverallStatus = 'O'
                                    )
                                    )
*                                    ENTITY Travel CREATE BY \_Booking FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate )
**                                    CREATE BY \_Booking AUTO FILL CID FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate )
*                                     WITH VALUE #(
*                                    (
*                                      TravelId = '000123494'
**                                      BookingId = '10'
*                                      BookingDate = cl_abap_context_info=>get_system_date( )
*                                      CustomerId = lv_cust
*                                      CarrierId = 'LH'
*                                      ConnectionId = '0400'
*                                      FlightDate = cl_abap_context_info=>get_system_date( ) + 5
*                                )
*      )
                                FAILED LT_FAILED MAPPED DATA(lt_mapped) REPORTED LT_REPORTED.

        COMMIT ENTITIES.
        OUT->write(
          EXPORTING
            data   = LT_FAILED
        ).

        OUT->write(
          EXPORTING
            data   = lt_mapped
        ).

        OUT->write(
          EXPORTING
            data   = LT_REPORTED
        ).
    WHEN 'U'.

        lv_descr = 'Back for Vacation'.
            lv_agency = '070042'.
*
*        MODIFY ENTITY zats_rm_travel  UPDATE FIELDS ( TravelId AgencyId Description ) WITH
*            VALUE #( ( TravelId = '1213354' AgencyId = lv_agency Description = lv_descr ) )
*                FAILED lt_failed MAPPED lt_mapped REPORTED lt_reported.

        MODIFY ENTITIES OF zats_rm_travel ENTITY Travel UPDATE FIELDS ( TravelId AgencyId Description ) WITH VALUE #(
        ( TravelId = '025' AgencyId = lv_agency Description = lv_descr ) ) ENTITY Booking UPDATE FIELDS ( BookingId BookingStatus )
        WITH VALUE #( ( TravelId = '025' BookingId = '02' BookingStatus = 'Y' ) ) FAILED lt_failed MAPPED lt_mapped REPORTED lt_reported.

        COMMIT ENTITIES.

        OUT->write(
          EXPORTING
            data   = LT_FAILED
        ).

        OUT->write(
          EXPORTING
            data   = lt_mapped
        ).

        OUT->write(
          EXPORTING
            data   = LT_REPORTED
        ).

    WHEN 'D'.

        MODIFY ENTITIES OF zats_rm_travel ENTITY Travel DELETE FROM VALUE #( ( TravelId = '1213354' ) )
              FAILED lt_failed
                REPORTED lt_reported
                MAPPED lt_mapped.

            COMMIT ENTITIES.

            out->write(
              EXPORTING
                data   = lt_mapped
            ).

            out->write(
              EXPORTING
                data   = lt_failed
            ).
    endcase.

  ENDMETHOD.
ENDCLASS.
