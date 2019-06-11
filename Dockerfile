FROM 1000kit/base-jdk

MAINTAINER 1000kit <docker@1000kit.org>


LABEL org.1000kit.vendor="1000kit" \
      org.1000kit.license=GPLv3 \
      org.1000kit.version=1.0.0

# install User
USER root

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)

RUN groupadd -r jboss -g 1000 \
 && useradd -l -u 1000 -r -g jboss -m -d /home/jboss -s /sbin/nologin -c "jboss user" jboss \
 && chmod -R 755 /home/jboss \
 && mkdir /opt/jboss \
 && chown -R jboss:jboss /opt/jboss \
 && chmod 755 /opt/jboss \
 && echo 'jboss ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER jboss

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION=17.0.0.Final \
    WILDFLY_SHA1=50bf8c48d4faf27c530af6949a225b9f1428300e \
    JBOSS_HOME=/opt/jboss/wildfly


# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && echo "JAVA_OPTS=\"${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -Djava.net.preferIPv4Stack=true\"" >> ${JBOSS_HOME}/bin/standalone.conf \
    && rm wildfly-$WILDFLY_VERSION.tar.gz
    

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

# Expose the ports we're interested in
EXPOSE 8080 8787

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0" , "--debug"]

####END


