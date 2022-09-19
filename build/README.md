
# Build

This directory is responsible for the building of docker images. There are a few steps.

# Strategy

As usual, the goal is to automate/script as much as possible. We'll use use the docker-library drupal and wordpress projects, but just building directly from those project's images isn't ideal.

Instead, we'll modify each project's Docker.template and use it's scriptability to generate our own modified, slight more opinionated Dockerfiles that still keep up with os/php variants.

The forked docker-library drupal and wordpress projects are included here as a submodules so we can pull in updates as necessary. 

Before you do any building, you may need to do this: apt-get install -y jq

# Maintenance

1. Update the forked drupal and wordpress projects to get the latest versions, etc.
  a. throw away all the file modifications that are generated with apply-template.sh (put them in a stash if you're weak!).
  b. merge in the remote upstream - i.e. the docker-library master branches - either via the command line, or in the github interface, followed by pulling in the updated branch here.
  c. run apply-template.sh

2. Check for new CMS versions, and variants. With Drupal, new patch versions should be handled automatically, but new major and minor versions require a new directory and sometimes updates to the build scripts when the underlying OS version changes, for example. With Wordpress, there's generally only one "latest" version, but it may incorporate breaking changes over time.

3. Run the build-drupal.sh to generate the new drupal images. Each variant will require two lines in that script, one for the 'base' image and one for the extended one that includes the drupal code.
4. Run the build-drupal-simuliidae.sh to generate the new simuliidae images, for as many different images that you want to support!
5. TODO: scripts to do the equivalent for wordpress.
