require 'jekyll'
require "test/unit"

## Helper methods
def setup_page
  # Duplicate with setup_collection helper method
  @config_site = {"source"=>"#{Dir.getwd}", "destination"=>"#{Dir.getwd}/_site", "collections_dir"=>"", "cache_dir"=>".jekyll-cache", "plugins_dir"=>"_plugins", "layouts_dir"=>"_layouts", "data_dir"=>"_data", "includes_dir"=>"_includes", "collections"=>{"posts"=>{"output"=>true, "permalink"=>"/:categories/:year/:month/:day/:title:output_ext"}}, "safe"=>false, "include"=>[".htaccess"], "exclude"=>[".sass-cache", ".jekyll-cache", "gemfiles", "Gemfile", "Gemfile.lock", "node_modules", "vendor/bundle/", "vendor/cache/", "vendor/gems/", "vendor/ruby/"], "keep_files"=>[".git", ".svn"], "encoding"=>"utf-8", "markdown_ext"=>"markdown,mkdown,mkdn,mkd,md", "strict_front_matter"=>false, "show_drafts"=>nil, "limit_posts"=>0, "future"=>false, "unpublished"=>false, "whitelist"=>[], "plugins"=>["jekyll-feed", "jekyll-strapi"], "markdown"=>"kramdown", "highlighter"=>"rouge", "lsi"=>false, "excerpt_separator"=>"\n\n", "incremental"=>false, "detach"=>false, "port"=>"4000", "host"=>"127.0.0.1", "baseurl"=>"", "show_dir_listing"=>false, "permalink"=>"date", "paginate_path"=>"/page:num", "timezone"=>nil, "quiet"=>false, "verbose"=>true, "defaults"=>[], "liquid"=>{"error_mode"=>"warn", "strict_filters"=>false, "strict_variables"=>false}, "kramdown"=>{"auto_ids"=>true, "toc_levels"=>[1, 2, 3, 4, 5, 6], "entity_output"=>"as_char", "smart_quotes"=>"lsquo,rsquo,ldquo,rdquo", "input"=>"GFM", "hard_wrap"=>false, "guess_lang"=>true, "footnote_nr"=>1, "show_warnings"=>false}, "title"=>"Your awesome title", "description"=>"Write an awesome description for your new site here. You can edit this line in _config.yml. It will appear in your document head meta (for Google search results) and in your feed.xml site description.", "url"=>"", "theme"=>"minima", "strapi"=>{"endpoint"=>"http://localhost:1337", "collections"=>{"posts"=>{"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true}}}, "serving"=>false}
  @site = Jekyll::Site.new(@config_site)
  @collection_name = "posts"

  @config = {"permalink"=>"/blog/:slug/", "layout"=>"post.html", "output"=>true}
  @collection = Jekyll::Strapi::StrapiCollection.new(@site, @collection_name, @config)

  @base = "/test"
  @document = OpenStruct.new(
    id: "1",
    attributes: OpenStruct.new(slug: "first-post")
  )

  @strapi_page = Jekyll::Strapi::StrapiPage.new(@site, @base, @document, @collection)
end

class TestStrapiPageUrlPlaceholder < Test::Unit::TestCase
  def setup
    setup_page
  end

  def test_url_placeholder
    assert_equal("1", @strapi_page.url_placeholders[:id])
    assert_equal("first-post", @strapi_page.url_placeholders[:slug])
    assert_equal(nil, @strapi_page.url_placeholders[:other])
  end
end
