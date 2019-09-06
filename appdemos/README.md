# App demo with hpa autoscaling 

The appdemo template will install the ruby hello world app with the correct route and with health checks. 

hpa-appdemo will install appdemo but with hpa on the frontend.

ab-load-tester will install ab which can apply load on the frontend.

## Source code

https://github.com/sjbylo/ruby-hello-world.git 

## Adding the templates to OpenShift 

Add the templates as system:admin or as cluster-admin, e.g. 

```
cat appdemo.template.yaml         | oc create -f - -n openshift --as system:admin 
cat hpa-appdemo.template.yaml     | oc create -f - -n openshift --as system:admin 
cat ab-load-tester.template.yaml  | oc create -f - -n openshift --as system:admin 
```

or

```
curl -s https://raw.githubusercontent.com/sjbylo/misc/master/appdemos/appdemo.template.yaml        | oc create -f - -n openshift --as system:admin
curl -s https://raw.githubusercontent.com/sjbylo/misc/master/appdemos/hpa-appdemo.template.yaml    | oc create -f - -n openshift --as system:admin
curl -s https://raw.githubusercontent.com/sjbylo/misc/master/appdemos/ab-load-tester.template.yaml | oc create -f - -n openshift --as system:admin 

```

## Ensure the templates are visible in the catalog on 3.7 and above

```
oc annotate template appdemo        tags=quickstart,ruby --overwrite -n openshift
oc annotate template hpa-appdemo    tags=quickstart,ruby --overwrite -n openshift
oc annotate template ab-load-tester tags=quickstart      --overwrite -n openshift

# On the master(s)
sudo systemctl restart atomic-openshift-master-api.service
sudo systemctl restart atomic-openshift-master-controllers.service

or

ansible masters -m shell -a "systemctl restart atomic-openshift-master-api atomic-openshift-master-controllers"
```

## Start the demo

Either start the demo from the console by instantiating the appdemo template or run the following:

```
oc login -u <normal-user>
oc new-project demo
oc new-app appdemo
```

## HPA demo

You need an OpenShift cluster with metrics installed. 

Launch the hpa app demo template then launch the ab-load-tester template.  Ensure the "ab" args are something like:

e.g. -n 10000000 -c 20 http://frontend:8080/

## Demo with resource quota set 

Use the quota definition to set the project quota.

```
oc create -f project-quota.yaml
```

## Troubleshooting

Note, it may take a while to pull the images on first run

Ensure that metrics are configured and working 

