---
title: "Hugo静态网站目录结构详解"
date: 2025-10-30
draft: false
description: "Hugo静态网站目录结构详解"
summary: "本文详细介绍了Hugo静态网站生成器的目录结构，包括新建站点时生成的项目骨架、各个子目录的作用、Union文件系统的应用以及主题骨架结构，帮助用户更好地理解和管理Hugo项目文件。"
slug: "hugo-directory-structure"
tags: ["hugo", "目录结构"]
---

# Hugo 目录结构详解

## 目录结构概述

Hugo 是一个流行的静态网站生成器，每个 Hugo 项目是一个目录，包含多个子目录，这些子目录共同决定了网站的内容、结构、行为和展示方式。

---

## 站点骨架

使用以下命令创建新站点时，Hugo 会生成如下骨架目录结构：

```bash
hugo new site my-site

```

生成的目录结构示例：

```
my-site/
├── archetypes/       # 内容模板目录
│   └── default.md
├── assets/           # 静态资源，如图片、Sass、JS等
├── content/          # 网站内容，通常为Markdown文件
├── data/             # 数据文件，如JSON、TOML、YAML
├── i18n/             # 多语言翻译文件
├── layouts/          # 模板文件
├── static/           # 静态文件，如favicon.ico、robots.txt
├── themes/           # 主题文件
└── hugo.toml         # 站点配置文件

```

### 可选的配置目录结构

对于需求更复杂的项目，可以将配置拆分为子目录：

```
my-site/
├── config/
│   └── _default/
│       └── hugo.toml
# 其他目录同上

```

### 构建后的目录结构

构建网站时，Hugo 会生成 `public` 和 `resources` 目录：

```
my-site/
├── public/       # 生成的静态网站文件
├── resources/    # 缓存的资源文件，如CSS和图片
# 其他目录同上

```

---

## 主要目录说明

| 目录 | 说明 |
| --- | --- |
| archetypes | 新内容模板，方便快速创建新内容。 |
| assets | 资源文件，经过资产管线处理，如CSS、JS、图片。 |
| config | 配置文件目录，支持多环境配置。 |
| content | 站点内容，通常为Markdown文件。 |
| data | 额外数据文件，可用于增强内容和配置。 |
| i18n | 多语言翻译表，支持多语言网站。 |
| layouts | 模板文件，控制内容渲染方式。 |
| public | 构建生成的静态页面目录。 |
| resources | 构建时缓存资源，如压缩后的CSS和图片。 |
| static | 静态文件，直接复制到发布目录。 |
| themes | 主题目录，存放主题相关文件。 |

详细文档链接：[Hugo 目录结构](http://gohugo.io/getting-started/directory-structure/)

---

## Union 文件系统（Union File System）

Hugo 支持将多个目录“合并”挂载到同一位置，实现内容共享。例如：

```
home/user/
├── my-site/
│   ├── content/
│   │   └── books/
│   └── hugo.toml
└── shared-content/
    └── films/

```

通过配置挂载，shared-content 目录内的内容可以合并到 my-site 的 content 目录中：

### YAML 配置示例

```yaml
module:
  mounts:
  - source: content
    target: content
  - source: /home/user/shared-content
    target: content

```

### TOML 配置示例

```toml
[module]
  [[module.mounts]]
    source = 'content'
    target = 'content'
  [[module.mounts]]
    source = '/home/user/shared-content'
    target = 'content'

```

### JSON 配置示例

```json
{
  "module": {
    "mounts": [
      {"source": "content", "target": "content"},
      {"source": "/home/user/shared-content", "target": "content"}
    ]
  }
}

```

挂载后目录结构示意：

```
my-site/
└── content/
    ├── books/
    └── films/

```

注意：同一路径的文件优先级按照挂载顺序决定，且Hugo不支持符号链接，推荐使用union文件系统实现类似功能。

支持挂载目录包括：`archetypes`、`assets`、`content`、`data`、`i18n`、`layouts`、`static`。

详情参考：[Hugo Module Mounts](http://gohugo.io/configuration/module/#mounts) 和 [Hugo Modules](http://gohugo.io/hugo-modules/)。

---

## 主题骨架

通过命令创建新主题时，Hugo 生成如下基本结构：

```bash
hugo new theme my-theme

```

主题目录示例：

```
my-theme/
├── archetypes/
├── assets/
├── content/
├── data/
├── i18n/
├── layouts/
├── static/
└── hugo.toml

```

Hugo 会将主题目录挂载到项目对应位置，项目目录中的同路径文件优先级更高，方便用户覆盖主题模板。

多主题或模块同时使用时，挂载顺序决定文件优先级。

---

## 相关链接

- [Hugo 官网](http://gohugo.io/)
- [快速开始](http://gohugo.io/getting-started/quick-start/)
- [使用指南](http://gohugo.io/getting-started/usage/)
- [主题市场](https://themes.gohugo.io/)
- [社区支持](https://discourse.gohugo.io/)