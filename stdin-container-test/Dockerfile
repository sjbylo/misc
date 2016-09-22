FROM centos:7

MAINTAINER sbylo@redhat.com

EXPOSE 8080

USER 1001

CMD i=0; while [ $i -lt 20 ]; do read -t 60 line; echo -n $i; let i=$i+1; done
