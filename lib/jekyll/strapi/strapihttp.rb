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
    Net::HTTP.get_response(uri, headers)
end