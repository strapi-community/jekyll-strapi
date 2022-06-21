---
layout: page
title: Docs
permalink: /docs/
---

# Quick Start

## Portfolio

In this example, we are creating a very simple Photography portfolio page, where users can upload a photo with a title and a simple description.

### Strapi Configuration

#### CMS Setup

Create new Strapi project:

```
npx create-strapi-app@latest my-project-photo --quickstart
```

And then to start project:

```
cd my-project-photo
npm run develop
```

Or if you are using yarn:
```
yarn create-strapi-app@latest my-project-photo --quickstart
cd my-project-photo
yarn run develop
```

Now you should have reachable Strapi instance here [http://localhost:1337/](http://localhost:1337/).


#### Collection setup

Go to Content-Type Build in your admin instance [http://localhost:1337/admin/plugins/content-type-builder/](http://localhost:1337/admin/plugins/content-type-builder/) and then create Collection as below:

![image](/assets/images/s-01.jpg)

To creat the fields choose:

**Text** field for the *Title*, type of **Short text**: 


![image](/assets/images/s-02.jpg)

**Media** field with a name *Image*, type **Single media**:

![image](/assets/images/s-03.jpg)

**Text** *Comment* field, we will use **Long text**:

![image](/assets/images/s-04.jpg)

Finally you should have something similar to:

![image](/assets/images/s-00.jpg)


Now go to **Content Manager** and add your first object to the database:

![image](/assets/images/s-07.jpg)

#### Auth token generation

Go to: [http://localhost:1337/admin/settings/api-tokens/create](http://localhost:1337/admin/settings/api-tokens/create) and *Create new token*:

![image](/assets/images/s-05.jpg)

After creation save token aside - you will need it later. Some [password manager](https://github.com/keepassxreboot/keepassxc/) is recommended.

### Plugin installation

Currently new version plugins is being develop only in this repo and it is not available through RubyGems, yet. You need to download it from GitHub:

```
MAIN_PATH=`pwd`
 git clone https://github.com/bluszcz/jekyll-strapi.git
 cd jekyll-strapi
 gem build
 cd $MAIN_PATH
 ```

This is will a plugin which you will install later 

### Jekyll configuration

Add `jekyll-strapi` to the plugins in `_config.yml`:

```
plugins:
  - jekyll-feed
  - jekyll-strapi
```

and following at the end of `_config.yml`:

```
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
            # Layout file for this collection
            layout: photo.html
            # Generate output files or not (default: false)
            output: true
```

We install the plugin:

```
gem install $MAIN_PATH/jekyll-strapi/jekyll-strapi-0.4.1.pre.dev.gem
rm Gemfile.lock
bundle install
```

Then in `_layouts` directory create two files, `home.html`:

```
---
layout: default
---
{% raw %}
<div class="home">
  <h1 class="page-heading">Photos</h1>
  {%- if strapi.collections.photos.size > 0 -%}
  <ul>
    {%- for photo in strapi.collections.photos -%}
    <li>
      <a href="{{ photo.url }}">Title {{ photo.attributes.TestDescription }}</a>
    </li>
    {%- endfor -%}
  </ul>
  {%- endif -%}
</div>
{% endraw %}
```

and `photo.html`:

```
---
layout: default
---
{% raw %}
<div class="home">
  <h1 class="page-heading">{{ page.strapi_attributes.TestDescription }}</h1>
  <h2>{{ page.document.strapi_attributes.Title }}</h2>
  <p>{{ page.document.strapi_attributes.Comment }}</p>
  <img src="{{ page.document.strapi_attributes.Image.data.attributes.formats.thumbnail| asset_url }}"/>
</div>
{% endraw %}

```

Now you must to set enviromental variable with auth token (you need to use previously saved token here):

```
export STRAPI_TOKEN=328438953489534...345423053895 
```

and now you can generate your page:

```
bundle exec jekyll build --trace
```

And after that you can check your website:

```
cd _site
python3 -m http.server
```

and opening [http://localhost:8000](http://localhost:8000) in your browser.

## Deployed example - demo

Here you can see page from previously example deployed to GitHub pages:

[https://jekyll-strapi-v4-example.bluszcz.net/](https://jekyll-strapi-v4-example.bluszcz.net/)

using following GitHub repository: [https://github.com/bluszcz/jekyll-strapi-v4-example.github.io/](https://github.com/bluszcz/jekyll-strapi-v4-example.github.io/)