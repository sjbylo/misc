FROM centos:7

MAINTAINER sbylo@redhat.com

EXPOSE 8080

USER 1001

CMD echo Test container running ...; i=0; while [ $i -lt 6 ]; do read -t 30 line; echo -n $i; let i=$i+1; done
