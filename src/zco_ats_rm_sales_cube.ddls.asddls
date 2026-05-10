@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
define view entity zco_ats_rm_sales_cube as select from zco_ats_rm_sales_pdt association of many to one zi_ats_rm_bpa as _bpa
on $projection.Buyer = _bpa.BpId
{
    key OrderId,
    key ItemId,
    Product,
    ConvertCurrency, 
    @Aggregation.default: #SUM
    ConvertAmount,
    Qty,
    Uom,
    Buyer,
    ProductName,
    ProductCategory,
    _bpa.CompanyName   
}
