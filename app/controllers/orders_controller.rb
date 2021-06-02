class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /order/new
  def new
    @order = Order.new
  end

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /oders/1
  # GET /oders/1.json
  def show
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    # @order = Order.new(order_params)
    # @order.save
    # flash.notice = "The order record was created successfully."
    # redirect_to @order

    # create Method with Error Handling:
    # If @order.save return non-nil values, that means they succeeded,
    # and we can redirect back to the show page with a success message.
    # If they return nil, we have the else processing:
    # First collect the error and put it in the flash.now.alert
    # Then do the render to :new.
    @order = Order.new(order_params)
    if @order.save
      flash.notice = "The order record was created successfully."
      redirect_to @order
    else
      flash.now.alert = @order.errors.full_messages.to_sentence
      render :new
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    # @order.update(order_params)
    # flash.notice = "The order record was updated successfully."
    # redirect_to @order

    # update Method with Error Processing
    # If @order.update return non-nil values, that means they succeeded,
    # and we can redirect back to the show page with a success message.
    # If they return nil, we have the else processing:
    # First collect the error and put it in the flash.now.alert
    # Then do the render to :edit.
    if @order.update(order_params)
      flash.notice = "The order record was updated successfully."
      redirect_to @order
    else
      flash.now.alert = @order.errors.full_messages.to_sentence
      render :edit
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:product_name, :product_count, :customer_id)
    end

    def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to new_order_path
    end
end
