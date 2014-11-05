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

end
