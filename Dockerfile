FROM ubuntu:22.04

RUN apt update && apt upgrade -y && \
    apt install -y ca-certificates curl apt-transport-https lsb-release gnupg jq libicu-dev git wget && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /var/lib/apt/lists/*

ARG CODEQL_VERSION=2.15.4
RUN useradd -m agent

# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp
COPY ./start.sh /azp/

RUN chmod +x /azp/start.sh && \
    chown -R agent:agent /azp && \
    chmod 755 /azp
USER agent

RUN wget https://github.com/github/codeql-action/releases/download/codeql-bundle-v${CODEQL_VERSION}/codeql-bundle-linux64.tar.gz -P /tmp && \
    mkdir -p /azp/_work/_tool/CodeQL/0.0.0-${CODEQL_VERSION}/x64 && \
    tar xvf /tmp/codeql-bundle-linux64.tar.gz -C /azp/_work/_tool/CodeQL/0.0.0-${CODEQL_VERSION}/x64 && \
    touch /azp/_work/_tool/CodeQL/0.0.0-${CODEQL_VERSION}/x64.complete && \
    rm /tmp/codeql-bundle-linux64.tar.gz

ENTRYPOINT [ "./start.sh" ]
