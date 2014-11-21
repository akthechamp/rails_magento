class HomeController < ApplicationController

	require 'magento_api'

	def index
		@products = MagentoApi.allproducts
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

		if !params[:file].nil?
			uploader = FormageUploader.new
			uploader.store!(params[:file])
			encoded_file = Base64.encode64(File.open(uploader.current_path).read)

			# raise uploader
			filenames = uploader.filename.split('.')
			# types_data = [{:complexObjectArray => 'thumbnail'}, {:complexObjectArray => 'small_image'}, {:complexObjectArray => 'image'}]
			# types_data = { :element => 'thumbnail', :element => 'small_image', :element => 'image' }
			types_data = ['image', 'small_image', 'thumbnail']
			# types_data = 'thumbnail'
			# file_data = [ file: {:content => encoded_file, :mime => uploader.content_type, :name => uploader.filename }, :label => filenames[0], :position => 0, :types => types_data, :exclude => 0 ]
			file_data = { file: {:content => encoded_file, :mime => uploader.content_type, :name => uploader.filename }, :label => filenames[0], :position => 0, :types => types_data, :exclude => 0 }
		end

		@product_data = {
			:name => params[:product_name],
			:price => params[:product_price],
			:special_price => params[:product_special_price],
			:status => params[:product_status].to_i,
			:short_description => params[:product_short_description],
			:description => params[:product_description],
			:url_key => params[:product_url_key],
			:url_path => '',
			:has_options => '',
			:gift_message_available => '',
			:special_from_date => '',
			:special_to_date => '',
			:tier_price => '',
			:custom_design => '',
			:custom_layout_update => '',
			:options_container => '',
			:additional_attributes => '',
			:weight => params[:product_weight],
			:tax_class_id => params[:product_tax_class].to_i,
			:meta_title => params[:product_meta_title],
			:meta_keyword => '',
			:meta_description => params[:product_meta_description],
			:stock_data => {
				:qty => params[:product_qty],
				:is_in_stock => params[:product_stock_availability].to_i,
				:manage_stock => '', :use_config_manage_stock => '',
				:min_qty => '',
				:use_config_min_qty => '',
				:min_sale_qty => 1,
				:use_config_min_sale_qty => '',
				:max_sale_qty => '',
				:use_config_max_sale_qty => '',
				:is_qty_decimal => '',
				:backorders => '',
				:use_config_backorders => '',
				:notify_stock_qty => '',
				:use_config_notify_stock_qty => ''
				},
			:websites => websites,
			:categories => categories,
			:visibility => 4
		}

		if params[:product_id].present?
			@product = MagentoApi.update_product(@product_data, params[:product_id], file_data)
		else
			@product = MagentoApi.createproduct(@product_data, params[:product_sku], file_data)
		end

		redirect_to root_url
	end

	def delete
		@product = MagentoApi.delete_product(params[:id])
		redirect_to root_url
	end

	def edit
		@product = MagentoApi.getproduct(params[:id])
		@image_url = MagentoApi.image_url(params[:id])
		@stock = MagentoApi.stock_list(Array.wrap([:product_id => params[:id]]))

		@categories = MagentoApi.getcategories('2')
		@store = MagentoApi.store
	end

end
