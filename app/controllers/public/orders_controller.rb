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
    @order = current_customer.orders.new(order_params)
    @order.save

    if params[:order][:ship] =="1"
      current_customer.address.create(address_params)
    end

    @cart_items = current_customer.cart_items
    @cart_items.each do |cart_item|
      @order_detail = OrderDetail.new
      @order_detail.item_id = cart_item.item_id
      @order_detail.order_id = @order.id
      @order_detail.count = cart_item.count
      @order_detail.price = cart_item.item.price * cart_item.count
      @order_detail.save
      end

    @cart_items.destroy_all

    redirect_to thanx_orders_path
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
