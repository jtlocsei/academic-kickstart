---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Deploy Clojure to Netlify"
subtitle: "Netlify > Github"
summary: ""
authors: [tobias]
tags: [clojure]
categories: []
date: 2020-04-08T21:55:03+08:00
lastmod: 2020-04-08T21:55:03+08:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---


Fittingly, my first post on this blog is about how I deployed this blog :-)

[Cryogen](https://cryogenweb.org/) is a static site generator written in Clojure while [Netlify](https://www.netlify.com/) is a slick and powerful platform for deploying static websites. Can they play well together? Yes!

The Cryogen website describes [how to deploy to Github Pages](https://cryogenweb.org/docs/deploying-to-github-pages.html), which works fine, but personally I found it easier to deploy my site to Netlify. In terms of price, they're both free. [Netlify has a free tier](https://www.netlify.com/pricing/) which is more than sufficient for hobby or personal projects.

So, if you'd like to have a go deploying your Cryogen blog to Netlify, here's how. 


## Step 1: Build your website locally



1. Edit config.edn in your Cryogen project and set `:blog-prefix` to `""`. This prefix will be prepended to all URIs. We want it blank because otherwise it will confuse Netlify.
2. Build your site with `lein run`.


## Step 2: Deploy using the Netlify Web Interface

We'll do our first deploy with the web interface because it's so quick and easy. 



1. Create a free account at [https://netlify.com](https://netlify.com) 
2. Drag the whole `public` folder of your site into the area in Netlify labelled "Want to deploy a new site without connecting to Git? Drag and drop your site folder here". 
3. That's it. Seriously.
4. When you want to update your site, navigate the to site's project in Netlify, go to the "deploys" tab, and drag the new version of your site onto the region that says "Need to update your site? Drag and drop your site folder here". 

While you're on the Netlify website you might want to change the domain settings for your site. By default you get a random name, so go ahead and change it to something that's meaningful to you. 

The Netlify web interface is all well and good, but it would be quicker to do subsequent deployments from the command line, so let's set that up.


## Step 3: Deploy using the Netlify CLI

This section assumes that you've already done your first deploy with the web interface. 



1. Follow these [instructions to install netlify CLI](https://docs.netlify.com/cli/get-started/) on your local machine. Essentially, you just run two commands:
    1. `npm install netlify-cli -g`
    2. `netlify login`
2. Run `netlify deploy --dir=public`
3. Select "link this directory to an existing site", since you've already created your site with the web interface.
4. Select "Choose from a list of your recently updated sites"
5. Select the site from the list
6. You'll be given a live draft url. Open the url and check that your site looks correct. 
7. If it looks good and you want to deploy to production, then run `netlify deploy --dir=public --prod`. This is also the command you can use for all subsequent deploys. 
8. If you mess up, e.g. by accidentally linking your project to the wrong Netlify site, then just run `netlify unlink`, and then next time you run `netlify deploy` you'll have the option to set things up from the start again.

If you're on a Mac, you can streamline things even more by creating a file called deploy.command in your project's directory with the following contents


```
#!/bin/bash

# Change to the directory from which the script is being run
cd "$(dirname "$BASH_SOURCE")" || {
    echo "Error getting script directory" >&2
    exit 1
}

lein do clean, run &&\
netlify deploy --dir=public --prod
```


Once you've made the file run `chmod +x deploy.command`. Now you can build and deploy your site just by double-clicking on the deploy.command file in Finder.