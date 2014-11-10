class HomeController < ApplicationController

	# include MagentoApi
	require 'magento_api'

	def index
		@products = MagentoApi.allproducts
		# @customers = MagentoApi.getcustomers
		# @orders = MagentoApi.getorders
	end

	def view
		@product = MagentoApi.getproduct(params[:id])
		@image_url = MagentoApi.image_url(params[:id])
		@stock = MagentoApi.stock_list(Array.wrap([:product_id => params[:id]]))
	end

	def customers
		@customers = MagentoApi.getcustomers
	end

	def orders
		@orders = MagentoApi.getorders
	end

	def new_product
		@categories = MagentoApi.getcategories('2')
		@store = MagentoApi.store
	end

	def save
		websites = params[:product_websites].collect{|k| {:complexObjectArray => k}}
		categories = params[:product_category].collect{|k| {:complexObjectArray => k}}

		@product_data = [{:name => params[:product_name], :price => params[:product_price], :special_price => params[:product_special_price], :status => params[:product_status], :short_description => params[:product_short_description], :description => params[:product_description], :url_key => params[:product_url_key], :weight => params[:product_weight], :tax_class_id => params[:product_tax_class], :meta_title => params[:product_meta_title], :meta_description => params[:product_meta_description], :stock_data => [{:qty => params[:product_qty], :is_in_stock => params[:product_stock_availability]}], :websites => websites, :categories => categories }]

		@product = MagentoApi.createproduct(@product_data, params[:product_sku])

		redirect_to root_url
	end

end
