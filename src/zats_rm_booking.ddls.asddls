@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child node of booking'
@Metadata.ignorePropagatedAnnotations: true
//@Metadata.allowExtensions: true
@VDM.viewType: #COMPOSITE
define view entity zats_rm_booking as select from /dmo/booking_m
composition[0..*] of zats_rm_suppl as _Supplement
association to parent zats_rm_travel as _Travel
    on $projection.TravelId = _Travel.TravelId
association [1..1] to /DMO/I_Customer as _Cust
    on $projection.CustomerId = _Cust.CustomerID
association [1..1] to /DMO/I_Carrier as _Carr
    on $projection.CarrierId = _Carr.AirlineID
association [1..1] to /DMO/I_Connection as _Conn
    on $projection.ConnectionId = _Conn.ConnectionID
association [1..1] to /DMO/I_Booking_Status_VH as _BookingSt
    on $projection.BookingStatus = _BookingSt.BookingStatus

{
   key travel_id as TravelId,
   key booking_id as BookingId,
   booking_date as BookingDate,
   @Consumption.valueHelpDefinition: [{
       qualifier: '',
       entity: {
           name: '/DMO/I_Customer',
           element: 'CustomerID'
       }
   }]
   customer_id as CustomerId,
   @Consumption.valueHelpDefinition: [{
       qualifier: '',
       entity: {
           name: '/DMO/I_Carrier',
           element: 'AirlineID'
       }
   }]
   carrier_id as CarrierId,
   @Consumption.valueHelpDefinition: [{
       qualifier: '',
       entity: {
           name: '/DMO/I_Connection',
           element: 'ConnectionID'
       },       
       additionalBinding: [{
//           localParameter: '',
           localElement: 'CarrierId',
//           localConstant: '',
//           parameter: '',
           element: 'AirlineID'
//           usage: 
          }]
   }]
   connection_id as ConnectionId,
   flight_date as FlightDate,
   @Semantics.amount.currencyCode: 'CurrencyCode'
   flight_price as FlightPrice,
   @Consumption.valueHelpDefinition: [{
       qualifier: '',
       entity: {
           name: 'I_Currency',
           element: 'Currency'
       }
   }]
   currency_code as CurrencyCode,
   @Consumption.valueHelpDefinition: [{
       qualifier: '',
       entity: {
           name: '/DMO/I_Booking_Status_VH',
           element: 'BookingStatus'
       }
   }]
   booking_status as BookingStatus,
   @Semantics.systemDateTime.lastChangedAt: true
   last_changed_at as LastChangedAt,
   _Travel,
   _Supplement,
   _BookingSt,
   _Carr,
   _Conn,
   _Cust
   
}
