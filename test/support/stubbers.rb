def valid_stripe_charge_object
  {
    "id": "ch_16HMo32eZvKYlo2CN0EYDD5k",
   "object": "charge",
   "created": 1435186643,
   "livemode": false,
   "paid": true,
   "status": "succeeded",
   "amount": 5000,
   "currency": "usd",
   "refunded": false,
   "source": {
               "id": "card_16HMo02eZvKYlo2CfsizBfho",
              "object": "card",
              "last4": "4242",
              "brand": "Visa",
              "funding": "credit",
              "exp_month": 12,
              "exp_year": 2016,
              "country": "US",
              "name": "gbr_brad@hotmail.com",
              "address_line1": nil,
              "address_line2": nil,
              "address_city": nil,
              "address_state": nil,
              "address_zip": nil,
              "address_country": nil,
              "cvc_check": "pass",
              "address_line1_check": nil,
              "address_zip_check": nil,
              "dynamic_last4": nil,
              "metadata": {
                          },
              "customer": "cus_6ULVKZxppyINJm"
             },
   "captured": true,
   "balance_transaction": "txn_16Esmv2eZvKYlo2CXxibx5gw",
   "failure_message": nil,
   "failure_code": nil,
   "amount_refunded": 0,
   "customer": "cus_6ULVKZxppyINJm",
   "invoice": nil,
   "description": nil,
   "dispute": nil,
   "metadata": {
               },
   "statement_descriptor": nil,
   "fraud_details": {
                    },
   "receipt_email": nil,
   "receipt_number": nil,
   "shipping": nil,
   "destination": nil,
   "application_fee": nil,
   "refunds": {
                "object": "list",
               "total_count": 0,
               "has_more": false,
               "url": "/v1/charges/ch_16HMo32eZvKYlo2CN0EYDD5k/refunds",
               "data": [

                       ]
              }
  }.to_json
end

def stripe_headers
  {'Accept'=>'*/*; q=0.5, application/xml'}
end

def tmdb_response
  {"page":1,"results":[{"adult":false,"backdrop_path":"/4j8WcrHfVtsM58w2mANtxwLWUvU.jpg","genre_ids":[12,35,14,10751],"id":11708,"original_language":"en","original_title":"Chitty Chitty Bang Bang","overview":"An eccentric professor invents wacky machinery, but can't seem to make ends meet. When he invents a revolutionary car, a foreign government becomes interested in it, and resorts to skulduggery to get their hands on it.","release_date":"1968-12-16","poster_path":"/m2z9NV6ZWXdWH6xdpF9yBJveEPa.jpg","popularity":0.416083,"title":"Chitty Chitty Bang Bang","video":false,"vote_average":6.4,"vote_count":54}],"total_pages":1,"total_results":1}.to_json
end

def set_net_stubs
  stub_request(:post, "https://api.stripe.com/v1/charges").
    with(:body => hash_including({"amount"=>/^[\.\d]+$/, "currency"=>"usd"}),
         headers: stripe_headers).
    to_return(:status => 200, :body => valid_stripe_charge_object)

  stub_request(:get, "http://api.themoviedb.org/3/search/movie").with(query: {query: 'chitty',
                                                                             api_key: Rails.application.secrets.tmdb_api_key},
                                                                      headers: {'Accept'=>'*/*'}).
    to_return(status: 200, body: tmdb_response)
end
