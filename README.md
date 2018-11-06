# Simuliidae
An open source opinionated Drupal CiviCRM Container Stack

## Quick Start On Your Own System
1. Install docker on your system.
2. Either install docker-compose or configure your docker node as a (usually stand-alone) swarm.
3. Use `compose.sh test_evaluator up -d` or `stack.sh test_evaluator deploy`
4. Access the site via your browser at the corresponding url (for compose, it'll be an non-routable ip that you can find using docker inspect, for swarm it'll be a port that was auto-assigned when the stack was created).

## Quick Start on Blackfly's Test System
1. Visit https://discover.civicrm.ca/ and follow the instructions. It uses this project with some additional automation.
