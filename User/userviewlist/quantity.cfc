<cfcomponent>

  <cffunction name="updateProductQuantity" access="remote" returntype="string" returnformat="json">
    <cfargument name="action" type="string" required="true">
    <cfargument name="item" type="string" required="true">

    <cfset var response = {}>

    <cfset var product = session.cart[arguments.item]>

    <cfif arguments.action EQ "plus">
      <cfset product.quantity = product.quantity + 1>
    <cfelseif product.quantity gt 1>
      <cfset product.quantity = product.quantity - 1>
    </cfif>

    <cfset var total = product.price * product.quantity>

     <!--- <cfset session.cart[arguments.item] = product> --->

    <cfset response.STATUS = true>
    <cfset response.QUANTITY = product.quantity>
    <cfset response.TOTAL = total>
    <cfset response.ID = product.productid>
   <!---  to convert to json data  --->
    <cfreturn serializeJSON(response)>
  </cffunction>

</cfcomponent>











