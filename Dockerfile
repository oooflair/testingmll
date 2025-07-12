FROM debian:bullseye-slim
ARG TARGETARCH=amd64

RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    curl \
    bash \
    git \
    netcat \
    awscli && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LO "https://get.helm.sh/helm-v3.14.0-linux-${TARGETARCH}.tar.gz" && \
    tar -zxvf helm-v3.14.0-linux-${TARGETARCH}.tar.gz && \
    mv linux-${TARGETARCH}/helm /usr/local/bin/helm && \
    rm -rf helm-v3.14.0-linux-${TARGETARCH}.tar.gz linux-${TARGETARCH}

RUN curl -LO "https://dl.k8s.io/release/v1.30.1/bin/linux/${TARGETARCH}/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/kubectl

RUN curl -LO "https://github.com/infracloudio/infrakit/releases/latest/download/infractl-linux-${TARGETARCH}" && \
    chmod +x infractl-linux-${TARGETARCH} && mv infractl-linux-${TARGETARCH} /usr/local/bin/infractl

RUN curl -L https://anypoint.mulesoft.com/runtimefabric/api/download/rtfctl/latest -o /usr/local/bin/rtfctl && \
    chmod +x /usr/local/bin/rtfctl

CMD ["/bin/bash"]




✅ 1️⃣ Use docker save + split to Create Uploadable Chunks
Example:

bash
Copy
Edit
docker save mule_rtfctl_gocd:latest | gzip > mule_rtfctl_gocd_latest.tar.gz
split -b 19m mule_rtfctl_gocd_latest.tar.gz mule_rtfctl_gocd_part_
-b 19m: creates 19 MB chunks (below GitHub’s 20 MB limit).

Files generated:
mule_rtfctl_gocd_part_aa, mule_rtfctl_gocd_part_ab, etc.

Reassemble:
On another system:

bash
Copy
Edit
cat mule_rtfctl_gocd_part_* > mule_rtfctl_gocd_latest.tar.gz
gunzip mule_rtfctl_gocd_latest.tar.gz
docker load < mule_rtfctl_gocd_latest.tar