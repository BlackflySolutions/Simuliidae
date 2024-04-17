# Compose

This directory is responsible for "composing" containers from the images built in the build directory into production.

# General Notes

This system relies on a now-deprecated way of combining fragments of docker-compose files, using the docker-compose program with "-f".

The newer better way is to include those fragments when running the site deploy script, i.e. on-the-fly, but I kind of like how this works better and I'm lazy, so I'm still using this.

I rewrote some of my scripts to support the new docker-compose to show myself it wasn't hard, but I'll probably keep using this system until it breaks.

My deployment process relies on per-project .env files that define, among other things, a docker-compose file. The docker-compose file naming convention matches the underlying cms project 
directory layout for the different supported "platforms", and includes a base, cms or crm fragment, and then as many 'add-ons' as desired, where add-ons are, for example, the .yml files in this directory.
