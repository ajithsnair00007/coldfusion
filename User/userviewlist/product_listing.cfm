<html>
   <head>
     <link rel="stylesheet" href="/cssStyle/userproductlist.css">
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" 
                integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" 
                crossorigin="anonymous" referrerpolicy="no-referrer" />
     <script src="https://code.jquery.com/jquery-3.7.0.js" 
            integrity="sha256-JlqSTELeR4TLqP0OG9dxM7yDPqX1ox/HfgiSLBj8+kM=" 
            crossorigin="anonymous">
     </script>

     <script>
        $(document).ready(function(){
             $('.addtocart').click(function(){
                 var productid=$(this).data('productid');
                 var productname=$(this).data('productname');
                 var image=$(this).data('image');
                 var price=$(this).data('price');

                 $.ajax({
                  type:'POST',
                  url:'cart.cfc?method=addToCart',
                  dataType:'json',
                  data:{
                     productid:productid,
                     productname:productname,
                     image:image,
                     price:price
                     
                  },
                  success: function(response){
                     var result=JSON.parse(response)
                     
                       if(result.status){
                           $(`#addtocart${result.ID}`).text("ADDED TO CART")
                                                      .css("background-color", "green")
                                                      .prop("disabled",true);
                           
                       }
                        
                  },
                 });
             });
        });
     </script>
   </head>

   <body>
      
      <button class="cart"><a href="displaycart.cfm"><i class="fa-solid fa-cart-shopping"></i></a></button>

    <cfquery name="productList" datasource="product_list">
       SELECT product_id,product_name, price, no_of_availableStocks, is_active,image_path 
       FROM product_table
    </cfquery>
    
    <cfoutput query="productList">
        <div class="card">
          <div class="container">
             <img src="#image_path#" alt="productimage" height:"100px" width:"100px">
             <h2 class="productname"><b>#product_name#</b></h2>
             <p class="price"><b>price:#price#</b></p>
             
               <button id="addtocart#product_id#"
                       class="addtocart"
                       type="submit"
                       data-productid="#product_id#"
                       data-productname="#product_name#"
                       data-image="#image_path#"
                       data-price="#price#">ADD TO CART</button>
             
          </div>
        </div>
    </cfoutput>

   </body>
</html>