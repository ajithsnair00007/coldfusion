
<cfoutput>
<html>
<head>
    <link rel="stylesheet" href="/cssStyle/cart.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js" 
            integrity="sha256-JlqSTELeR4TLqP0OG9dxM7yDPqX1ox/HfgiSLBj8+kM=" 
            crossorigin="anonymous">
    </script>
    <script>
    $(document).ready(function() {
       
        function updateProductQuantity(action, item) {
            $.ajax({
                type: "POST",
                url: "quantity.cfc",
                data: {
                    method: "updateProductQuantity",
                    action: action,
                    item: item
                },
                dataType: "json",
                success: function(response) {
                    // convert json into js object
                    var result = JSON.parse(response);
                    if (result.STATUS) {
                    console.log(typeof JSON.parse(response)); 
                    console.log(result);
                       
                        $(`##quantity${result.ID}`).text(result.QUANTITY) ;
                        $(`##total${result.ID}`).text(result.TOTAL);
                        $(`##totalsum`).text(`TotalPrice: ${result.TOTALSUM}`);

                    console.log(result.TOTALSUM);   
                       
                    } else {
                        alert("Error:");
                    }
                }
               
            });
        };


        $(".increaseqty").click(function(){
            const item = $(this).data("item");
            updateProductQuantity("plus", item);
        });

        $(".decreaseqty").click(function(){
            const item = $(this).data("item");
            updateProductQuantity("minus", item);
        });

        $("##checkout").click(function(){
            $.ajax({
                type:'POST',
                url:"checkout.cfc?method=checkOut",
                success:function(response){
                   var result = JSON.parse(response);
                   if(result.status){
                      window.location.href="product_listing.cfm"; 
                   }   
                }
            });
        });
        $(document).on('click','##gobackbtn',function(){
             window.location.href="product_listing.cfm";
        });
        // $('##gobackbtn').click(function(e){
        //     e.preventDefault();
        //     window.location.href="product_listing.cfm";
        // })
    
        $('##purchaseItem').click(function(){
            window.location.href="product_listing.cfm";
            
        })


        $(document).on('click', '.removeitem', function(){
            const id = $(this).data("id");

            $(this).addClass("loader");
            setTimeout(function(){
                $('##removeitem').removeClass("loader");
            },2000)

            $.ajax({
                type:'POST',
                url:'removeitem.cfc?method=removeItem',
                data:{
                    id:id
                    
                },
                dataType: "json",
                success:function(response){
                     var result=JSON.parse(response);
                  
                    if(result.STATUS){

                        $(`##productrow${result.ID}`).remove();

                        currentTotalSum=parseInt($(`##totalsum`).text().split(':')[1]);
                        itemPrice = parseInt(result.PRICE);
                       
                        priceOfitem = parseInt(itemPrice = (result.PRICE));
                        updatedSum =parseInt(Number(currentTotalSum) - Number(itemPrice));
                        $(`##totalsum`).text(`TotalPrice: ${updatedSum}`);  

                        if(updatedSum==0){ 
                            $("table").hide(); 
                            $("##totalsum").hide();
                            $("##purchaseItem").show(); 
                            $("button.clearcart").hide(); 
                            $("button.checkout").hide();
                            $(".gobackbtn").hide();
                            $(".emptycartmsg").text("your cart is empty").css("visibility","visible");
                        }
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
              }
            });
        });

        $(document).on('click','##applycp',function(){
            const id = $(this).data("id");

            $.ajax({
                type:'POST',
                url:'../../Admin/Coupons/cfc/add_coupon.cfc?method=retrieveCoupon',
                data:{
                    id:id
                },
                datatype:'json',
                success:function(couponDetails){
                    var result =  JSON.parse(couponDetails) ;
    
                if (result) {
                    // showCouponPopup(result);
                   console.log(result);
                   console.log(typeof result);
                $('.coupon-row').remove();
                $.each(result, function(index, value) {
                    var couponRow = '<tr class="coupon-row">' +
                                    '<td>' + value.COUPON_NAME + '</td>' +
                                    '<td>' + value.COUPON_CODE + '</td>' +
                                    '<td>' + value.COUPON_TYPE + '</td>' +
                                    '<td>' + value.COUPON_OFFER + '</td>' +
                                    '</tr>';
                    $('table').append(couponRow);
                });
            } 
                }
            });
        });

        //   function showCouponPopup(result) {
        //     var popupContent = '<h2>Coupon Details</h2>';
        //     $.each(result, function(index, value) {
        //         popupContent += '<p><strong>Coupon Name:</strong> ' + value.COUPON_NAME + '</p>' +
        //                         '<p><strong>Coupon Code:</strong> ' + value.COUPON_CODE + '</p>' +
        //                         '<p><strong>Coupon Type:</strong> ' + value.COUPON_TYPE + '</p>' +
        //                         '<p><strong>Coupon Offer:</strong> ' + value.COUPON_OFFER + '</p>';
        //     });

        //     $('##couponPopup').html(popupContent);
        //     $('##couponPopup').show();
        // }

    });
</script>
</head>
<body>
    <tr class="coupon-row">
    
</tr>

    <h1>Your Cart</h1>
    <button class="gobackbtn" id="gobackbtn">GoBack</button>
<!---     <div class="popup" id="couponPopup"> 
        <h2>Coupon Details</h2>
    </div>--->
      <table>
        <tr>
            <th class="productname">Product Name</th>
            <th>Image</th>
            <th class="price">Price</th>
            <th>Quantity</th>
            <th>Total</th>
            <th>CouponOffers</th>
            <th>Remove</th>
        </tr>

        <cfset cart = {}>

        <cfif isDefined('Session.cart')>
           <cfset cart = Session.cart>
        </cfif>
         <cfset totalSum = 0> 
       
        <cfloop collection="#cart#" item="item">
            <cfset product = cart[item]>
          
            <tr id="productrow#product.productid#">
                <td class="productname">#product.productname#</td>
                <td><img src="#product.image#" alt="" width="100" height="100"></td> 
                <td class="price">#product.price#</td>
                <td>
                   
                        <button class="increaseqty" type="button" data-item="#item#">+</button>
                        <span id ="quantity#product.productid#" class="productquantity">#product.quantity#</span>
                        <button class="decreaseqty" type="button" data-item="#item#">-</button>
                   
                </td>
                <td id ="total#product.productid#" class="totalprice">#product.price * product.quantity#</td>
                <td><button class="applycp" id="applycp" data-id="#product.productid#">Apply Coupon</button></td>
                <td><button class="removeitem" id="removeitem" data-id="#product.productid#">RemoveItem</button></td>
                
                
            </tr>
           <cfset totalSum = totalSum+(product.price * product.quantity)> 
        </cfloop>
        
      </table>

   
    <div id="totalsum" class="totalsum">TotalPrice : #totalSum#</div> 
    <button class="clearcart" id="clearCartBtn"><a href="clearCart.cfm">Clear Cart</a></button>
    <button class="checkout" id="checkout">Checkout</button>
    <button class="purchaseItem" id="purchaseItem">PurchaseItem</button>
    <span class="emptycartmsg" id="emptycartmsg"></span>
    <cfif structIsEmpty(cart)>
            
            <cfset message = "Your cart is empty!">
            <span class="emptycart">#message#</span>
            <script>
                $(document).ready(function() {
                    function hideButtons() {
                    $("table").hide();
                    $("##clearCartBtn").hide();
                    $("##checkout").hide();
                    $("##purchaseItem").show();
                    $("##totalsum").hide();
                    $(".gobackbtn").hide();
                }
                     hideButtons();
                });
            </script>
    <cfelse>
            <script>
                $(document).ready(function() {
                    function showButton() {
                    $("##purchaseItem").hide();
                }
                     showButton();
                });
            </script>    
    </cfif>
   
</body>
</html>
</cfoutput>











