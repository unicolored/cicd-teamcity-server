FROM jetbrains/teamcity-agent:2023.11.3

WORKDIR /home/buildagent

# SETUP AWS CLI
COPY secrets/.aws /home/buildagent/.aws
COPY secrets/.aws /root/.aws

COPY buildAgent.properties /data/teamcity_agent/conf/buildAgent.properties

RUN whoami
RUN pwd
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip

USER root
RUN ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
RUN /usr/local/bin/aws --version

# SETUP DOCKER-MACHINE
#RUN base=https://github.com/docker/machine/releases/download/v0.16.0 \
#    && curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine \
#    && mv /tmp/docker-machine /usr/local/bin/docker-machine \
#    && chmod +x /usr/local/bin/docker-machine
#RUN docker-machine

# ADD SSH KEYS
USER root
RUN mkdir /root/.ssh
COPY ssh_key/teamcity /root/.ssh/id_rsa
COPY ssh_key/teamcity.pub /root/.ssh/id_rsa.pub
RUN chown root:root /root/.ssh/id_rsa

# INSTALL ANSIBLE
ENV ANSIBLE_HOST_KEY_CHECKING False
USER root
RUN apt-get update && apt-get install ansible -y

# UPGRADE NODEJS
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# INSTALL YARN
USER root
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y
RUN yarn set version stable && yarn set version latest

USER buildagent
