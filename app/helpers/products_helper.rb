module ProductsHelper
	 def Find_related_products_session(carts)
	       @products = [] 
		     i = 0 
	       while i < carts.count do
	           item = Product.find(carts[i]['product_id'].to_i).category.products.where.not(id: 1).where('price >= :price ',price: carts[i]['price'].to_f).limit(2)
             @products << item
             i = i + 1
	       end         
	 end


end
