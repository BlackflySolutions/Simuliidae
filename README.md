# Simuliidae
An open source Drupal CiviCRM Container Stack.

## Goals
The purpose of the project is to provide a platform on which to build automated tooling for Drupal/CiviCRM websites. Examples include:
1. A simple way for evaluators to launch their own local Drupal/CiviCRM installation.
2. A standard for generating testing and development copies of production sites.
3. A basis for an automated Drupal/CiviCRM demonstration site generator.
4. A basis for a multi-site host.

## Structure
The structure of the project mirrors that of the official Drupal docker project. Specifically, it follows that project's top level directory structure for Drupal versioning with subdirectories for image variants. Currently, the 7/apache and 8/apache have working implementations.

## Status
This is a work-in-progress.

## What It Is, What It Includes
This project includes instructions, docker compose files, files for building Docker images, and some bash scripts.

The Mariadb database image definition that is used is here: https://github.com/BlackflySolutions/mariadb

## Evaluator Quick Start
Instructions for this function are in progress here: [Evaluator Quick Start wiki page](https://github.com/BlackflySolutions/Simuliidae/wiki/Evaluator-Quick-Start).

<!---
## Quick Start On Your Own System
1. Install docker on your system.
2. Either install docker-compose or configure your docker node as a (usually stand-alone) swarm.
3. Use `compose.sh test_evaluator up -d` or `stack.sh test_evaluator deploy`
4. Access the site via your browser at the corresponding url (for compose, it'll be an non-routable ip that you can find using docker inspect, for swarm it'll be a port that was auto-assigned when the stack was created).

## Quick Start on Blackfly's Test System
1. Visit https://discover.civicrm.ca/ and follow the instructions. It uses this project with some additional automation.
--->
