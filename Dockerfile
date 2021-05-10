# Pull base image 
From tomcat:8-jre8 

# Maintainer 
MAINTAINER Farhaan Shamsee
COPY ./webapp.war /usr/local/tomcat/webapps

