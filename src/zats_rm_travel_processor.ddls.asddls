@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel pocessor entity'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION
define root view entity ZATS_RM_TRAVEL_PROCESSOR as projection on zats_rm_travel
{
    key TravelId,
    AgencyId,
    CustomerId,
    BeginDate,
    EndDate,
    BookingFee,
    TotalPrice,
    CurrencyCode,
//    CurrencyName,
    Description,
    OverallStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    AgencyName,
    CustomerName,
    StatusText,
    ColorCode,
    /* Associations */
    _Agency,
    
    _Booking : redirected to composition child ZATS_RM_BOOKING_PROCESSOR,
    _Curr,
    _Cust,
    _OverallSt
}
