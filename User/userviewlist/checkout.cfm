<cfset orderDetails = createObject("component", "cfc_folder/checkout")> 

<cfdump var="#form#">
<!--- <cfset productid = form.productid> 
<cfdump  var="#productid#">
<cfset userid = form.userid>
<cfdump  var="#userid#">
<cfset quantity = form.productquantity>
<cfdump  var="#quantity#">
<cfset totalprice = form.totalprice>
<cfdump  var="#totalprice#">
<cfset subtotal = form.subtotal>
<cfdump  var="#subtotal#">
<cfabort>
<cfset orderDetails.checkOut(productid,userid,quantity,totalprice,subtotal)>--->