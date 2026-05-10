@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For product details'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
define view entity zi_ats_rm_product as select from zrath_product
{
    key product_id as ProductId,
    name as Name,
    category as Category,
    @Semantics.amount.currencyCode: 'Currency'
    price as Price,
    currency as Currency,
    discount as Discount
    
}
