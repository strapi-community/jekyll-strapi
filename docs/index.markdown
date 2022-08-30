---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

jekyll-strapi    is a Jekyll plugin to generate static sites using Strapi 4 headless cms. 

# Features
* Compatibility with Strapi 4
    * Scallable iterative model of fetching data using populate=*
* Authentication using Personal and Content API tokens
* Filter to fetch media files to avoid linking with original Strapi instance
* Basic support for permalinks


# Roadmap

* Support for SingleType (2022-Q3)
* Pagination (2022-Q3)
* Configuration of necessary fields instead of using populate=* for all the results

# Use case scenarios

## Family/friends blog with recipes

A group of friends or family members would like to set up a blog with recipes. They can deploy one instance ([Strapi recommends some hosting](https://docs.strapi.io/developer-docs/latest/setup-deployment-guides/deployment.html)), create a few collections, and start work together. They can store files in Git repository and With the help of CI/CD - deploy when the new entries appear.


## Personal blog/portfolio

This setup assumes Strapi running locally on your laptop, where you create the content of your personal blog and portfolio. You run Jekyll to render the pages and deploy them to Heroku, Gitlab/Github pages, or similar services.

## Multinational company

![image](/assets/images/jekyll-strapi-ng.drawio.png)

Let’s imagine a company with an online presence in several countries. There would be one Strapi4 instance (which can be hosted in a private cloud) with several users “editors” from various countries. Each of them would have access to the only set of Collections where they would maintain all the data. Then, each country runs its version jekyll-strapi-ng and generates necessary static pages which can be easily deployed. Thanks to the scalable design of jekyll-strapi-ng you can generate pages from Collections containing a LOT of data. 



