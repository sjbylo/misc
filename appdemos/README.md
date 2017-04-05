# App demo with hpa autoscaling 

Add the templates, e.g. 

cat appdemo.template.yaml         | oc create -f -  -n openshift
cat hpa-appdemo.template.yaml     | oc create -f -  -n openshift
cat ab-load-tester.template.yaml  | oc create -f -  -n openshift

