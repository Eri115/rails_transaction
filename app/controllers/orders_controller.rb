class OrdersController < ApplicationController
  def index
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc)
  end

  def new
    @order = Order.new
    @order.ordered_lists.build
    @items = Item.all.order(:created_at)
  end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build(order_params)  #①
      @order.save!
      #@order.save   #②
      @order.update_total_quantity  #③　
      redirect_to orders_path
    end
  end
  #①ログイン中のユーザーのオーダーをパラーメータで取得
  #②オーダーをデータベースに保存
  #③注文された商品の数量を集計し、その合計数量を @order オブジェクトの total_quantity フィールドに反映
  #update_total_quantityメソッドは、注文された発注量を総量に反映するメソッドであり、Orderモデルに定義されています。



  private

  def order_params
    params.require(:order).permit(ordered_lists_attributes: [:item_id, :quantity])
  end

end
