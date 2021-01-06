class OrdersController < ApplicationController
  before_action :set_item, only: [:index, :create]
  before_action :authenticate_user!, only: :index

  def index
    @order_info = OrderInfo.new
    if @item.user_id == current_user.id || @item.order.present?
      redirect_to root_path 
    end
  end

  def create
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

  def set_item
    @item = Item.find(params[:item_id])
  end

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
