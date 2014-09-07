#!/bin/bash

vagrant ssh-config >> ~/.ssh/config
scp nginx/nginx.service core-1:
ssh core-1 'fleetctl start nginx.service'
scp sinatra/sinatra.service core-1:
ssh core-1 'ln -s sinatra.service sinatra@5000.service'
ssh core-1 'ln -s sinatra.service sinatra@5001.service'
ssh core-1 'fleetctl submit sinatra@5000.service'
ssh core-1 'fleetctl submit sinatra@5001.service'
ssh core-1 'fleetctl start sinatra@5000.service'
ssh core-1 'fleetctl start sinatra@5001.service'
