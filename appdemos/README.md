# App demo with hpa autoscaling 

appdemo will install the ruby hello world app with the correct route and with health checks 

hpa-appdemo will install appdemo but with hpa on the frontend

ab-load-tester will install ab which can apply load on the frontend

## Set up

Add the templates, e.g. 

```
cat appdemo.template.yaml         | oc create -f - --as system:admin -n openshift
cat hpa-appdemo.template.yaml     | oc create -f - --as system:admin -n openshift
cat ab-load-tester.template.yaml  | oc create -f - --as system:admin -n openshift
```

or

```
curl -s https://raw.githubusercontent.com/sjbylo/misc/master/appdemos/appdemo.template.yaml        | oc create -f - --as system:admin -n openshift
curl -s https://raw.githubusercontent.com/sjbylo/misc/master/appdemos/hpa-appdemo.template.yaml    | oc create -f - --as system:admin -n openshift
curl -s https://raw.githubusercontent.com/sjbylo/misc/master/appdemos/ab-load-tester.template.yaml | oc create -f - --as system:admin -n openshift

```

## HPA demo

Launch the hpa app demo template then then launch the ab-load-tester template.  Ensure the "ab" args are something like:

e.g. -n 10000000 -c 20 http://frontend:8080/


## Troubleshooting

Note, it may take a while to pull the images on first run

Ensure that metrics are configured and working 
