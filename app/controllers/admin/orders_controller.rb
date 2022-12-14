class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @orders = Order.page(params[:page]).per(10)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @subtotal = 0
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    flash[:notice] = "注文ステータスの変更しました"
    redirect_to admin_order_path(@order)

    if @order.order_status == "入金確認"
      @order.order_details.each do |order_detail|
        order_detail.update(making_status: 1)
      end
    end

  end


  private

  def order_params
    params.require(:order).permit(:postage,:total_payment,:name,:payment_method,:address,:postal_code,:order_status,:making_status)
  end

end
