#!/usr/bin/env bash
apt-get --purge autoremove docker-ce -y && apt-get install docker-ce=18.06.1-ce -y
apt-mark hold docker-ce
