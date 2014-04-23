#!/bin/sh

mkdir www
vagrant plugin install vagrant-gatling-rsync
vagrant up
open http://localhost:8080/phpmyadmin