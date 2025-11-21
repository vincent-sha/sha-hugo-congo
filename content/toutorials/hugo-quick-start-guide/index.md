---
title: "Hugo静态网站快速入门指南"
date: 2025-11-06
draft: false
description: "Hugo快速入门"
summary: "本文详细介绍了如何快速搭建一个 Hugo 网站，包括环境准备、创建站点、添加内容、配置网站和发布站点的完整流程。适合有一定命令行基础的用户快速上手 Hugo 静态网站生成器。"
slug: "hugo-quick-start-guide"
tags: ["hugo", "入门"]
---

# Hugo 快速入门指南（Mac平台）

## 简介

Hugo 是一个流行的静态网站生成器，能够帮助用户快速创建高性能的网站。本文将引导你在几分钟内搭建一个 Hugo 网站。

---

## 前提条件

### 安装 Homebrew

打开 Terminal（终端），输入以下命令：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

验证 Homebrew 安装成功

```bash
brew --version
```

输出类似：

```bash
Homebrew 4.x.x
```

### 安装 Git

```bash
brew install git
```

### 安装 Hugo Extended 版

```bash
brew install hugo
```

> 注意（Windows 用户）：
> 
> - 请避免使用命令提示符（Command Prompt）和 Windows PowerShell。
> - 推荐使用 PowerShell（最新版）或 Linux 终端（如 WSL 或 Git Bash）。

## 创建站点

### 主要命令

```bash
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
echo "theme = 'ananke'" >> hugo.toml
hugo server

```

执行以上命令后，你可以在终端显示的地址访问你的网站。

### 命令详解

- `hugo new site quickstart`：创建名为 `quickstart` 的项目目录及基本目录结构。
- `cd quickstart`：进入项目根目录。
- `git init`：初始化一个空的 Git 仓库。
- `git submodule add https: //github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke`：将 Ananke 主题作为子模块添加到项目中。
- `echo "theme = 'ananke'" >> hugo.toml`：在配置文件中指定主题。
- `hugo server`：启动 Hugo 开发服务器，实时预览网站。

> 按 Ctrl + C 停止开发服务器。
> 

## 添加内容

创建新内容页面：

```bash
hugo new content/posts/my-first-post.md

```

此命令会在 `content/posts` 文件夹下生成一个 Markdown 文件，默认带有如下 Front Matter：

```toml
+++
title = "My First Post"
date = 2024-01-14T07:07:07+01:00
draft = true
+++

```

- `draft = true` 表示该内容为草稿，默认不会被发布。
- 你可以编辑正文部分，使用 Markdown 语法，例如：

```markdown
## 介绍

这是**加粗**文本，和*斜体*文本。

访问 [Hugo 官网](<https://gohugo.io>)

```

启动开发服务器时，使用 `--buildDrafts` 或 `-D` 参数可以包含草稿内容：

```bash
hugo server --buildDrafts
# 或
hugo server -D

```

编辑完成并准备发布时，请将 `draft` 设置为 `false`。

Hugo 支持 CommonMark 标准的 Markdown，官方提供了[在线测试工具](https://spec.commonmark.org/dingus/)。

## 配置站点

在项目根目录打开 `hugo.toml` 配置文件，示例如下：

```toml
baseURL = '<https://example.org/>'
languageCode = 'en-us'
title = 'My New Hugo Site'
theme = 'ananke'

```

需要根据实际情况修改：

1. `baseURL`：生产环境下网站的基础 URL，需以协议开头并以斜杠结尾。
2. `languageCode`：语言和地区代码，如 `zh-cn`。
3. `title`：网站标题。

保存后重新启动服务器查看效果：

```bash
hugo server -D

```

不同主题可能有额外的配置项，建议查看主题的官方文档。例如，Ananke 主题的配置和使用指南见其[GitHub 仓库](https://github.com/theNewDynamic/gohugo-theme-ananke#readme)和[演示站点](https://gohugo-ananke-theme-demo.netlify.app/)。

## 发布站点

执行以下命令生成完整的静态网站文件：

```bash
hugo

```

生成的文件位于 `public` 文件夹内，包含 HTML、图片、CSS 和 JavaScript 等资源。

> 注意：默认不包含草稿、未来或过期内容。
> 

部署网站到服务器或托管平台请参考 Hugo 的[托管与部署指南](http://gohugo.io/host-and-deploy/)。

## 重新部署

删掉旧站点，用第三方 trash-cli（程序员最爱，它会把文件移到废纸篓，还支持 trash-list、trash-restore 恢复。）

```jsx
# 安装（Homebrew）
brew install trash

# 以后永远用 trash 代替 rm
trash ~/my-site # 删除my-site整个文件夹
trash *.log     # 清理 Hugo 运行时产生的日志文件.log
trash public/ themes/  # 典型清理 Hugo 站点时的“核弹命令”
一次性把生成文件和主题全扔废纸篓
```

实际使用示例（你在 Hugo 项目根目录下）

```jsx
# 你现在在 ~/Projects/my-blog 目录里
cd ~/Projects/my-blog

# 1. 先把 Hugo 生成的完整站点删掉（最常用）
trash public

# 2. 把所有主题删掉（换新主题前常用）
trash themes

# 3. 把运行日志删掉
trash *.log

# 4. 实在不想玩了，连源码一起删（整个站点拜拜）
trash ~/Projects/my-blog
# 或者直接
trash .
# （点表示当前目录，慎用！）
```

## 主题安装、切换和更新

### 添加主题

在您的 Hugo 站点根目录下（例如 `cd mysite`），使用 `git submodule` 命令添加新主题：

```bash
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
```

**说明:**

1. 新的主题仓库会被克隆到您站点的 `themes/ananke` 文件夹中。
2. 您的 `themes` 文件夹中现在有两个主题文件夹：`LoveIt` 和 `ananke`。

### 主题切换

Hugo 站点使用 **配置文件**（ `hugo.toml` ）来决定使用哪个主题。

要切换主题，您只需要修改配置文件中的 `theme` 这一行配置即可。

> 方式一：修改 `hugo.toml` 文件
> 

打开您站点根目录下的 `hugo.toml` 文件（或 `config.toml`）：

**如果要切换到 Ananke 主题，将配置改为：**

```bash
# hugo.toml
baseURL = "http://example.org/"
languageCode = "en-us"
title = "My New Hugo Site"
theme = 'ananke'  # <-- 切换主题，主题名必须与文件夹名一致
```

> 方式二：使用命令行参数（临时切换）
> 

如果您只是想临时预览某个主题而不想永久修改配置文件，可以在运行 `hugo server` 时加上 `--theme` 参数：

```bash
hugo server -D --theme ananke
```

### 更新主题并提交

要更新您已安装的主题（以主题LoveIt为例），在项目根目录下运行以下命令：

```bash
git submodule update --remote themes/LoveIt
```

回到根目录，提交更新：

```bash
git add themes/LoveIt
```

提交更改信息

```bash
git commit -m "更新主题子模块到最新版本"
git push
```

## 求助与资源

- Hugo 官方论坛：https://discourse.gohugo.io/，社区活跃，适合提问和查找问题答案。
- 阅读求助指南：[请求帮助注意事项](https://discourse.gohugo.io/t/requesting-help/9132)
- 更多学习资源，包括书籍和视频教程，见：[外部学习资源](http://gohugo.io/getting-started/external-learning-resources/)

---

## 相关链接

- [Hugo 官网](http://gohugo.io/)
- [Hugo 文档](http://gohugo.io/documentation/)
- [Hugo 主题库](https://themes.gohugo.io/)
- [Hugo GitHub 仓库](https://github.com/gohugoio/hugo)