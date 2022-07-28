# jekyll-strapi-4

This plugin is based on the [jekyll-strapi](https://github.com/strapi-community/jekyll-strapi/) plugin. 

![](deer-jekyll-strapi-4.png.png?raw=true)

## Features

* Support for Strapi 4
* Authentication
* Permalinks
* Caching and collecting assets from Strapi
* Added UnitTests
* Documentation in Jekyll format

## Install

Add the "jekyll-strapi" gem to your Gemfile:

```
gem "jekyll-strapi"
```

Then add "jekyll-strapi" to your plugins in `_config.yml`:

```
plugins:
    - jekyll-strapi
```

## Configuration

```yaml
strapi:
    # Your API endpoint (optional, default to http://localhost:1337)
    endpoint: http://localhost:1337
    # Collections, key is used to access in the strapi.collections
    # template variable
    collections:
        # Example for a "Photo" collection
        photos:
            # Collection name (optional)
            # type: photos
            # Permalink used to generate the output files (eg. /articles/:id).
            permalink: /photos/:id/
            # Parameters (optional)
            parameters:
              sort: title:asc
              pagination[pageSize]: 10
            # Populate page (optional, default "*")
            # populate: "*"
            # Layout file for this collection
            layout: photo.html
            # Generate output files or not (default: false)
            output: true
```

This works for the following collection *Photo* in Strapi:

| Name    | Type  |
| ------- | ----- |
| Title   | Text  |
| Image   | Media |
| Comment | Text  |

### Authentication

To access non Public collections (and by default all Strapi collections are non Public) you must to generate a token inside your strapi instance and set it as enviromental variable `STRAPI_TOKEN`.

It is recommended that you will use new Content API tokens for this task: https://strapi.io/blog/a-beginners-guide-to-authentication-and-authorization-in-strapi

## Usage

This plugin provides the `strapi` template variable. This template provides access to the collections defined in the configuration.

### Using Collections

Collections are accessed by their name in `strapi.collections`. The `articles` collections is available at `strapi.collections.articles`.

To list all documents of the collection ```_layouts/home.html```:

```
---
layout: default
---
<div class="home">
  <h1 class="page-heading">Photos</h1>
  {%- if strapi.collections.photos.size > 0 -%}
  <ul>
    {%- for photo in strapi.collections.photos -%}
    <li>
      <a href="{{ photo.url }}">Title: {{ photo.strapi_attributes.Title }}</a>
    </li>
    {%- endfor -%}
  </ul>
  {%- endif -%}
</div>
```

### Attributes

All object's data you can access through ``` {{ page.document.strapi_attributes }}```. This plugin also introduces new filter asset_url which perform downloading the asset into the assets folder and provides correct url. Thanks for this you have copies of your assets locally without extra dependency on Strapi ```_layouts/photo.html```:

```
---
layout: default
---

<div class="home">
  <h1 class="page-heading">{{ page.document.title }}</h1>
  <h2>{{ page.document.strapi_attributes.Title }}</h2>
  <p>{{ page.document.strapi_attributes.Comment }}</p>
  <img src="{{ page.document.strapi_attributes.Image.data.attributes.formats.thumbnail| asset_url }}"/>
</div>
```

### Request parameters

Define your request parameters in config files (check configuration).

If you want to add custom logic use custom_path_params method. You can use it by create _plugins/filename.rb.

```ruby
module Jekyll
  module Strapi
    class StrapiCollection
      def custom_path_params
        # ex. for multilanguage plugin you might want get request by page lang
        "&locale=#{@site.config["lang"]}"
      end
    end
  end
end
```
