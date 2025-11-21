---
title: "Hugo 模块使用指南"
date: 2025-11-06
draft: false
description: "Hugo 模块使用指南"
summary: "本文详细介绍了 Hugo 模块的使用方法，包括模块初始化、主题模块导入、模块更新、依赖管理、本地开发支持以及模块缓存清理等内容，帮助用户高效管理 Hugo 网站的模块化资源。"
slug: "use-hugo-modules"
tags: ["hugo", "模块"]
---

# Hugo 模块使用指南

Hugo 模块基于 Go Modules 技术，能够帮助用户更好地组织和管理网站资源。本文将详细介绍如何使用 Hugo 模块来提高网站开发效率。

---

## 1. 前提条件

- 需要安装 [Go 1.18 及以上版本](https://go.dev/doc/install)
- 需要安装 [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- 对于在 Netlify 上托管的旧网站，确保环境变量 `GO_VERSION` 设置为 `1.18` 或更高版本。

更多关于 Go Modules 的资料：

- [Go Modules Wiki](https://go.dev/wiki/Modules)
- [Go Modules 使用博客](https://go.dev/blog/using-go-modules)

---

## 2. 初始化新模块

使用命令初始化新的 Hugo 模块：

```bash
hugo mod init github.com/<你的GitHub用户名>/<你的项目名>

```

如果 Hugo 无法自动推断模块路径，需要手动传入路径参数。

详细命令文档：[hugo mod init](http://gohugo.io/commands/hugo_mod_init/)

---

## 3. 使用模块作为主题

最简便的方式是在配置文件中导入主题模块。

1. 初始化 Hugo 模块系统：

```bash
hugo mod init github.com/<你的用户名>/<你的项目名>

```

1. 在配置文件中添加主题模块导入（支持 YAML、TOML 和 JSON 格式）：

**YAML 示例**

```yaml
module:
  imports:
    - path: github.com/spf13/hyde

```

**TOML 示例**

```toml
[module]
  [[module.imports]]
    path = "github.com/spf13/hyde"

```

**JSON 示例**

```json
{
  "module": {
    "imports": [
      { "path": "github.com/spf13/hyde" }
    ]
  }
}

```

---

## 4. 模块更新管理

模块会在配置中作为导入时自动下载和添加。你可以使用 `hugo mod get` 命令来更新和管理版本。

### 常用示例

- 更新所有模块：

```bash
hugo mod get -u

```

- 递归更新所有模块：

```bash
hugo mod get -u ./...

```

- 更新某个指定模块：

```bash
hugo mod get -u github.com/gohugoio/myShortcodes

```

- 获取指定版本模块：

```bash
hugo mod get github.com/gohugoio/myShortcodes@v1.0.7

```

详细命令文档：[hugo mod get](http://gohugo.io/commands/hugo_mod_get/)

---

## 5. 本地开发：模块修改与测试

为方便本地开发，可以在 `go.mod` 文件中添加替换指令，将模块指向本地目录：

```bash
replace github.com/bep/hugotestmods/mypartials => /Users/bep/hugotestmods/mypartials

```

当你运行 `hugo server` 时，配置会自动重载，且本地目录会被监视以实现热更新。

也可以通过配置文件中的 `replacements` 选项实现替换，避免直接修改 `go.mod`。

---

## 6. 打印依赖关系图

运行以下命令可以显示模块依赖关系，包括替换和禁用状态：

```bash
hugo mod graph

```

示例输出：

```
github.com/bep/my-modular-site github.com/bep/hugotestmods/mymounts@v1.2.0
github.com/bep/my-modular-site github.com/bep/hugotestmods/mypartials@v1.0.7
... (省略)

```

详细命令文档：[hugo mod graph](http://gohugo.io/commands/hugo_mod_graph/)

---

## 7. 模块依赖的供应商化（Vendor）

执行以下命令将所有依赖写入 `_vendor` 目录：

```bash
hugo mod vendor

```

注意事项：

- 可在模块树的任意层级执行命令
- 不会存储 `themes` 目录中的模块
- 多数命令支持 `-ignoreVendorPaths` 标志，允许忽略特定路径的供应商模块

详细命令文档：[hugo mod vendor](http://gohugo.io/commands/hugo_mod_vendor/)

---

## 8. 清理与整理模块缓存

- 运行 `hugo mod tidy` 清理 `go.mod` 和 `go.sum` 中未使用的依赖条目
- 运行 `hugo mod clean` 删除整个模块缓存

更多缓存配置请参考：[缓存配置](http://gohugo.io/configuration/caches/)

命令文档：

- [hugo mod tidy](http://gohugo.io/commands/hugo_mod_clean/)
- [hugo mod clean](http://gohugo.io/commands/hugo_mod_clean/)

---

## 9. 模块工作空间支持

从 Go 1.18 开始支持工作空间，Hugo 从 v0.109.0 开始支持工作空间功能。此功能方便同时开发站点和主题模块。

### 配置方法

1. 创建 `.work` 文件，例如 `hugo.work`，内容示例：

```
go 1.20

use .
use ../gohugoioTheme

```

1. 通过 `HUGO_MODULE_WORKSPACE` 环境变量激活工作空间：

```bash
HUGO_MODULE_WORKSPACE=hugo.work hugo server --ignoreVendorPaths "**"

```

- `-ignoreVendorPaths` 选项用于忽略 `_vendor` 目录下的依赖，方便本地开发实时同步修改。

---

更多详情请访问官方文档：[Hugo Modules 使用指南](https://gohugo.io/hugo-modules/use-modules/)