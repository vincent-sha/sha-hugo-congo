#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# 构建部署Hugo站点到Cloudflare Worker的脚本
#
# Cloudflare Worker会自动安装所需的Node.js依赖
#------------------------------------------------------------------------------

main() {

  DART_SASS_VERSION=1.93.2
  GO_VERSION=1.25.3
  HUGO_VERSION=0.152.2
  NODE_VERSION=22.20.0

  export TZ=Europe/Oslo

  # 安装Dart Sass
  echo "Installing Dart Sass ${DART_SASS_VERSION}..."
  curl -sLJO "<https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz>"
  tar -C "${HOME}/.local" -xf "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
  rm "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
  export PATH="${HOME}/.local/dart-sass:${PATH}"

  # 安装Go语言
  echo "Installing Go ${GO_VERSION}..."
  curl -sLJO "<https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz>"
  tar -C "${HOME}/.local" -xf "go${GO_VERSION}.linux-amd64.tar.gz"
  rm "go${GO_VERSION}.linux-amd64.tar.gz"
  export PATH="${HOME}/.local/go/bin:${PATH}"

  # 安装Hugo
  echo "Installing Hugo ${HUGO_VERSION}..."
  curl -sLJO "<https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz>"
  mkdir "${HOME}/.local/hugo"
  tar -C "${HOME}/.local/hugo" -xf "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  rm "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  export PATH="${HOME}/.local/hugo:${PATH}"

  # 安装Node.js
  echo "Installing Node.js ${NODE_VERSION}..."
  curl -sLJO "<https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz>"
  tar -C "${HOME}/.local" -xf "node-v${NODE_VERSION}-linux-x64.tar.xz"
  rm "node-v${NODE_VERSION}-linux-x64.tar.xz"
  export PATH="${HOME}/.local/node-v${NODE_VERSION}-linux-x64/bin:${PATH}"

  # 验证安装情况
  echo "Verifying installations..."
  echo Dart Sass: "$(sass --version)"
  echo Go: "$(go version)"
  echo Hugo: "$(hugo version)"
  echo Node.js: "$(node --version)"

  # 配置Git
  echo "Configuring Git..."
  git config core.quotepath false
  if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    git fetch --unshallow
  fi

  # 构建站点
  echo "Building the site..."
  hugo --gc --minify

}

set -euo pipefail
main "$@"
