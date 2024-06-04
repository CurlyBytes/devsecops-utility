ARG IMAGE_REPO=alpine
ARG IMAGE_VERSION=3
ARG TERRAFORM_VERSION=1.5.5
ARG POWERSHELL_VERSION=7.1.6
ARG NODE_VERSION=lts-alpine3.14

#Utiltities
ARG CONTAINER_NAME="itu-innersource/template-iac-terraform"
ARG SEMANTIC_VERSION="0.1.0"
ARG BUILD_AUTHOR="RAFI MFI DevOps"
ARG COMMIT_HASH="xxxxxxxx"
ARG ReleaseDate=alpine
ARG WIKI_URL="https://dev.azure.com/rafi-secdevops/itu-innersource/_wiki/wikis/itu-innersource.wiki?wikiVersion=GBwikiMaster"
ARG ORGANIZATION_NAME="RAFI MFI"
ARG ORGANIZATION_URL="http://rafimfi.org.ph/"
ARG REPOSITORY_URL="https://rafi-secdevops@dev.azure.com/rafi-secdevops/itu-innersource/_git/template-iac-terraform"
ARG LTS_VERSION="1.0"

#origina source docker file https://codingwithtaz.blog/2021/11/10/using-containers-to-share-terraform-modules-and-deploy-with-azure-pipelines/
FROM node:${NODE_VERSION} AS node_base
RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version
 
FROM ${IMAGE_REPO}:${IMAGE_VERSION} AS installer-env
ARG TERRAFORM_VERSION
ARG POWERSHELL_VERSION
ARG POWERSHELL_PACKAGE=powershell-${POWERSHELL_VERSION}-linux-alpine-x64.tar.gz
ARG POWERSHELL_DOWNLOAD_PACKAGE=powershell.tar.gz
ARG POWERSHELL_URL=https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/${POWERSHELL_PACKAGE}
RUN apk upgrade --update && \
    apk add --no-cache bash wget curl
 

# Terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/bin
     
# PowerShell Core
RUN curl -s -L ${POWERSHELL_URL} -o /tmp/${POWERSHELL_DOWNLOAD_PACKAGE}&& \
    mkdir -p /opt/microsoft/powershell/7 && \
    tar zxf /tmp/${POWERSHELL_DOWNLOAD_PACKAGE} -C /opt/microsoft/powershell/7 && \
    chmod +x /opt/microsoft/powershell/7/pwsh
 
FROM ${IMAGE_REPO}:${IMAGE_VERSION} 

ENV NODE_HOME /usr/local/bin/node
#Implement Label Standard https://medium.com/@chamilad/lets-make-your-docker-image-better-than-90-of-existing-ones-8b1e5de950d
#http://label-schema.org/rc1/
LABEL com.rafimfi.build-date="${ReleaseDate}" \
      com.rafimfi.name="${CONTAINER_NAME}" \ 
      com.rafimfi.maintainer="${CONTAINER_NAME}" \
      com.rafimfi.description="The Container for Everything as Code"  \
      com.rafimfi.usage="${WIKI_URL}" \
      com.rafimfi.url="${ORGANIZATION_URL}" \
      com.rafimfi.vcs-url="${REPOSITORY_URL}" \
      com.rafimfi.vcs-ref="${COMMIT_HASH}" \
      com.rafimfi.vendor="${ORGANIZATION_NAME}" \
      com.rafimfi.version="${SEMANTIC_VERSION}" \
      com.rafimfi.schema-version="${LTS_VERSION}" \
      com.rafimfi.docker.cmd="docker run --rm -v .:/terraform terraform-docker init" \
      com.rafimfi.docker.params="${SEMANTIC_VERSION}" \
      com.azure.dev.pipelines.agent.handler.node.path="${NODE_HOME}" \
      com.rafimfi.terraform-version="${TERRAFORM_VERSION}" \
      com.rafimfi.powershellcore-version="${POWERSHELL_VERSION}" \
      com.rafimfi.image="${IMAGE_REPO}-${IMAGE_VERSION}" 

# Copy only the files we need from the previous stages
COPY --from=installer-env ["/usr/bin/terraform", "/usr/bin/terraform"]
COPY --from=installer-env ["/opt/microsoft/powershell/7", "/opt/microsoft/powershell/7"]
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
COPY --from=node_base ["${NODE_HOME}", "${NODE_HOME}"]
 
# Copy over src(all terraform components/modules)
RUN mkdir terraform
RUN mkdir code
COPY . terraform

ENV APK_DEV "gcc libffi-dev musl-dev openssl-dev python3-dev pipx make"
ENV APK_ADD "bash sudo shadow curl py3-pip graphviz git jq"
#error ibssl3 https://askubuntu.com/questions/1408000/unable-to-locate-package-libssl1-1
ENV APK_POWERSHELL="ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl3 libstdc++ tzdata userspace-rcu zlib icu-libs"

#resolve error in pipx due to conflict package manager (EXTERNAL-MANAGE-BY)
#https://stackoverflow.com/questions/75608323/how-do-i-solve-error-externally-managed-environment-every-time-i-use-pip-3
#https://askubuntu.com/questions/1465218/pip-error-on-ubuntu-externally-managed-environment-%C3%97-this-environment-is-extern
RUN apk upgrade --update && \
    apk add --no-cache --virtual .pipeline-deps readline linux-pam && \
    apk add --no-cache --virtual .build ${APK_DEV} && \
    apk add --no-cache ${APK_ADD} ${APK_POWERSHELL} && \
    # Install Azure CLI
    pipx ensurepath && \
    pipx install wheel && \
    pipx inject wheel wheel==0.42.0 && \ 
    pipx install azure-cli && \
    pipx inject azure-cli azure-cli==2.56.0 && \ 
    apk del .build && \
    apk del .pipeline-deps 
 
RUN echo "PS1='\n\[\033[01;35m\][\[\033[0m\]Terraform\[\033[01;35m\]]\[\033[0m\]\n\[\033[01;35m\][\[\033[0m\]\[\033[01;32m\]\w\[\033[0m\]\[\033[01;35m\]]\[\033[0m\]\n \[\033[01;33m\]->\[\033[0m\] '" >> ~/.bashrc 

CMD tail -f /dev/null
#ENTRYPOINT [ "/usr/bin/tail" ]:
#ENTRYPOINT [ "terraform" ]:
#https://www.squadcast.com/questions/how-to-use-terraform-with-docker
#https://gist.github.com/rkaneko/dc7a4a271958bda631ce7a9768715f82