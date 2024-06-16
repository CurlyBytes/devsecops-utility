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
    iputils-ping \
    libcurl4 \
    libicu60 \
    libunwind8 \
    netcat \
    libssl1.0 \
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

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash \
&& apt-get install -y nodejs
RUN npm install concurrently
RUN wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.2.6/powershell-lts_7.2.6-1.deb_amd64.deb \
            && dpkg -i powershell-lts_7.2.6-1.deb_amd64.deb

RUN pwsh -Command Install-Module -Name Az -AllowClobber -Repository PSGallery -Force

RUN pwsh -Command Install-Module -Name AzTable -AllowClobber -Force

RUN pwsh -Command Install-Module -Name SqlServer -AllowClobber -Force
RUN wget -q https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_20.10.18~3-0~ubuntu-bionic_amd64.deb \
            && dpkg -i docker-ce-cli_20.10.18~3-0~ubuntu-bionic_amd64.deb
RUN docker buildx install
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
            && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
            && apt-get update && apt-get install -y --no-install-recommends \
            kubectl

# Install Terraform
ENV TF_VERSION=1.5.7
RUN wget -qO- https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip | zcat > /usr/local/bin/terraform && chmod +x /usr/local/bin/terraform


# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64
ENV AGENT_VERSION=2.209.0

RUN if [ "$TARGETARCH" = "amd64" ]; then \
    AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
else \
    AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
fi; \
curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz


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