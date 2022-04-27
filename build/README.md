
# Build

This directory is responsible for the building of docker images. There are a few steps.

# Strategy

As usual, the goal is to automate/script as much as possible. We'll use use the docker-library/drupal project, but just building directly from that project's images isn't ideal.

Instead, we'll modify that project's Docker.template and use it's scriptability to generate our own modified, slight more opinionated Dockerfiles that still keep up with os/drupal/php variants.

The docker-library/drupal project is included here as a submodule so we can pull in updates as necessary. That project does not include any tags or branches, but we still want to know which iteration of that project we're working with.

# Maintenance

1. Update the docker-library/drupal project to get the latest versions, etc.
  a. merge in the remote upstream 
  b. run apply-template.sh
2. Check for new variants. New minor versions are handled automatically, but new major versions require a new directory and updates to the build scripts.
3. Run the build.sh and other scripts to generate the simuliidae images.
