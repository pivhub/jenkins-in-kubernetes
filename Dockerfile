FROM jenkins/jenkins:lts

# Running as root to have an easy support for Docker
USER root

# A default admin user
ENV ADMIN_USER=admin \
    ADMIN_PASSWORD=Bekind

# Jenkins init scripts
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/

# Install plugins at Docker image build time
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt) && \
    mkdir -p /usr/share/jenkins/ref/ && \
    echo lts > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \
    echo lts > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

# Install Docker
RUN apt-get -qq update && \
    apt-get -qq -y install curl && \
    curl -sSL https://get.docker.com/ | sh

# Install Maven
RUN curl -LO https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz && \
    tar xzf apache-maven-3.6.0-bin.tar.gz && \
    mv ./apache-maven-3.6.0 /opt/apache-maven
ENV PATH=/opt/apache-maven/bin:$PATH
ENV _JAVA_OPTIONS=-Djdk.net.URLClassPath.disableClassPathURLCheck=true

# Install kubectl and helm
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash


#install jfrog cli
RUN curl -fL https://getcli.jfrog.io | sh && \
    chmod +x ./jfrog && \
    mv ./jfrog /usr/local/bin/jfrog

#install go cli
RUN curl -LO https://storage.googleapis.com/golang/go1.12.7.linux-amd64.tar.gz && \
    tar xzf go1.12.7.linux-amd64.tar.gz && \
    chmod +x go && \
    mv ./go /usr/local/bin/go

#install sonar-scaner cli
RUN curl -LO https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.0.0.1744-linux.zip && \
    unzip sonar-scanner-cli-4.0.0.1744-linux.zip && \
    mv ./sonar-scanner-4.0.0.1744-linux /opt/sonar-scanner && \
    echo "sonar.host.url=http://sonar.dev1.pcfgcp.pkhamdee.com" >> /opt/sonar-scanner/conf/sonar-scanner.properties
ENV PATH=/opt/sonar-scanner/bin:$PATH


