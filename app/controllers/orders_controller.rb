class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  layout 'order_layout'

  # GET /order/new
  def new
    @order = Order.new
  end

  # GET /oders
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
    # @customer = Customer.new(customer_params)
    #
    # respond_to do |format|
    #   if @customer.save
    #     format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
    #     format.json { render :show, status: :created, location: @customer }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @customer.errors, status: :unprocessable_entity }
    #   end
    # end

    # @customer = Customer.new(customer_params)
    # @customer.save
    # flash.notice = "The customer record was created successfully."
    # redirect_to @customer

    # create Method with Error Handling:
    # If @customer.save return non-nil values, that means they succeeded,
    # and we can redirect back to the show page with a success message.
    # If they return nil, we have the else processing:
    # First collect the error and put it in the flash.now.alert
    # Then do the render, which basically means put the previous screen back up.
    @order = Order.new(customer_params)
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
    # respond_to do |format|
    #   if @customer.update(customer_params)
    #     format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @customer }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @customer.errors, status: :unprocessable_entity }
    #   end
    # end

    # @customer.update(customer_params)
    # flash.notice = "The customer record was updated successfully."
    # redirect_to @customer

    # update Method with Error Processing
    # If @customer.update return non-nil values, that means they succeeded,
    # and we can redirect back to the show page with a success message.
    # If they return nil, we have the else processing:
    # First collect the error and put it in the flash.now.alert
    # Then do the render, which basically means put the previous screen back up.
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
      params.require(:order).permit(:product_name, :product_count, :customer)
    end

    def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to orders_path
    end
end
