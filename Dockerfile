FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install curl keyutils gpg git awscli kwalletmanager pass vim-common jq

# gopass
RUN version=$(curl -s https://api.github.com/repos/gopasspw/gopass/releases/latest | grep -Po '"tag_name": "\K.*?(?=")' | tr -d v) \
    && curl -Lo /tmp/gopass-${version}-linux-amd64.tar.gz https://github.com/gopasspw/gopass/releases/download/v${version}/gopass-${version}-linux-amd64.tar.gz  \
    && tar xzf /tmp/gopass-${version}-linux-amd64.tar.gz -C /tmp/  \
    && install -o root -g root -m 0755 /tmp/gopass /usr/local/bin/gopass && rm -f /tmp/gopass

# ripgrep
RUN version=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -Po '"tag_name": "\K.*?(?=")') && \
    cd /tmp && \
    curl -sLo /usr/local/src/ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz https://github.com/BurntSushi/ripgrep/releases/download/$version/ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz && \
    tar xzf /usr/local/src/ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz && \
    install -o root -g root -m 0755 /tmp/ripgrep-${version}-x86_64-unknown-linux-musl/rg /usr/local/bin/rg && \
    rg --version

# aws-vault
RUN version=$(curl -s https://api.github.com/repos/99designs/aws-vault/releases/latest | grep -Po '"tag_name": "\K.*?(?=")' | tr -d v) && \
    echo $version && \
    curl -Lo /tmp/aws-vault-linux-amd64 https://github.com/99designs/aws-vault/releases/download/v$version/aws-vault-linux-amd64 && \
    install -o root -g root -m 0755 /tmp/aws-vault-linux-amd64 /usr/local/bin/aws-vault-linux-amd64 && \
    ln -fs /usr/local/bin/aws-vault-linux-amd64 /usr/local/bin/aws-vault && \
    aws-vault --version

# ~/.gitconfig
RUN curl -Lo /root/.gitconfig https://raw.githubusercontent.com/TaylorMonacelli/dotfiles/master/.gitconfig
RUN echo alias g=git >>/root/.bashrc
