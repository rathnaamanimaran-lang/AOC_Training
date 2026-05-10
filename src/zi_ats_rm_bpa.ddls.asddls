@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Business partners'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
define view entity zi_ats_rm_bpa as select from zrath_bpa
{
    key bp_id as BpId,
    bp_role as BpRole,
    company_name as CompanyName,
    street as Street,
    country as Country,
    region as Region,
    city as City
}
