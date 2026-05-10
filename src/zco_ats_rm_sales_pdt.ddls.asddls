@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite for Sales and product'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #COMPOSITE
define view entity zco_ats_rm_sales_pdt as select from zi_ats_rm_salesorder as sales association of many to one zi_ats_rm_product as _pdt 
on $projection.Product = _pdt.ProductId
{
  key  OrderId,
  key  ItemId,
  Product,
  Amount,
  Currency,
  cast('INR' as abap.cuky) as ConvertCurrency,
  @Semantics.amount.currencyCode: 'ConvertCurrency'
  currency_conversion( amount =>  Amount, 
                        source_currency =>  Currency, 
                        target_currency => cast('INR' as abap.cuky), 
                        exchange_rate_date => $session.system_date ) as ConvertAmount,
   Qty,
   Uom,
   Buyer,
  _pdt.Name as ProductName,
  _pdt.Category as ProductCategory 
}
