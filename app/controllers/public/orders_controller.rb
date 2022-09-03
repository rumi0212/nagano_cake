class Public::OrdersController < ApplicationController

  def index
    @orders = current_customer.orders
  end
  
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end
  
  def new
    @order = Order.new
    @addresses = current_customer.addresses
  end
  
  def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    @order.postage = 800
    @order.payment_method = params[:order][:payment_method]
        
    if params[:order][:address_num] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    elsif params[:order][:address_num] == "1"
    
      @address = Address.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
            
    elsif params[:order][:address_num] == "2"
      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
    end
        
  end

  def create
  end
  
  def thanx
  end
  
  private
  
  def order_params
    params.require(:order).permit(:postal_code, :address, :name, :payment_method, :total_payment)
  end

  def address_params
    params.require(:order).permit(:postal_code, :address, :name)
  end

end
