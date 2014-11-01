module MagentoApi

	def self.get_session
		client = Savon.client(wsdl: 'http://localhost/rails_magento/magento/index.php/api/v2_soap?wsdl=1')

	  	response = client.call :login, message: { :username => 'ironman', :apiKey => 'admin@123' }

        if response.success? == false
        	puts "login failed"
      	else
      		data = response.to_array(:login_response).first
      	end

	  	@session_id = data[:login_return]
	end

	def self.allproducts
	  client = Savon.client(wsdl: 'http://localhost/rails_magento/magento/index.php/api/v2_soap?wsdl=1')

	  @session_id = get_session

	  products = client.call(:catalog_product_list, message: { sessionId: @session_id, storeView: '1' })

	  if products.success? == false
	    puts "login failed"
	  else
	  	data = products.to_array(:catalog_product_list_response).first
	  end

	  @products = data[:store_view]
	end

	def self.getcustomers
	  client = Savon.client(wsdl: 'http://localhost/rails_magento/magento/index.php/api/v2_soap?wsdl=1')

	  @session_id = get_session

	  customers = client.call(:customer_customer_list, message: { sessionId: @session_id })

	  if customers.success? == false
	    puts "login failed"
	  else
	  	data = customers.to_array(:customer_customer_list_response).first
	  end

	  @customers = data[:store_view]
	end

	def self.getorders
	  client = Savon.client(wsdl: 'http://localhost/rails_magento/magento/index.php/api/v2_soap?wsdl=1')

	  @session_id = get_session

	  orders = client.call(:sales_order_list, message: { sessionId: @session_id })

	  if orders.success? == false
	    puts "Cannot Get Orders"
	  else
	  	data = orders.to_array(:sales_order_list_response).first
	  end

	  @orders = data[:result]
	end

	def self.createproduct(product_attributes)
		client = Savon.client(wsdl: 'http://localhost/rails_magento/magento/index.php/api/v2_soap?wsdl=1')
		@session_id = get_session

		product = client.call(:catalog_product_create, message: { sessionId: @session_id })

		if product.success? == false
		  puts "Cannot Create Product"
		else
			data = product.to_array
		end

		@product = data[:result]
	end

	def self.getproduct(product_id)
		client = Savon.client(wsdl: 'http://localhost/rails_magento/magento/index.php/api/v2_soap?wsdl=1')
		@session_id = get_session

		product = client.call(:catalog_product_info, message: { sessionId: @session_id, productId: product_id, storeView: '1', identifierType: 'id'})

		if product.success? == false
		  puts "Cannot Select Product"
		else
			data = product.to_array(:catalog_product_info_response).first
		end

		@product = data[:info]
	end

end