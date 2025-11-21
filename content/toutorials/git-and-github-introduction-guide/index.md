---
title: "Git与GitHub技术小白入门指南"
date: 2025-11-02
draft: false
description: "Git与GitHub技术小白入门指南"
summary: "一目了然，掌握Git的基本概念及其工作流程，并阐述了GitHub作为协作平台的作用，帮助技术小白快速掌握从安装、分支管理到协作开发的完整使用方法。"
slug: "git-and-github-introduction-guide"
tags: ["git", "github"]
---

# Git与GitHub入门指南

![Git远程示意图](https://github.githubassets.com/assets/git-guides-ba03f3804dde.png)

Git是一款分布式版本控制软件，用于记录代码的历史变更，支持多分支开发和远程协作。本文将带你从零开始了解Git的基本概念、优势、常用命令及工作流程，并介绍GitHub平台如何助力团队协作。

---

## 什么是Git？

Git是一种分布式版本控制系统，意味着每个开发者本地都有完整的仓库副本，包括所有提交、分支和文件。与集中式版本控制不同，Git允许离线操作并提供更强的灵活性。

- 分支轻量且易创建，支持大量分支并行开发
- 通过SHA哈希存储变更，适合文本文件版本管理，不适合大二进制文件
- 支持本地和远程仓库连接，方便推送（push）和拉取（pull）代码

## Git的编写语言

Git核心组件由C语言、Shell脚本、Perl和Tcl编写，源代码托管在GitHub的[git/git仓库](https://github.com/git/git)。

## 为什么使用Git？

使用版本控制可以有效防止代码丢失，Git具有以下显著优势：

### 速度快

Git通过SHA压缩技术，使代码提交和检索速度极快。

### 处理合并冲突能力强

允许多人同时编辑同一文件，Git能智能处理冲突，保障团队协作顺畅。

### 分支成本低

分支创建和管理成本低，开发者可以在分支中安全开发，及时推送并获得反馈。

### 易于回滚

提交不可更改，只能新增替代提交，支持轻松回退到历史版本，降低开发风险。

## 如何使用Git？

### 学习Git基础命令

推荐使用[Git速查表](https://github.github.io/training-kit/)，其中包含常用命令：

```bash
# 克隆远程仓库
git clone [url]

# 查看当前状态
git status

# 查看分支
git branch

# 切换分支
git checkout [branch-name]

# 添加文件到暂存区
git add [file]

# 提交代码并添加说明
git commit -m "commit message"

# 拉取远程更新并合并
git pull

# 推送本地提交
git push

# 查看提交日志
git log

# 查看远程仓库信息
git remote -v

```

更多GitHub相关的技术文档可参考[GitHub帮助文档](https://help.github.com/)。

### Git工作流入门

1. **创建分支**：从主分支`main`切出新分支，建议以功能命名。
2. **修改并提交**：编辑代码后，使用`git add`和`git commit`保存变更。
3. **推送代码到远程**：首次推送新分支时，使用`git push -u origin [branch-name]`建立关联。
4. **发起拉取请求（Pull Request）**：请求将分支合并到`main`，便于代码审查和集成测试。
5. **协作开发**：团队成员可以在拉取请求中评论、审查并提出修改建议。
6. **合并分支**：确认无误后，将功能分支合并到`main`，并删除已完成的分支。

### GitHub简介

GitHub是基于Git的协作平台，支持拉取请求、代码评审、集成测试等功能，极大提升团队开发效率。开发者通常在本地使用Git进行开发，通过GitHub进行远程协作。

学习Git与GitHub的最佳实践课程推荐[GitHub学习实验室](https://lab.github.com/githubtraining/introduction-to-github)。

---

## **设置 Git与**GitHub

### 1、下载并安装最新版本的Git

检查本地 Git 是否安装并可用bash

```bash
git --version
```

- 如果返回类似 git version 2.x.x，说明 Git 已安装。

### 综合一键检测脚本（复制粘贴运行）

```bash
echo "1. 检查 Git 版本..."
git --version

echo -e "\n2. 测试 HTTPS 连接..."
curl -I https://github.com 2>/dev/null | head -n 1

echo -e "\n3. 测试 Git 远程访问..."
git ls-remote https://github.com/git/git.git >/dev/null 2>&1 && echo "Git 连接 GitHub 成功" || echo "Git 连接失败"

echo -e "\n4. 测试 SSH 连接（如果使用 SSH）..."
ssh -T git@github.com 2>&1
```

---

### **2、配置Git身份信息**

打开终端，输入以下命令配置用户名和邮箱：

```bash
git config --global user.name "你的名字"
git config --global user.email "你的GitHub邮箱"
```

### **3、配置GitHub SSH密钥（推荐）**

打开本地终端，输入以下代码，生成并添加SSH密钥，确保安全免密码推送：

```bash
# 生成SSH密钥
ssh-keygen -t ed25519 -C "你的GitHub邮箱"

# 直接回车三次使用默认路径且不设置密码

# 查看公钥内容
cat ~/.ssh/id_ed25519.pub
```

打开 GitHub → Settings → SSH and GPG keys → New SSH key标题随便填，粘贴刚才复制的内容 → Add SSH key

### 4、测试git和GitHub连通

终端输入代码：

```bash
ssh -T git@github.com
```

成功会返回：

```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

如果提示 Permission denied (publickey)，说明 SSH 密钥未配置或未加载。

---

## Git基本操作流程

### 场景一：本地全新项目 → 推到 GitHub 新仓库

```bash
# 1. 进入项目文件夹
cd /path/to/your/project

# 2. 初始化 Git 仓库
git init

# 3. 添加所有文件
git add .

# 4. 提交（写个有意义的留言）
git commit -m "初次提交：我的超级项目 v1.0"

# 5. 在 GitHub 网页新建仓库（别勾初始化 README！）
#    仓库名：my-awesome-project

# 6. 复制 GitHub 给的 SSH 地址，例如：
#    git@github.com:vincentS1981/my-awesome-project.git

# 7. 关联远程仓库
git remote add origin git@github.com:vincentS1981/my-awesome-project.git

# 8. 推上去！（-u 记住以后直接 git push）
git push -u origin main
```

### 场景二：本地已有 Git 项目 → 推到 GitHub

```bash
cd /path/to/your/existing-project

# 确认已有 commit
git log --oneline

# 关联 + 推送（同上 7~8）
git remote add origin git@github.com:vincentS1981/existing-project.git
git push -u origin main
```

### 每天更新代码只需 3 行

```bash
git add .
git commit -m "修复了登录 bug"
git push
```

## 相关资源

- [GitHub官网](https://github.com/)
- [GitHub学习路径](https://resources.github.com/learn/pathways)
- [GitHub文档](https://docs.github.com/)
- [GitHub市场](https://github.com/marketplace)