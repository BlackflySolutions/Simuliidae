
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

2. Check for new variants. New minor versions are handled automatically, but new major versions require a new directory and updates to the build scripts.

3. Run the build.sh and other scripts to generate the simuliidae images.
