#!/bin/bash
bundle update twitter-bootstrap-rails
while [ $? -ne 0 ]; do
  bundle update twitter-bootstrap-rails
done
