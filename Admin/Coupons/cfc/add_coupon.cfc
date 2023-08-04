<cfcomponent>
   <cffunction name="addCoupon" access="remote" returntype="string" returnformat="json">
      <cfargument name="cpname" type="string" required="true">
      <cfargument name="cpcode" type="string" required="true">
      <cfargument name="cptype" type="string" required="true">
      <cfargument name="cpoffer" type="numeric" required="true">
      <cfargument  name="cpstatus" type="boolean" required="true">
      

      <cfset response = {}>
      <cfset response['exist'] = false>

      <cfquery name="checkCouponCode" datasource="product_list">
         SELECT coupon_code
         FROM coupons
         WHERE coupon_code = <cfqueryparam value="#arguments.cpcode#" cfsqltype="cf_sql_varchar">
      </cfquery>

      <cfif checkCouponCode.RecordCount>
          <cfset response['exist'] = true>
      
      <cfelse>
         <cfquery name="addcoupon" datasource="product_list" result="result">
            INSERT INTO coupons (coupon_name, coupon_code, coupon_type, coupon_offer,is_active)
            VALUES (
               <cfqueryparam value="#arguments.cpname#" cfsqltype="cf_sql_varchar">,
               <cfqueryparam value="#arguments.cpcode#" cfsqltype="cf_sql_varchar">,
               <cfqueryparam value="#arguments.cptype#" cfsqltype="cf_sql_varchar">,
               <cfqueryparam value="#arguments.cpoffer#" cfsqltype="cf_sql_numeric">,
               <cfqueryparam value="#arguments.cpstatus#" cfsqltype="cf_sql_bit">
            )
         </cfquery>
        
         
      </cfif>
       <cfif NOT response['exist']>
         <cfset response['succ'] = "Coupon added successfully!">
      </cfif>
      <cfreturn serializeJSON(response)>
   </cffunction>

   <!---function to control activate buttons--->
   <cffunction  name="activateCoupon" access = 'public' returntype="void">
       <cfargument  name="couponid" type="numeric" required="true">
       <cfargument  name="toactivate" type="boolean" required="true">

       <cfset isAuthenticated = structKeyExists(Session, "userid")>
       <cfif isAuthenticated>    
   
       <cfquery name="getCoupon" datasource="product_list">
          SELECT coupon_code FROM coupons
          WHERE coupon_id = <cfqueryparam value="#arguments.couponid#" cfsqltype="cf_sql_integer">
       </cfquery>

       <cfif url.toactivate eq 1>
         <cfquery name="activatecoupon" datasource="product_list" result="result">
            UPDATE coupons
            SET is_active = <cfqueryparam value="#arguments.toactivate#">
            WHERE coupon_id = <cfqueryparam value="#arguments.couponid#" cfsqltype="cf_sql_integer">
         </cfquery>
         <cfset successMessage = "#getCoupon.coupon_code# has been successfully activated.">
       </cfif>

       <cfif url.toactivate eq 0>
         <cfquery name="deactivate" datasource="product_list" result="result">
           UPDATE coupons 
           SET is_active = <cfqueryparam value="#arguments.toactivate#">
           WHERE coupon_id = <cfqueryparam value="#arguments.couponid#">
         </cfquery>
         <cfset successMessage = "#getCoupon.coupon_code# has been deactivated.">
       </cfif>

       <cfif result.RecordCount>
            <cflocation  url="../cfm/coupon_display.cfm?successMessage=#successMessage#">
          </cfif>

       <cfelse>
          <cflocation  url="../../login.cfm">
       </cfif>
   </cffunction>

   <!---  function to edit coupon   --->
   <cffunction  name="editCoupon" access="remote" returntype="string" returnformat="json">
      <cfargument  name="cpid" type="numeric" required="true">
      <cfargument  name="cpnewname" type="string" required="true">
      <cfargument  name="cpnewcode" type="string" required="true">
      <cfargument  name="cpnewtype" type="string" required="true">
      <cfargument  name="cpnewoffer" type="numeric" required="true">
      <cfargument  name="cpnewstatus" type="boolean" required="true">

      
      <cfset response = {}>
      <cfset response['exist'] = false>

      <cfset isAuthenticated = structKeyExists(Session, "userid")>
      <cfset response['isAuthenticated'] = isAuthenticated>

      <cfif isAuthenticated>
      
      <!--- Check for a duplicate coupon code with different ID --->
      <cfquery name="checkDuplicateName" datasource="product_list">
          SELECT coupon_id
          FROM coupons
          WHERE coupon_code = <cfqueryparam value="#arguments.cpnewcode#" cfsqltype="cf_sql_varchar">
          AND NOT coupon_id = <cfqueryparam value="#arguments.cpid#" cfsqltype="cf_sql_integer">
      </cfquery>
      
      <cfif checkDuplicateName.RecordCount>
         <cfset response['exist'] = true>
      <cfelse>
         <cfquery name="editcoupon" datasource="product_list" result="result">
            UPDATE coupons 
            SET coupon_name = <cfqueryparam value="#arguments.cpnewname#" cfsqltype="cf_sql_varchar">,
                coupon_code = <cfqueryparam value="#arguments.cpnewcode#" cfsqltype="cf_sql_varchar">,
                coupon_type = <cfqueryparam value="#arguments.cpnewtype#">,
                coupon_offer = <cfqueryparam value="#arguments.cpnewoffer#" cfsqltype="cf_sql_numeric">,
                is_active = <cfqueryparam value="#arguments.cpnewstatus#">
            WHERE coupon_id = <cfqueryparam value = "#arguments.cpid#" cfsqltype = "cf_sql_integer">
         </cfquery>
         
      </cfif>
      <cfif NOT response['exist']>
         <cfset response['succ'] = "Coupon updated successfully!">
      </cfif>

      </cfif>
        <cfif NOT response['isAuthenticated']>
         <cfset response['notAutheticated'] = true>
      </cfif>
      <cfreturn serializeJSON(response)>
   </cffunction>

   <!---function to retrieve coupon datas for the cart--->
   <cffunction  name="retrieveCoupon" access="remote" returntype="string" returnformat="json">
     <cfargument  name="id" type="numeric" required="true">
 
        <cfset couponDetails = []>
        <cfquery name="retrievecoupon" datasource="product_list">
          SELECT coupon_id,coupon_name,coupon_code,coupon_type,coupon_offer FROM coupons
          WHERE is_active=1;
        </cfquery>

        <cfif retrievecoupon.RecordCount>
        <cfloop query="retrievecoupon">
            <cfset couponInfo = {
                coupon_id = #retrievecoupon.coupon_id#,
                coupon_name = "#retrievecoupon.coupon_name#",
                coupon_code = "#retrievecoupon.coupon_code#",
                coupon_type = "#retrievecoupon.coupon_type#",
                coupon_offer = "#retrievecoupon.coupon_offer#" 
            }>
            <cfset arrayAppend(couponDetails, couponInfo)>
            
        </cfloop>
        </cfif>
    
        <cfreturn serializeJSON(couponDetails)>
   </cffunction>
</cfcomponent>