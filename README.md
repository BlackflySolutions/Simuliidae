# Simuliidae
An open source CiviCRM Container Stack, for Drupal and Wordpress.

## Goals
The purpose of the project is to provide a platform on which to build automated tooling for CiviCRM websites. Examples include:
1. A simple way for evaluators to launch their own local CiviCRM installation.
2. A standard for generating testing and development copies of production sites.
3. A basis for an automated CiviCRM demonstration site generator.
4. A basis for a multi-site host.

## Structure
The structure of the project mirrors that of the official Drupal and Wordpress docker projects. Specifically, it follows those projects' top level directory structure for versioning with subdirectories for image variants.

## Status
This is a work-in-progress. Only the current Drupal versions are in use, any other versions should be considered experimental and/or not production ready.

Current Drupal versions have been in use on production sites [since Oct 2022](http://homeofficekernel.blogspot.com/2022/10/welcome-to-simuliidae-v2.html).

Here are some longer versions of the story:

[My Journey Into Containers](http://homeofficekernel.blogspot.com/2018/10/my-journey-into-containers.html)
[Docker: putting things together and pulling them apart](http://homeofficekernel.blogspot.com/2018/10/docker-putting-things-together-and.html)
[Building and maintaining Drupal + CiviCRM application containers](http://homeofficekernel.blogspot.com/2019/03/building-and-maintaining-drupal-civicrm.html)
[Orchestrating Drupal + CiviCRM containers into a working site: describing the challenge](http://homeofficekernel.blogspot.com/2019/04/orchestrating-drupal-civicrm-containers.html)
[Welcome to Simuliidae, v2](http://homeofficekernel.blogspot.com/2022/10/welcome-to-simuliidae-v2.html)

## What It Is, What It Includes
This project includes instructions, docker compose files, files for building Docker images, and some bash scripts.

The Mariadb database image definition that is used is here: https://github.com/BlackflySolutions/mariadb

## Evaluator Quick Start

Instructions for this function are in progress here: [Evaluator Quick Start wiki page](https://github.com/BlackflySolutions/Simuliidae/wiki/Evaluator-Quick-Start).

As of Jan 2024, they are very out of date!

<!---
## Quick Start On Your Own System
1. Install docker on your system.
2. Either install docker-compose or configure your docker node as a (usually stand-alone) swarm.
3. Use `compose.sh test_evaluator up -d` or `stack.sh test_evaluator deploy`
4. Access the site via your browser at the corresponding url (for compose, it'll be an non-routable ip that you can find using docker inspect, for swarm it'll be a port that was auto-assigned when the stack was created).
--->
