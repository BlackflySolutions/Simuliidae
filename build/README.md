
# Build

This directory is responsible for the building of docker images. There are a few steps.

This directory now includes building of CiviCRM docker images for Drupal, Wordpress and Standalone. Much of the design is Drupal-centric since that's what I did first, but I'm trying to be more structured and cms-agnostic by having a single structure that works for all of them.

# General Notes

As usual, the goal is to automate/script as much as possible. We'll use use the docker-library drupal and wordpress projects, but just building directly from those project's images isn't ideal.

Instead, we'll modify each project's Docker.template and use it's scriptability to generate our own modified, slight more opinionated Dockerfiles that still keep up with os/php variants.

The forked docker-library drupal and wordpress projects are included here as a submodules so we can pull in updates as necessary. 

Before you do any building, you may need to do this: apt-get install -y jq

# Steps

## Build a Modified CMS Image - without the CMS code.

This CiviCRM enabled, production CMS image is different from the canonical docker image in two distinct ways:
1. I've added some additional OS packages. You can see those here: 
https://github.com/BlackflySolutions/drupal/commit/88f6c060127e5267e5c18aac285daac0bc928e12
2. From Drupal 8 onwards, I've chosen to use composer in a different way than the canonical docker image, so I've added a build tag so I can stop before the CMS code gets added. That way, I can build images that don't have the cms code, which is a good idea for production sites that want to manage their own CMS/CRM code, and then add in the cms code as appropriate.

This step gets done with a forked version of the official docker project (for each CMS).

## Add More Stuff

The More Stuff step is done with a separate Docker file named 'Simuliidae', which does quite a few things using the multi-step build feature of Docker files. The goal is to end up with 6 different images. Or better described - 3 pairs of images. Each pair is a 'vhttp' webserver and a 'admin' helper container only running sshd.

1. vhttp-base, admin-base - a minimal image with no cms/crm code.
2. vhttp-cms, admin-cms - with the cms code added.
3. vhttp-cms-crm, admin-cms-crm - with the crm code added also.

Along the way, there are also the two admin-builder-cms and admin-builder-cms-crm steps.

Below are the different steps within this Docker file.

1. <pre>FROM ${REPOSITORY_FROM}{CMS_NAME}:base-${VARIANT_TAG} as vhttp-base</pre>
<pre>Use the modified CMS "base" image to build a minimal 'base' webserver image.
For drupal, I modify the document root.
I add a few standard performance bits, like redis, apcu, and imagick, as well as an msmtp setup to do mail. 
And an apache config file and a php config file.
And a custom entrypoint.sh file that looks up an ip to communicate with the container host.</pre>

2. <pre>FROM vhttp-base as admin-base</pre>
<pre>Add some additional admin-only OS packages. 
Add drush and cv.
Setup a "drupal" (1978) uid to own the code.
Add a bunch of convenience scripts.
Add a modified apache config.</pre>

3. <pre>FROM admin-base as admin-cms-builder</pre>
<pre>Here's where we add the CMS code to the container. It's only for the (4) non-base images.
The idea is to add a bunch of builder tools to the image (like composer, but also some other stuff that CiviCRM especially needs), and then build interim images from which we copy code. Yes, the 'builder pattern'.</pre>

4. <pre>FROM vhttp-base as vhttp-cms</pre>
5. <pre>FROM admin-base as admin-cms</pre>
<pre>Just copy code from admin-cms-builder.</pre>

6. <pre>FROM admin-cms-builder as admin-cms-crm-builder</pre>
<pre>Do more more building to add in CiviCRM.</pre>

7. <pre>FROM vhttp-base as vhttp-cms-crm</pre>
8. <pre>FROM admin-base as admin-cms-crm</pre>
Copy code form admin-cms-crm-builder</pre>

# Maintenance

1. Merge/update the forked drupal and wordpress projects and run apply-template.sh to get the latest versions 
  a. throw away any the file modifications that are/have been generated with apply-template.sh (put them in a stash if you're weak!).
  b. merge in the remote upstream - i.e. the docker-library master branches - either via the command line, or in the github interface, followed by pulling in the updated branch here.
  c. run apply-template.sh

2. Check for new CMS versions, and variants. With Drupal, new patch versions should be handled automatically, but new major and minor versions require a new directory and sometimes updates to the build scripts when the underlying OS version changes, for example. With Wordpress, there's generally only one "latest" version, but it may incorporate breaking changes over time.
  a. Any new 'variants' will need their own directory and to be entered in the variants.txt file.

3. Run the build-drupal.sh to generate the new drupal images. There will be 2 images for each variant: base (no drupal code) vs drupal (with drupal code).
4. Run the build-simuliidae.sh to generate the new simuliidae images, 3 images for each variant: base (no code) vs drupal (with drupal code only) vs. drupal-civicrm (with both).
5. TODO: scripts to do the equivalent for wordpress.
