FROM jetbrains/teamcity-agent:2024.03

WORKDIR /home/buildagent

# AWS CLI & CREDENTIALS
COPY secrets/.aws /home/buildagent/.aws
COPY secrets/.aws /root/.aws

RUN whoami # buildagent

USER root
RUN usermod --shell /bin/bash buildagent

RUN pwd
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip

USER root
RUN ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
RUN /usr/local/bin/aws --version

# SSH KEYS TO AUTH AS TEAMCITY AGENT
USER root
RUN mkdir /root/.ssh
COPY secrets/ssh_key/teamcity /root/.ssh/id_rsa
COPY secrets/ssh_key/teamcity.pub /root/.ssh/id_rsa.pub
RUN chown root:root /root/.ssh/id_rsa

USER root
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    && apt-get clean

# INSTALL ANSIBLE
ENV ANSIBLE_HOST_KEY_CHECKING False
USER root
RUN apt-get update && apt-get install ansible -y && apt-get clean

# UPGRADE NODEJS
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && apt-get clean

# INSTALL YARN
USER root
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y && apt-get clean
RUN yarn set version stable && yarn set version latest

# INSTALL FIREBASE CLI
RUN npm install -g firebase-tools

# INSTALL GCLOUD CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
RUN apt-get update -y && \
    apt-get install google-cloud-sdk -y

USER buildagent
WORKDIR /opt/buildagent
CMD /bin/bash
