---
title: "使用 GitHub Pages 托管 Hugo 网站"
date: 2025-11-06
draft: false
description: "GitHub Pages部署Hugo网站的方法"
summary: "本文详细介绍了如何将 Hugo 静态网站托管到 GitHub Pages 上，包括不同类型的 GitHub Pages 网站介绍、前置准备条件、具体部署步骤，以及如何自定义 GitHub Actions 工作流来实现自动构建和部署，帮助用户轻松搭建个人或项目网站。"
slug: "deploy-hugo-site-with-github-pages"
tags: ["hugo", "github"]
---
# 使用 GitHub Pages 托管 Hugo 网站

GitHub Pages 是 GitHub 提供的免费托管静态网站的服务，本文将指导你如何将使用 Hugo 构建的网站部署到 GitHub Pages 上，实现自动化构建与发布。

---

## 一、GitHub Pages 网站类型

GitHub Pages 有三种类型：

- **项目站点（Project sites）**：与 GitHub 上的特定项目仓库关联。
- **用户站点（User sites）**：与个人 GitHub 账号关联。
- **组织站点（Organization sites）**：与组织账号关联。

详细的仓库所有权和命名要求可参考[GitHub Pages官方文档](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages#types-of-github-pages-sites)。

## 二、部署前准备

在开始之前，请确保完成以下步骤：

1. 注册并登录你的 [GitHub 账号](https://github.com/signup)。
2. 创建项目的 [GitHub 仓库](https://github.com/new)。
3. 在本地创建 Git 仓库并关联远程 GitHub 仓库。
4. 使用 Hugo 创建本地网站并通过 `hugo server` 测试。
5. 提交更改并推送到 GitHub 仓库。

## 三、部署步骤

### 1. 配置 GitHub Pages 源

打开 GitHub 仓库，依次进入 **Settings > Pages**，将 Source 设置为 `GitHub Actions`，该操作无需保存，修改即时生效。

![GitHub Pages 设置界面](http://gohugo.io/host-and-deploy/host-on-github-pages/gh-pages-01.png)

### 2. 修改 Hugo 配置缓存目录

在你的 Hugo 配置文件中（`config.yaml` / `config.toml` / `config.json`），设置图片缓存目录为 `:cacheDir/images` ，示例如下：

```yaml
caches:
  images:
    dir: :cacheDir/images

```

```toml
[caches]
  [caches.images]
    dir = ':cacheDir/images'

```

```json
{
  "caches": {
    "images": {
      "dir": ":cacheDir/images"
    }
  }
}

```

详细配置参考[配置文件缓存](http://gohugo.io/configuration/caches/)。

### 3. 创建 GitHub Actions 工作流文件

在项目根目录下创建 `.github/workflows/hugo.yaml` 文件：

```bash
mkdir -p .github/workflows
touch .github/workflows/hugo.yaml

```

### 4. 配置工作流内容

将以下内容复制到 `hugo.yaml` 文件中：

```yaml
name: Build and deploy
on:
  push:
    branches:
      - main
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
concurrency:
  group: pages
  cancel-in-progress: false
defaults:
  run:
    shell: bash
jobs:
  build:
    runs-on: ubuntu-latest
    env:
      DART_SASS_VERSION: 1.93.2
      GO_VERSION: 1.25.3
      HUGO_VERSION: 0.152.2
      NODE_VERSION: 22.20.0
      TZ: Europe/Oslo
    steps:
      - name: Checkout
        uses: actions/checkout@v5
        with:
          submodules: recursive
          fetch-depth: 0
      - name: Setup Go
        uses: actions/setup-go@v5
        with:
          go-version: ${{ env.GO_VERSION }}
          cache: false
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5
      - name: Create directory for user-specific executable files
        run: |
          mkdir -p "${HOME}/.local"
      - name: Install Dart Sass
        run: |
          curl -sLJO "<https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz>"
          tar -C "${HOME}/.local" -xf "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
          rm "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
          echo "${HOME}/.local/dart-sass" >> "${GITHUB_PATH}"
      - name: Install Hugo
        run: |
          curl -sLJO "<https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz>"
          mkdir "${HOME}/.local/hugo"
          tar -C "${HOME}/.local/hugo" -xf "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
          rm "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
          echo "${HOME}/.local/hugo" >> "${GITHUB_PATH}"
      - name: Verify installations
        run: |
          echo "Dart Sass: $(sass --version)"
          echo "Go: $(go version)"
          echo "Hugo: $(hugo version)"
          echo "Node.js: $(node --version)"
      - name: Install Node.js dependencies
        run: |
          [[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true
      - name: Configure Git
        run: |
          git config core.quotepath false
      - name: Cache restore
        id: cache-restore
        uses: actions/cache/restore@v4
        with:
          path: ${{ runner.temp }}/hugo_cache
          key: hugo-${{ github.run_id }}
          restore-keys:
            hugo-
      - name: Build the site
        run: |
          hugo \\
            --gc \\
            --minify \\
            --baseURL "${{ steps.pages.outputs.base_url }}/" \\
            --cacheDir "${{ runner.temp }}/hugo_cache"
      - name: Cache save
        id: cache-save
        uses: actions/cache/save@v4
        with:
          path: ${{ runner.temp }}/hugo_cache
          key: ${{ steps.cache-restore.outputs.cache-primary-key }}
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4

```

### 5. 提交并推送工作流文件

```bash
git add .github/workflows/hugo.yaml
git commit -m "添加 GitHub Actions 自动部署工作流"
git push origin main

```

### 6. 观察 GitHub Actions 运行状态

进入 GitHub 仓库的 **Actions** 页面，查看构建和部署流程，状态完成后显示绿色表示成功。

![GitHub Actions 运行状态](http://gohugo.io/host-and-deploy/host-on-github-pages/gh-pages-03.png)

### 7. 访问部署好的网站

点击成功构建的日志中“Deploy”步骤下的链接即可访问你的在线网站。

## 四、自定义工作流

如果你的网站、主题或模块不需要 Dart Sass 转换 Sass 到 CSS，可以移除安装 Dart Sass 的步骤以加快构建速度：

```yaml
- name: Install Dart Sass
  run: sudo snap install dart-sass

```

## 五、其他资源

- [GitHub Actions 官方文档](https://docs.github.com/en/actions)
- [缓存依赖提升工作流速度](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)
- [GitHub Pages 自定义域名管理](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages)