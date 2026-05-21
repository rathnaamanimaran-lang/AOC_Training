@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child for booking supplement'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #COMPOSITE
define view entity zats_rm_suppl as select from /dmo/booksuppl_m
association to parent zats_rm_booking as _Booking
    on $projection.TravelId = _Booking.TravelId and
    $projection.BookingId = _Booking.BookingId
association [1] to zats_rm_travel as _Travel
    on $projection.TravelId = _Travel.TravelId
association [1] to /DMO/I_Supplement as _Suppl
    on $projection.SupplementId = _Suppl.SupplementID
association [1] to /DMO/I_SupplementText as _SupplTxt
    on $projection.SupplementId = _SupplTxt.SupplementID        
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    @Consumption.valueHelpDefinition: [{
//       qualifier: '',
       entity: {
           name: '/DMO/I_Supplement',
           element: 'SupplementID'
       }
   }]
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    @Consumption.valueHelpDefinition: [{
       qualifier: '',
       entity: {
           name: 'I_Currency',
           element: 'Currency'
       }
   }] 
    currency_code as CurrencyCode,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    _Booking,
    _Suppl,
    _SupplTxt,
    _Travel
}
