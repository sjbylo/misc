# CodeReady Workspaces (CRW) Demo using the Vote demo app

This demo is a quick way to show off Eclipse Che or CRW on OpenShift. 

The first part shows a demo with a Quarkus app and the second part shows how to use a factory url to open a workspace with one click.

Before you demo CRW, look through this video and note the required messaging for the customer! 

* [Video preso](https://my.allego.com/play.do?contentId=659233&sch=20921) - for CRW messaging

If you are in a hurry, you can demo without having to install CRW at all.   Go here: [https://che.openshift.io/dashboard/#/](https://che.openshift.io/dashboard/#/) - log in with your RH access login (or RH developer login).

You will see your Workspaces, if any:

![d587de200a110a79b11406ed58784e03.png](image/d587de200a110a79b11406ed58784e03.png)

Click on "Get Started".   You will see some example workspaces. 

![3be3c28def6da9864b27c4ddc1a165a8.png](image/3be3c28def6da9864b27c4ddc1a165a8.png)

Filter by "Quarkus" and choose the "Quarkus Tools"sample  to create a workspace.  

* It's a good idea to do this in advance of the demo because it can take about 2-3 mins to come up properly.  If there are any problems opening this workspace, I suggest opening it in advance on a separate tab as a backup!

![7d8d65592148d8177194a065ac4a9860.png](image/7d8d65592148d8177194a065ac4a9860.png)

You will see the new workspace: 

![bb5c03864eaa83e0eb6d850f8f7af332.png](image/bb5c03864eaa83e0eb6d850f8f7af332.png)

Open up some code to show:

![5089840d75c67cef254f8f3444e97f68.png](image/5089840d75c67cef254f8f3444e97f68.png)

On the right hand side, open up the menu and select "New Terminal" under centos-quarkus-maven.  A terminal window will open up at the bottom.  

![86edfd8a7a0977efa693db380d88d3e4.png](image/86edfd8a7a0977efa693db380d88d3e4.png)

Show that the terminal can be used to explore the source code:

![f99886725e35e57e0b4b05644a983652.png](image/f99886725e35e57e0b4b05644a983652.png)

Click on "Start Development Mode" to start the app for testing:

![d04b50ba69c3a8433b0b54dedaed966b.png](image/d04b50ba69c3a8433b0b54dedaed966b.png)

The app will launch in dev mode:

![146345aa57347cd4237592079942d73a.png](image/146345aa57347cd4237592079942d73a.png)

Click on "Open Link" to view the app:

![7eacbcba605218d875e96f40c9bd3461.png](image/7eacbcba605218d875e96f40c9bd3461.png)

The app is running.   The path /hello/greeting/che-user  displays a simple greeting: 

![1cd962c70923a9c7d8406330d4aec1eb.png](image/1cd962c70923a9c7d8406330d4aec1eb.png)

Change the path to change the greeting response:

![542cfb03e9345021d4cb024c8c2bbb97.png](image/542cfb03e9345021d4cb024c8c2bbb97.png)

Go to the GreetingResource.java file and update the code.  Note, there is no need to save the files, all changes are saved automatically: 

![8a7d52a9008f75d56f647ec24a03eb3d.png](image/8a7d52a9008f75d56f647ec24a03eb3d.png)

Refresh the browser showing the running app to see the change instantly (no need to re-comopile the quarkus app): 

![c8242c81c9e7a732818a1b353637e9c5.png](image/c8242c81c9e7a732818a1b353637e9c5.png)

**Other example demo using a Vote App "factory URL"  **

Open the URL [https://che.openshift.io/f?url=https://github.com/sjbylo/flask-vote-app](https://che.openshift.io/f?url=https://github.com/sjbylo/flask-vote-app) to open the workspace with just one click! 

This is really useful to quickly show an application to another team member, e.g. from a developer to a tester.  

The application workspace will be created and the app can be executed in a similar way to the above Quarkus app: 

**

![210a6f5dd41d7357cfca2edf8e66a08c.png](image/210a6f5dd41d7357cfca2edf8e66a08c.png)

**

---

**Miscellaneous **

If you want to demo CRW on your own OpenShift cluster or on an RHPDS cluster

Quick start:

1. Install the operator into a demo project - the Operator installs much like any other - Install works into any project, e.g. "workspaces".

2. Create a new project, e.g. "demo" and Install the "Che cluster" into the project.

3. On the OCP "CodeReady Workspaces Cluster Overview" page click on the route - wait for Status: available

---

**Other useful content:**

1. [https://github.com/sjbylo/flask-vote-app](https://github.com/sjbylo/flask-vote-app) - the demo app

2. [RBAC](https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/1.2/html-single/administration_guide/index#permissions) - establish a security model - allow certain actions by assigning permissions to users.

3. CRW Arch. [slide](https://docs.google.com/presentation/d/1WFRi9MZD3qksnEuAvgZpNrCjEf1PFLDMyxr-L2xThQA/edit#slide=id.g64798e8100_1_452)

4. CRW all in [One slide](https://docs.google.com/presentation/d/1Zklf--RjGchYD6qJDcVR7BT_s-mGTaRTsxBJvVTuYEM/edit#slide=id.g6beb2c4044_0_235) - CRW [OneStop](https://redhat.highspot.com/items/5c7fd4a981171734ea321621#1)

5. CRW [FAQ](https://docs.google.com/document/d/174USXEPCzTxz-piEk0CaOMzr2R1KhU7-1P7TEG0bBMc/edit#)

6. [videos](https://www.youtube.com/playlist?list=PLf3vm0UK6HKpBA8nWWO--6HtzKm6trH7-) (Veer M)

7. [end-user doc](https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/2.0/html-single/end-user_guide/index)[doc2.1](https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/2.1/html/installation_guide/index) (May 2020)

8. Main "Red Hat CodeReady Workspaces" [deck](https://docs.google.com/presentation/d/17EYvjLTE45B-nN__diBxnZCkKAMCKiaLWz6O5BO7vbw/edit#slide=id.g64798e8100_1_0)

9. It's not always easy to find up-to-date documentation on Eclipse Che.  This is one good source for the latest features:

1. [https://www.eclipse.org/che/docs/che-7/introduction-to-eclipse-che/](https://www.eclipse.org/che/docs/che-7/introduction-to-eclipse-che/)
