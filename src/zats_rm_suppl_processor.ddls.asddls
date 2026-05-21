@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplement processor'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION
define view entity ZATS_RM_SUPPL_PROCESSOR as projection on zats_rm_suppl
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    SupplementId,
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent ZATS_RM_BOOKING_PROCESSOR,
    _Suppl,
    _SupplTxt,
    _Travel: redirected to ZATS_RM_TRAVEL_processor
}
