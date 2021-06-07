require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "GET /orders" do
    it "returns http success" do
      get orders_path
      expect(response).to have_http_status(200)
    end
  end
end

RSpec.describe "OrdersControllers", type: :request do
  describe "GET /orders" do
    it "renders the orders view (index)" do
      FactoryBot.create_list(:order, 10)
      get orders_path
      expect(response).to render_template(:index)
    end
  end
  describe "get order path" do
    it "renders the :show template" do
      order = FactoryBot.create(:order)
      get order_path(id: order.id)
      expect(response).to render_template(:show)
    end
    it "redirects to the orders (index) path if the order id is invalid" do
      get order_path(id: 5000) #an ID that doesn't exist
      expect(response).to redirect_to orders_path
    end
  end
  describe "get new order path" do
    it "renders the :new template" do
      get new_order_path
      expect(response).to render_template(:new)
    end
  end
  describe "get edit order path" do
    it "renders the :edit template" do
      order = FactoryBot.create(:order)
      get edit_order_path(id: order.id)
      expect(response).to render_template(:edit)
    end
  end
  describe "post order path with valid data" do
    it "saves a new order and redirects to the show path for the order" do
      customer = FactoryBot.create(:customer)
      order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
      expect { post orders_path, params: {order: order_attributes} }.to change(Order, :count)
      expect(response).to redirect_to order_path(id: Order.last.customer_id)
    end
  end

  describe "post order path with invalid data" do
     it "does not save a new order or redirect if invalid customer id" do
       customer = FactoryBot.create(:customer)
       order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
       order_attributes.delete(:customer_id)
       expect { post orders_path, params: {order: order_attributes} }.to_not change(Order, :count)
       expect(response).to render_template(:new)
     end
     it "does not save a new order or redirect if invalid product name" do
       customer = FactoryBot.create(:customer)
       order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
       order_attributes.delete(:product_name)
       expect { post orders_path, params: {order: order_attributes} }.to_not change(Order, :count)
       expect(response).to render_template(:new)
     end
     it "does not save a new order or redirect if invalid product count" do
       customer = FactoryBot.create(:customer)
       order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
       order_attributes.delete(:product_count)
       expect { post orders_path, params: {order: order_attributes} }.to_not change(Order, :count)
       expect(response).to render_template(:new)
     end
  end

  describe "put order_path with valid data" do
    it "updates an entry and redirects to the show path for the customer" do
      order = FactoryBot.create(:order)
      put "/orders/#{order.id}", params: {order: {product_count: 50}}
      order.reload
      expect(order.product_count).to eq(50)
      expect(response).to redirect_to("/orders/#{order.id}")
    end
  end
  describe "put order_path with invalid data" do
    it "does not update the customer record or redirect" do
      order = FactoryBot.create(:order)
      put "/orders/#{order.id}", params: {order: {customer_id: 5001}}
      order.reload
      expect(order.customer_id).not_to eq(5001)
      expect(response).to render_template(:edit)
    end
  end
  describe "delete an order record" do
    it "deletes an order record" do
      order = FactoryBot.create(:order)
      delete order_path(order.id)
      expect(response).to redirect_to orders_path
    end
  end
end
