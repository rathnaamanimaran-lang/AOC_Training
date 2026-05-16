@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root CDS for Travel request'
@Metadata.ignorePropagatedAnnotations: true
define root view entity  zats_rm_travel  as select from /dmo/travel_m
composition[0..*] of zats_rm_booking as _Booking
association [1..1] to /DMO/I_Agency as _Agency on
    $projection.AgencyId = _Agency.AgencyID
association [1..1] to /DMO/I_Customer as _Cust on
    $projection.CustomerId = _Cust.CustomerID
association [1..1] to I_Currency as _Curr on
    $projection.CurrencyCode = _Curr.Currency
association [1..1] to /DMO/I_Overall_Status_VH as _OverallSt on
    $projection.OverallStatus = _OverallSt.OverallStatus
{
    @ObjectModel.text.element: [ 'Description' ]
    key travel_id as TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    agency_id as AgencyId,
    _Agency.Name as AgencyName,
    @ObjectModel.text.element: [ 'CustomerName' ]
    customer_id as CustomerId,
    concat_with_space( _Cust.FirstName, _Cust.LastName, 2 ) as CustomerName,
    begin_date as BeginDate,
    end_date as EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    booking_fee as BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    total_price as TotalPrice,
    currency_code as CurrencyCode,
    description as Description,
    @EndUserText.label: 'Current Status'
    @ObjectModel.text.element: [ 'StatusText' ]
    overall_status as OverallStatus,
    case overall_status
        when 'X' then 1
        when 'O' then 2
        when 'A' then 3
        else 1
    end as ColorCode, 
    _OverallSt._Text[ Language = $session.system_language ].Text as StatusText,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
//    eTAG
    last_changed_at as LastChangedAt,
    _Agency,
    _Curr,
    _Cust,
    _Booking,
    _OverallSt
}
