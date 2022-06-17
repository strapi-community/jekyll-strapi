---
layout: page
title: Development
permalink: /dev/
---

# Development Docs

## Authentication

For the authentication we are using enviromental variable `STRAPI_TOKEN` which can be one of  Content API or Personal tokens.

## Fetching data

This plugin works in following way - first it gets genral information about collection, and then interates over all elements using extra *populate* parameter which allows access to media files. Pseudo code:

```
collection = strapi_request() # HTTP request
for elem in collection
    data = elem.get_data() # # HTTP request
```
## Filters

### Copying media from Strapi

In Strapi you can create Media type of field, which can contain Image, for instance. To avoid linking to Strapi instance - this plugin introduces new filter `asset_url` which fetches media file to the temporary location, and then using Jekyll internals `Jekyl::StaticFile` copies it to the output site, plus generates url link as output.