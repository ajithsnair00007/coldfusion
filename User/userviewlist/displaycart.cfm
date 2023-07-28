
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

        $('##purchaseitem').click(function(){
            window.location.href="product_listing.cfm";
        })

        $("##removeitem").click(function(){
            const id = $(this).data("id");
            $.ajax({
                type:'POST',
                url:'removeitem.cfc?method=removeItem',
                data:{
                    id
                },
                dataType: "json",
                success:function(response){
                    var result=JSON.parse(response);
                    if(result.status){
                        console.log(result);
                    }
                    
                },
                 error: function(jqXHR, textStatus, errorThrown) {
            
          }
            });
        });

    });
</script>
</head>
<body>


    <h1>Your Cart</h1>
   
<!---      <form class="quantity-form" method='post'> --->

      <table>

        <tr>
            <th class="productname">Product Name</th>
            <th>Image</th>
            <th class="price">Price</th>
            <th>Quantity</th>
            <th>Total</th>
            <th>Remove</th>
        </tr>

        <cfset cart = Session.cart>
       
        <cfloop collection="#cart#" item="item">
            <cfset product = cart[item]>
          
            <tr>
                <td class="productname">#product.productname#</td>
                <td><img src="#product.image#" alt="" width="100" height="100"></td> 
                <td class="price">#product.price#</td>
                <td>
                   
                        <button class="increaseqty" type="button" data-item="#item#">+</button>
                        <span id ="quantity#product.productid#" class="productquantity">#product.quantity#</span>
                        <button class="decreaseqty" type="button" data-item="#item#">-</button>
                   
                </td>
                <td id ="total#product.productid#" class="totalprice">#product.price * product.quantity#</td>
                <td><button class="removeitem" id="removeitem" data-id="#product.productid#">RemoveItem</button></td>
            </tr>
        </cfloop>
      </table>
<!---       </form> --->
     
    <button class="clearcart" id="clearCartBtn"><a href="clearCart.cfm">Clear Cart</a></button>
    <button class="checkout" id="checkout">Checkout</button>
    <button class="purchaseitem" id="purchaseitem">PurchaseItem</button>
 
    <cfif structIsEmpty(Session.cart)>
            <!--- Setting a message when the cart is empty --->
            <!---<cfset Session.emptyCartMessage = "Your cart is empty!"> --->
            <cfset message = "Your cart is empty!">
            <span class="emptycart">#message#</span>
            <script>
                $(document).ready(function() {
                    function hideButtons() {
                    $("##clearCartBtn").hide();
                    $("##checkout").hide();
                }
                     hideButtons();
                });
            </script>
    </cfif>
</body>
</html>
</cfoutput>











