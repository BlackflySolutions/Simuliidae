
# Build

This directory is responsible for the building of docker images. There are a few steps.

# Strategy

As usual, the goal is to automate/script as much as possible. We'll use use the docker-library drupal and wordpress projects, but just building directly from those project's images isn't ideal.

Instead, we'll modify each project's Docker.template and use it's scriptability to generate our own modified, slight more opinionated Dockerfiles that still keep up with os/php variants.

The forked docker-library drupal and wordpress projects are included here as a submodules so we can pull in updates as necessary. 

Before you do any building, you may need to do this: apt-get install -y jq

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
