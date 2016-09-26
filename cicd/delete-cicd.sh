#!/bin/bash 

# sync this folder to the VM first
# rsync -r -v cicd vagrant@10.1.2.2:

oc delete project cicd dev stage

