require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do

  describe "#all" do

    it "returns all customers" do
      2.times do |x|
        Customer.create(first_name: "customer#{x}")
      end

      get :index, format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe "#random" do

    it "returns a random customer" do
      20.times do |x|
        Customer.create!(first_name: "customer#{x}")
      end

      duplicate_customers = 0

      40.times do
        get :random, format: :json
        m1 = (JSON.parse(response.body)['id'])
        get :random, format: :json
        m2 = (JSON.parse(response.body)['id'])

        duplicate_customers += 1 if m1 == m2
      end

      expect(response).to have_http_status(:success)
      expect(duplicate_customers).to be < 10
    end
  end

  describe "#show" do
    it "returns a customer" do
      customer = Customer.create(first_name: "customer1")

      get :show, id: customer.id, format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['first_name']).to eq('customer1')
    end
  end

  describe "#find" do
    it "finds a single customer that matches a query param" do
      customer = Customer.create(first_name: "customer1")

      get :find, id: customer.id, format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['first_name']).to eq('customer1')
    end
  end

  describe "#find_all" do
    it "returns all customers with the same attribute" do

      customer = Customer.create(first_name: "customer1")
      Customer.create(first_name: "customer1")
      Customer.create(first_name: "customer1")
      Customer.create(first_name: "customer2")

      get :find_all, first_name: 'customer1', format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "#invoices" do
    it 'returns the customers invoices' do
      customer = Customer.create(first_name: "customer1")
      2.times do
        customer.invoices.create!(status: "success")
      end

      get :invoices, id: customer.id, format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

end
