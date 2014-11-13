module MagentoApi

	@client = Savon.client(wsdl: MAGE_CONFIG['wsdlurl'], logger: Rails.logger, log: true, convert_request_keys_to: :none, :log_level => :debug )

	def self.get_session(refresh = false)
		@session_id = nil if refresh

		unless @session_id
			begin
				response = @client.call :login, message: { :username => MAGE_CONFIG['user'], :apiKey => MAGE_CONFIG['pass'] }
			rescue Savon::Error => soap_fault
  				print "Error: #{soap_fault}\n"
			end

	        if response.nil?
	        	raise soap_fault
	      	else
	      		data = response.to_array(:login_response).first
	      	end

	      	@session_id = data[:login_return]
	    end

	  	@session_id
	end

	def self.allproducts
	  @session_id = get_session

	  products = @client.call(:catalog_product_list, message: { sessionId: @session_id, storeView: '1' })

	  if products.success? == false
	    puts "login failed"
	  else
	  	data = products.to_array(:catalog_product_list_response).first
	  end

	  @products = data[:store_view]
	end

	def self.getcustomers
	  @session_id = get_session

	  customers = @client.call(:customer_customer_list, message: { sessionId: @session_id })

	  if customers.success? == false
	    puts "login failed"
	  else
	  	data = customers.to_array(:customer_customer_list_response).first
	  end

	  @customers = data[:store_view]
	end

	def self.getorders
	  @session_id = get_session

	  orders = @client.call(:sales_order_list, message: { sessionId: @session_id })

	  if orders.success? == false
	    puts "Cannot Get Orders"
	  else
	  	data = orders.to_array(:sales_order_list_response).first
	  end

	  @orders = data[:result]
	end

	def self.createproduct(product_attributes, sku, file_data = false)
		@session_id = get_session
		product = @client.call(:catalog_product_create, message: { :sessionId => @session_id, :type => 'simple', :set => '4', :sku => sku, :productData => product_attributes, storeView: '1' })

		if product.success? == false
		  puts "Cannot Create Product"
		else
			data = product.to_array
		end

		if file_data
			product_image(file_data, data)
		end

		# update_product(data[0][:catalog_product_create_response][:result], product_attributes[0][:stock_data])
	end

	def self.product_image(file_data, data)
		@session_id = get_session
		# raise data.inspect
		image = @client.call(:catalog_product_attribute_media_create, message: { :sessionId => @session_id, :product =>  data[0][:catalog_product_create_response][:result], :data => file_data, storeView: '1', identifierType: 'id'})
	end

	def self.update_product(product_attributes, id, file_data = false)
		@session_id = get_session

		product = @client.call(:catalog_product_update, message: { :sessionId => @session_id, :product => id, :productData => product_attributes, storeView: '1', identifierType: 'id' })

	end

	def self.getproduct(product_id)
		@session_id = get_session

		product = @client.call(:catalog_product_info, message: { sessionId: @session_id, productId: product_id, storeView: '1', identifierType: 'id'})

		if product.success? == false
		  puts "Cannot Select Product"
		else
			data = product.to_array(:catalog_product_info_response).first
		end

		@product = data[:info]
	end

	def self.image_url(product_id)
		@session_id = get_session

		image = @client.call(:catalog_product_attribute_media_list, message: { sessionId: @session_id, product: product_id, storeView: '1', identifierType: 'id' })

		if image.success? == false
		  puts "Cannot Select Product"
		else
			data = image.to_array(:catalog_product_attribute_media_list_response).first
		end

		@image = data[:result][:item]
	end

	def self.getcategories(parent_id)
		@session_id = get_session

		category = @client.call(:catalog_category_tree, message: { sessionId: @session_id, parentId: parent_id, storeView: '1' })

		if category.success? == false
		  puts "Cannot Select Category"
		else
			data = category.to_array(:catalog_category_tree_response).first
		end

		@categories = data[:tree]
	end

	def self.stock_list(products)
		@session_id = get_session

		stock = @client.call(:catalog_inventory_stock_item_list, message: { sessionId: @session_id, products: products })

		if stock.success? == false
		  puts "Cannot Select Stock Info"
		else
			data = stock.to_array(:catalog_inventory_stock_item_list_response).first
		end

		@stock = data[:result]
	end

	def self.store
		@session_id = get_session

		store = @client.call(:store_list, message: { sessionId: @session_id })

		if store.success? == false
		  puts "Cannot Select Store Info"
		else
			data = store.to_array(:store_list_response).first
		end

		@store = data[:stores]
	end

	def self.delete_product(product_id)
		@session_id = get_session
		product = @client.call(:catalog_product_delete, message: { sessionId: @session_id, :product => product_id, identifierType: 'id' })
	end

end