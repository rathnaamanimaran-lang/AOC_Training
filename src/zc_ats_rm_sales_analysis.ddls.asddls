@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Dashboard'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view entity zc_ats_rm_sales_analysis as select from zco_ats_rm_sales_cube
{
    key ProductName,
    @Consumption.filter.selectionType: #SINGLE
    key ProductCategory,
    @AnalyticsDetails.query.axis: #ROWS
    key CompanyName,
    Product,
    ConvertCurrency,
    ConvertAmount
    
}
