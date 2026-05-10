@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Sales Order'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #BASIC
@Analytics.dataCategory: #FACT
define view entity zi_ats_rm_salesorder as select from zrath_so_hdr as Head  association [1..*] to zrath_so_item as _Item
    on $projection.OrderId = _Item.order_id
{
    key Head.order_id as OrderId,
    key _Item.item_id as ItemId,
    Head.order_no as OrderNo,
   
    _Item.product as Product,
    @Semantics.amount.currencyCode: 'Currency'
    _Item.amount as Amount,
    _Item.currency as Currency,
    @Semantics.quantity.unitOfMeasure: 'UOM'
    _Item.qty as Qty,
    _Item.uom as Uom,
     Head.buyer as Buyer
      
}
