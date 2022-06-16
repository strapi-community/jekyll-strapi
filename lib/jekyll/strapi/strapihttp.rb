##
# This is a helper method to authenticate during getting data from Strapi instance.
require "json"

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
    Jekyll.logger.info "Jekyll StrapiHTTP:", "Fetching entries from #{uri} using headers: #{headers.keys}"
    response = Net::HTTP.get_response(uri, headers)

    ##
    # Response structure
    # https://docs.strapi.io/developer-docs/latest/developer-resources/database-apis-reference/rest-api.html#unified-response-format
    # - data
    # - meta
    # - error
    # TODO: add checking error and the meta and act if necessart

    # Check response code
    if response.code == "200"
        response_json = JSON.parse(response.body, object_class: OpenStruct)
        return response_json
    elsif response.code == "401"
        raise "The Strapi server sent a error with the following status: 401. Please make sure that your credentials are correct or that you have access to the API."
    elsif response.code == "403"
        raise "The Strapi server sent a error with the following status: 403. Please provide STRAPI_TOKEN or allow public access for find and findOne actions."
    elsif response.code == "403"
        raise "The Strapi server sent a error with the following status: 404. Please make sure that name of your collection is correct."
    else
        raise "The Strapi server sent a error with the following status: #{response.code}. Please make sure it is correctly running."
    end
end