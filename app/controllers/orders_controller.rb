class OrdersController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @order_info = OrderInfo.new
    @item = Item.find(params[:item_id])
    redirect_to root_path if @item.order.present?
  end

  def create
    @item = Item.find(params[:item_id])
    @order_info = OrderInfo.new(order_info_params)

    if @order_info.valid?
      pay_item
      @order_info.save
      redirect_to root_path
    else
      render action: :index
    end
  end

  private

  def order_info_params
    params.require(:order_info).permit(:post_code, :prefecture_id, :city, :house_number, :building_name,
                                       :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  def pay_item
    @item = Item.find(params[:item_id])
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']  # 秘密鍵を代入
    Payjp::Charge.create(
      amount: @item.price, # 決済情報を保存するためのメソッド
      card: order_info_params[:token], # カードトークン
      currency: 'jpy'              # 通貨の種類（日本円）
    )
  end
end
