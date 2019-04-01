class PaymentsController < ApplicationController
	def new
		if current_cart.cart_products.size == 0
    	redirect_to '/', :notice => 'Your cart is empty'
     	return
    end
    @payment = Payment.new
	end

	def create
    if current_cart.cart_products.size == 0
      redirect_to '/', :notice => 'Your cart is empty'
      return
    else
  		@payment = Payment.new(payment_params)
      if(params[:payment][:pay_type] == "atm")
      # Stripe.api_key = "sk_test_Hm0ywtd94a4e27SHOfzVJLpZ"
        @cart = current_cart
        @amount = @cart.total_price.to_i * 100
        token = params[:stripeToken]

        # Create a Customer
        customer = Stripe::Customer.create({
          :description => params[:payment][:name], 
          :card => token,
        })

        charge = Stripe::Charge.create({
          :customer => customer.id,
          :amount => @amount, # amount in cents, again
          :currency => 'usd'
        })
        @payment.charge_id = charge.id
        if @payment.save
          @payment.add_line_items_from_cart(current_cart)
          Cart.destroy(session[:cart_id])
          session[:cart_id] = nil
          @payment.payment_items.each do |item|
              @product = Product.find(item.product_id)
              @product.quantity = @product.quantity - item.quantity
              @product.save
          end
          redirect_to root_path
        else
          render 'new'
        end
      else
        if @payment.save
          @payment.add_line_items_from_cart(current_cart)
          Cart.destroy(session[:cart_id])
          session[:cart_id] = nil
          @payment.payment_items.each do |item|
              @product = Product.find(item.product_id)
              @product.quantity = @product.quantity - item.quantity
              @product.save
          end
          redirect_to root_path
        end
      end
    end
  end

    private
    def payment_params
      params.require(:payment).permit(:name, :phone, :address, :pay_type)
    end
end
