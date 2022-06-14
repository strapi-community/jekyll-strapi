##
# This is a helper method to authenticate during getting data from Strapi instance.

def strapi_request(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)

    strapi_token = ENV['STRAPI_TOKEN']
    if strapi_token==nil
        Jekyll.logger.info "STRAPI_TOKEN not set, non Authenticated request."
        headers = {}
    else
        headers = {
            'Authorization'=>"Bearer #{strapi_token}"
        }
        req['Authorization'] = "Bearer #{strapi_token}"

    end
    Jekyll.logger.info "Jekyll StrapiHttp:", "Fetching entries from #{uri} using headers: #{headers.keys}"
    Net::HTTP.get_response(uri, headers)
end