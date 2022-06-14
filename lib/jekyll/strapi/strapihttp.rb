##
# This is a helper method to authenticate during getting data from Strapi instance.

def strapi_request(url)
    strapi_token = ENV['STRAPI_TOKEN']
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{strapi_token}"
    headers = {
        'Authorization'=>"Bearer #{strapi_token}"
    }

    if strapi_token==nil
        Jekyll.logger.info "STRAPI_TOKEN not set, non Authenticated request."
    end
    Jekyll.logger.info "Jekyll StrapiHttp:", "Fetching entries from #{uri} using headers: #{headers.keys}"
    Net::HTTP.get_response(uri, headers)
end