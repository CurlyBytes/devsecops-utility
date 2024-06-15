FROM ubuntu:20.04
 
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && useradd -m agentuser
 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    gcc \
    libffi-dev \
    musl-dev \
    openssl-dev \
    python3-dev \
    pipx \
    gnupg \
    make \
    bash \
    sudo \
    shadow \
    curl \
    py3-pip \
    graphviz \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl \
    libssl3 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    ca-certificates \
    azure-cli \
    git \
    iputils-ping \
    jq \
    lsb-release \
    wget \
    software-properties-common
 
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
 
# Install Terraform
ENV TF_VERSION=1.5.7
RUN wget -qO- https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip | zcat > /usr/local/bin/terraform && chmod +x /usr/local/bin/terraform


# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64
RUN mkdir terraform
RUN mkdir code
COPY . terraform

WORKDIR /azp
RUN chown -R agentuser:agentuser /azp
RUN chmod 755 /azp
 
COPY ./start.sh .
RUN chmod +x start.sh
# All subsequent commands run under this user
USER agentuser
 
ENTRYPOINT [ "./start.sh", "--once" ]