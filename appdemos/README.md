# App demo with hpa autoscaling 

appdemo will install the ruby hello world app with the correct route and with health checks 

hpa-appdemo will install with hpa on the frontend

ab-load-tester will install ab which can apply load on the frontend

## Set up

Add the templates, e.g. 

cat appdemo.template.yaml         | oc create -f -  -n openshift

cat hpa-appdemo.template.yaml     | oc create -f -  -n openshift

cat ab-load-tester.template.yaml  | oc create -f -  -n openshift

