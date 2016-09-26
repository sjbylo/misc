#!/bin/bash 

# sync this folder to the VM first
# rsync -r -v cicd vagrant@10.1.2.2:

if [ ! -d "openshift-cd-demo" ] 
then
	git clone https://github.com/OpenShiftDemos/openshift-cd-demo.git
else
	cd openshift-cd-demo && git pull origin master && cd ..
fi

oc new-project cicd --display-name="CI/CD"
oc process -f openshift-cd-demo/cicd-github-template.yaml | oc create -f -
oc new-project dev --display-name="Tasks - Dev"
oc new-project stage --display-name="Tasks - Stage"
oc policy add-role-to-user edit system:serviceaccount:cicd:default -n cicd
oc policy add-role-to-user edit system:serviceaccount:cicd:default -n dev
oc policy add-role-to-user edit system:serviceaccount:cicd:default -n stage

oc project cicd
oc status


