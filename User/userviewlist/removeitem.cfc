<cfcomponent>
    <cffunction name="removeItem" access="remote" returntype="string" returnformat="json">
        <cfargument name="id" type="numeric" required="true">

        <cfset var response = {}>

        <cflock  scope="Session">
           <cfset var cart = Session.cart>
        </cflock>
        
<!---         <cfif structKeyExists(cart, arguments.id)> --->
            <cfset Session.cart = cart>
            
            
            <cfset structDelete(cart, arguments.id)>
            <cfset response.status = true>
            <cfreturn serializeJSON(response)>
            
<!---         <cfelse> --->
          
<!---             <cfset response["STATUS"] = false>
            <cfset response["MESSAGE"] = "Item not found in the cart.">
        </cfif> --->
           
        
    </cffunction>
</cfcomponent>
