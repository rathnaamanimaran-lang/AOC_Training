@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'bOOKING PROCESSOR'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION

define view entity ZATS_RM_BOOKING_PROCESSOR as projection on zats_rm_booking
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _BookingSt,
    _Carr,
    _Conn,
    _Cust,
    _Supplement: redirected to composition child ZATS_RM_SUPPL_PROCESSOR,
    _Travel: redirected to parent ZATS_RM_TRAVEL_processor
}
