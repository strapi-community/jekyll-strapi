require 'jekyll'
require 'jekyll/strapi/strapihttp'
require 'jekyll/strapi/collection'
require 'jekyll/strapi/collection_permalink'
require 'jekyll/strapi/drops'
require 'jekyll/tags/strapiimagefilter'
require "test/unit"
require 'jekyll/tags/strapiimagefilter'
require 'liquid/template'

##
# Okay, so there is a lot of DRY (Do Repeat Yourself) - but it is working and code
# will improve in time - more modular.

## Helper methods
def setup_collection
  @config_site = {"source"=>"#{Dir.getwd}", "destination"=>"#{Dir.getwd}/_site", "collections_dir"=>"", "cache_dir"=>".jekyll-cache", "plugins_dir"=>"_plugins", "layouts_dir"=>"_layouts", "data_dir"=>"_data", "includes_dir"=>"_includes", "collections"=>{"posts"=>{"output"=>true, "permalink"=>"/:categories/:year/:month/:day/:title:output_ext"}}, "safe"=>false, "include"=>[".htaccess"], "exclude"=>[".sass-cache", ".jekyll-cache", "gemfiles", "Gemfile", "Gemfile.lock", "node_modules", "vendor/bundle/", "vendor/cache/", "vendor/gems/", "vendor/ruby/"], "keep_files"=>[".git", ".svn"], "encoding"=>"utf-8", "markdown_ext"=>"markdown,mkdown,mkdn,mkd,md", "strict_front_matter"=>false, "show_drafts"=>nil, "limit_posts"=>0, "future"=>false, "unpublished"=>false, "whitelist"=>[], "plugins"=>["jekyll-feed", "jekyll-strapi"], "markdown"=>"kramdown", "highlighter"=>"rouge", "lsi"=>false, "excerpt_separator"=>"\n\n", "incremental"=>false, "detach"=>false, "port"=>"4000", "host"=>"127.0.0.1", "baseurl"=>"", "show_dir_listing"=>false, "permalink"=>"date", "paginate_path"=>"/page:num", "timezone"=>nil, "quiet"=>false, "verbose"=>true, "defaults"=>[], "liquid"=>{"error_mode"=>"warn", "strict_filters"=>false, "strict_variables"=>false}, "kramdown"=>{"auto_ids"=>true, "toc_levels"=>[1, 2, 3, 4, 5, 6], "entity_output"=>"as_char", "smart_quotes"=>"lsquo,rsquo,ldquo,rdquo", "input"=>"GFM", "hard_wrap"=>false, "guess_lang"=>true, "footnote_nr"=>1, "show_warnings"=>false}, "title"=>"Your awesome title", "description"=>"Write an awesome description for your new site here. You can edit this line in _config.yml. It will appear in your document head meta (for Google search results) and in your feed.xml site description.", "url"=>"", "theme"=>"minima", "strapi"=>{"endpoint"=>"http://localhost:1337", "collections"=>{"posts"=>{"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true}}}, "serving"=>false}
  @site = Jekyll::Site.new(@config_site)
  @collection_name = "posts"
end

##
# Monkey patching of the Down module to allow
# smooth execution of the filter during the UnitTests

module Down
  module_function

  class Down
    VERSION = 0
    class ConnectionError
    end
  end

  def download(*args, **options, &block)
    Jekyll.logger.info "STRAPI TESTS:" "MonkeyPatch Down::download"
  end

  def open(*args, **options, &block)
    Jekyll.logger.info "STRAPI TESTS:" "MonkeyPatch Down::open"
  end

  def backend(value = nil)
    Jekyll.logger.info "STRAPI TESTS:" "MonkeyPatch Down::backend"
  end
end

##
# Some 'mocks', likely to be rewritten

module Jekyll
  module Strapi
    class StrapiCollectionMock
      # attr_accessor :collection_name, :config

      def initialize
        @config_site = {"source"=>"/tmp/jekyll-strapi-src", "destination"=>"/tmp/jekyll-strapi-src/_site", "collections_dir"=>"", "cache_dir"=>".jekyll-cache", "plugins_dir"=>"_plugins", "layouts_dir"=>"_layouts", "data_dir"=>"_data", "includes_dir"=>"_includes", "collections"=>{"posts"=>{"output"=>true, "permalink"=>"/:categories/:year/:month/:day/:title:output_ext"}}, "safe"=>false, "include"=>[".htaccess"], "exclude"=>[".sass-cache", ".jekyll-cache", "gemfiles", "Gemfile", "Gemfile.lock", "node_modules", "vendor/bundle/", "vendor/cache/", "vendor/gems/", "vendor/ruby/"], "keep_files"=>[".git", ".svn"], "encoding"=>"utf-8", "markdown_ext"=>"markdown,mkdown,mkdn,mkd,md", "strict_front_matter"=>false, "show_drafts"=>nil, "limit_posts"=>0, "future"=>false, "unpublished"=>false, "whitelist"=>[], "plugins"=>["jekyll-feed", "jekyll-strapi"], "markdown"=>"kramdown", "highlighter"=>"rouge", "lsi"=>false, "excerpt_separator"=>"\n\n", "incremental"=>false, "detach"=>false, "port"=>"4000", "host"=>"127.0.0.1", "baseurl"=>"", "show_dir_listing"=>false, "permalink"=>"date", "paginate_path"=>"/page:num", "timezone"=>nil, "quiet"=>false, "verbose"=>true, "defaults"=>[], "liquid"=>{"error_mode"=>"warn", "strict_filters"=>false, "strict_variables"=>false}, "kramdown"=>{"auto_ids"=>true, "toc_levels"=>[1, 2, 3, 4, 5, 6], "entity_output"=>"as_char", "smart_quotes"=>"lsquo,rsquo,ldquo,rdquo", "input"=>"GFM", "hard_wrap"=>false, "guess_lang"=>true, "footnote_nr"=>1, "show_warnings"=>false}, "title"=>"Your awesome title", "description"=>"Write an awesome description for your new site here. You can edit this line in _config.yml. It will appear in your document head meta (for Google search results) and in your feed.xml site description.", "url"=>"", "theme"=>"minima", "strapi"=>{"endpoint"=>"http://localhost:1337", "collections"=>{"photos"=>{"permalink"=>"/photos/:id/", "layout"=>"photo.html", "output"=>true}}}, "serving"=>false}
        @collection_name = "photos"
        @config = '{"permalink"=>"/photos/:id/", "layout"=>"photo.html", "output"=>true}'
        @site = Jekyll::Site.new(@config_site)

        Jekyll.logger.info "Jekyll MOCK Collection init:" "#{@site} #{@collection_name} #{@config}"
      end

      def generate?
        @config['output'] || false
      end

      def get_data
          file = File.read('test/source/_data/photos.json')
          response = JSON.parse(file, object_class: OpenStruct)
          Jekyll.logger.info  "STRAPI TEST RESPONSE:" "#{response}"
          response.data
      end

      def get_document(did)
          file = File.read('test/source/_data/photo.01.json')
          response = JSON.parse(file, object_class: OpenStruct)
          Jekyll.logger.debug "StrapiCollection GET_DOCUMENT:" "#{response} #{did}"
          response
      end

      def each
        data = get_data
        data.each do |document|
          ##
          # This should matach what is inside collection.rb
          # TODO: make it modular co same code can be reused
          Jekyll.logger.debug "StrapiCollection iterating over document:" "#{@collection_name} #{document.id}"
          document.type = @collection_name
          document.collection = @collection_name
          document.id ||= document._id
          document_response = get_document(document.id)
          # We will keep all the attributes in strapi_attributes
          document.strapi_attributes = document_response['data']["attributes"]
          Jekyll.logger.info "STRAPI COLLECTION MOCK:" "#{document}"
          document.url = @site.strapi_link_resolver(@collection_name, document)
        end
        data.each {|x| yield(x)}
      end
    end
  end
end

##
# This code is working, but is very messy. It is late,
# so I will clean up the  other day. But first prof of concept
# of the working and useful unittest is here!

class TestCreateStrapiCollection < Test::Unit::TestCase
    def setup
        @collection = Jekyll::Strapi::StrapiCollectionMock.new()
        @my_array = @collection.each{|i|}
        @document = @my_array[0]
        Jekyll.logger.info "STRAPI-Jekyll TEST document:" "#{@document}"
        @drop = Jekyll::Strapi::StrapiDocumentDrop.new(@document)
        Jekyll.logger.info "STRAPI-Jekyll TEST drop:" "#{@drop}"

        @filter = Object.new.extend(Jekyll::StrapiImageFilter)
        @template = Liquid::Template.parse("{{ document.strapi_attributes.Image.data.attributes.formats.thumbnail  |asset_url}}")
        # @template.render!(@info, {registers:{:site=>"a", :b=>"aa", :page=>{"document"=>@drop}, :config=>{}}})
        @context = Liquid::Context.new()
        @context['document'] = @drop
        # a = @filter.asset_url(@drop)
    end

    def test_create

        @config_site = {"source"=>"/tmp/jekyll-strapi-src", "destination"=>"/tmp/jekyll-strapi-src/_site", "collections_dir"=>"", "cache_dir"=>".jekyll-cache", "plugins_dir"=>"_plugins", "layouts_dir"=>"_layouts", "data_dir"=>"_data", "includes_dir"=>"_includes", "collections"=>{"posts"=>{"output"=>true, "permalink"=>"/:categories/:year/:month/:day/:title:output_ext"}}, "safe"=>false, "include"=>[".htaccess"], "exclude"=>[".sass-cache", ".jekyll-cache", "gemfiles", "Gemfile", "Gemfile.lock", "node_modules", "vendor/bundle/", "vendor/cache/", "vendor/gems/", "vendor/ruby/"], "keep_files"=>[".git", ".svn"], "encoding"=>"utf-8", "markdown_ext"=>"markdown,mkdown,mkdn,mkd,md", "strict_front_matter"=>false, "show_drafts"=>nil, "limit_posts"=>0, "future"=>false, "unpublished"=>false, "whitelist"=>[], "plugins"=>["jekyll-feed", "jekyll-strapi"], "markdown"=>"kramdown", "highlighter"=>"rouge", "lsi"=>false, "excerpt_separator"=>"\n\n", "incremental"=>false, "detach"=>false, "port"=>"4000", "host"=>"127.0.0.1", "baseurl"=>"", "show_dir_listing"=>false, "permalink"=>"date", "paginate_path"=>"/page:num", "timezone"=>nil, "quiet"=>false, "verbose"=>true, "defaults"=>[], "liquid"=>{"error_mode"=>"warn", "strict_filters"=>false, "strict_variables"=>false}, "kramdown"=>{"auto_ids"=>true, "toc_levels"=>[1, 2, 3, 4, 5, 6], "entity_output"=>"as_char", "smart_quotes"=>"lsquo,rsquo,ldquo,rdquo", "input"=>"GFM", "hard_wrap"=>false, "guess_lang"=>true, "footnote_nr"=>1, "show_warnings"=>false}, "title"=>"Your awesome title", "description"=>"Write an awesome description for your new site here. You can edit this line in _config.yml. It will appear in your document head meta (for Google search results) and in your feed.xml site description.", "url"=>"", "theme"=>"minima", "strapi"=>{"endpoint"=>"http://localhost:1337", "collections"=>{"photos"=>{"permalink"=>"/photos/:id/", "layout"=>"photo.html", "output"=>true}}}, "serving"=>false}
        # @config = '{"permalink"=>"/photos/:id/", "layout"=>"photo.html", "output"=>true}'
        @site = Jekyll::Site.new(@config_site)
        # @template.render!(@context,  {registers:{:site=>"v", :b=>"aa", :page=>{"document"=>@drop}, :config=>{}}}
        a = @template.render!({"document"=>@drop}, {registers:{:site=>@site, :b=>"aa", :page=>{"document"=>@drop}, :config=>{}}})
        # @template.render!({}, registers={:site=>"v", :b=>"aa", :page=>{"document"=>@drop}, :config=>{}})

        assert_equal(a, "/assets/thumbnail_NoRight.JPG")
    end
end

class TestStrapiCollectionEndpoint < Test::Unit::TestCase
  def setup
    setup_collection
  end

  def test_default
    @config = {"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true}
    @collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, @config)

    assert_equal("posts", @collection.endpoint)
  end

  def test_given
    @config = {"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true, "type"=>"other_posts"}
    @collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, @config)

    assert_equal("other_posts", @collection.endpoint)
  end
end

class TestStrapiCollectionPopulate < Test::Unit::TestCase
  def setup
    setup_collection
  end

  def test_default
    @config = {"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true}
    @collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, @config)

    assert_equal("*", @collection.populate)
  end

  def test_given
    @config = {"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true, "populate"=>"deep"}
    @collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, @config)

    assert_equal("deep", @collection.populate)
  end
end

class TestStrapiCollectionPathParams < Test::Unit::TestCase
  def setup
    setup_collection
  end

  def test_default
    @config = {"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true}
    @collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, @config)

    assert_equal("", @collection.path_params)
  end

  def test_given
    @config = {"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true, "parameters"=>{"sort"=>"publicationDate:desc"}}
    @collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, @config)

    assert_equal("?&sort=publicationDate:desc", @collection.path_params)
  end
end

class TestStrapiCollectionPermalinkParams < Test::Unit::TestCase
  def setup
    setup_collection

    config = {"permalink"=>"/blog/:slug/", "permalinks"=>{"pl"=>"/poradnik/:slug/"}, "layout"=>"post.html", "output"=>true}
    collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, config)

    no_permalink_config = {"layout"=>"post.html", "output"=>true}
    no_permalink_collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, no_permalink_config)

    @permalink = Jekyll::Strapi::StrapiCollectionPermalink.new(collection: collection)
    @permalink_pl = Jekyll::Strapi::StrapiCollectionPermalink.new(collection: collection, lang: "pl")
    @no_permalink = Jekyll::Strapi::StrapiCollectionPermalink.new(collection: no_permalink_collection)
  end

  def test_directory
    assert_equal("posts", @permalink.directory)
    assert_equal("poradnik", @permalink_pl.directory)
    assert_equal("posts", @no_permalink.directory)
  end

  def test_exist?
    assert @permalink.exist?
    assert @permalink_pl.exist?
    assert_false @no_permalink.exist?
  end

  def test_to_s
    assert_equal("/blog/:slug/", @permalink.to_s)
    assert_equal("/poradnik/:slug/", @permalink_pl.to_s)
    assert_nil(@no_permalink.to_s)
  end
end
