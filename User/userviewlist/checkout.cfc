<cfcomponent>
    <cffunction  name="checkOut" access="remote" returntype="string" returnformat="json">
         
        <cfset response = {}>
        <cfset userid = Session.userLogid>
        <cfset cart = Session.cart>
        
          <cfloop collection="#cart#" item="item">
             <cfset products = cart[item]>
             <cfset productid = products.productid>
             <cfset quantity = products.quantity>
             <cfset totalamount = products.quantity * products.price>
             <cfset subtotal = products.quantity * products.price>

             <cfquery name="checkout" datasource="product_list" result="result">
                 INSERT INTO orders(productID,userID,quantity,total_amount,subtotal)
                 VALUES(#productid#,#userid#,#quantity#,#totalamount#,#subtotal#)
             </cfquery>
          </cfloop>
        <cfset StructClear(Session.cart)>
        <cfset response['status'] = true>
        
          <!--- Return response as JSON --->
        <cfreturn serializeJSON(response)>
        
         
        
    </cffunction>
</cfcomponent>