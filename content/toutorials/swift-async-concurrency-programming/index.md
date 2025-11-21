---
title: "Swift 异步与并发编程"
date: 2025-10-09
draft: false
description: "Swift 异步与并发编程"
summary: "本文详细阐述了Swift 5.5引入的async/await异步编程基础、结构化并发。通过丰富的示意图和代码示例，帮助读者深入理解Swift并发编程核心概念及其底层协作线程池调度模型，提升iOS异步编程的实战能力。"
slug: "swift-async-concurrency-programming"
tags: ["swift", "编程", "异步并发"]
---

# Swift 异步与并发编程

Swift 5.5版本引入了 async/await 语法，极大简化了异步编程。虽然基础用法不复杂，但结合 Actor 模型深入使用仍需学习。

---

## 基本概念澄清

### 同步

同步操作会阻塞当前线程，直到操作完成（函数返回或抛出），期间线程不能执行其他任务。

![同步示意图](http://zhiying.space/assets/img/post/swift-async/sync.png)

### 异步

异步操作在后台线程执行，不阻塞调用线程，避免阻塞UI更新。

![异步示意图](http://zhiying.space/assets/img/post/swift-async/async.png)

### 串行

串行指任务严格按调用顺序执行，同步和异步均可串行执行。

同步串行示意：

![同步串行](http://zhiying.space/assets/img/post/swift-async/serial-sync.png)

异步串行示意：

![异步串行](http://zhiying.space/assets/img/post/swift-async/serial-async.png)

### 并行

多线程同时执行多个任务称为并行。

![并行示意图](http://zhiying.space/assets/img/post/swift-async/parallel.png)

### Swift 并发

Swift 并发指异步与并行代码的结合，更易理解且不包含同线程多操作交替执行的并发。

---

## 异步函数 Async

定义示例：

```swift
func loadSignature() async -> String

```

`async` 确保函数体内可用 `await`，调用时必须使用 `await`。

`await` 表示可能暂停当前线程的执行，等待异步结果。

---

## 结构化并发

异步函数执行环境由任务(Task)决定，线程概念被弱化。通过 `Task.init` 创建异步上下文。

同步串行执行示例：

```swift
func someSyncMethod() {
  Task {
    await loadFromDatabase()
    await loadSignature()
    print("Done")
  }
}

```

两异步操作串行执行。若无依赖，可并行执行，提升效率，方法有两种：

- `async let`
- `withTaskGroup`

`async let` 示例：

```swift
func someSyncMethod() {
  Task {
    async let loadStrings = loadFromDatabase()
    async let loadSignature = loadSignature()

    await loadStrings
    await loadSignature
    print("Done")
  }
}

```

---

## Actor 模型

Actor 提供数据隔离，保障并发安全，避免数据竞争，性能优于传统线程锁。

示例Actor定义：

```swift
actor Room {
  let roomNumber = "101"
  var visitorCount: Int = 0

  init() {}

  func visit() -> Int {
    visitorCount += 1
    return visitorCount
  }
}

```

外部调用必须在异步上下文中通过 `await` 使用Actor成员：

```swift
let room = Room()
let visitCount = await room.visit()
print(visitCount)
print(await room.visitorCount)

```

### isolated 与 nonisolated

- `isolated` 表示函数体运行在指定Actor隔离域中。
- `nonisolated` 表示函数运行在Actor隔离域外。

示例：

```swift
func reportRoom(room: isolated Room) {
  print("Room: \\(room.visitorCount)")
}

actor Room {
  func doSomething() async {
    reportRoom(room: self) // 同隔离域，无需await

    let anotherRoom = Room()
    await reportRoom(room: anotherRoom) // 跨隔离域，需await
  }
}

```

### MainActor

全局Actor，代表主线程，通常隔离UI相关代码。可用 `@MainActor` 标记类、属性或方法。

Task切换到主Actor示例：

```swift
Task { @MainActor in
  // UI相关操作
}

```

---

## 异步函数的封装与运行环境

### 封装已有闭包为异步函数

```swift
func load() async throws -> [String] {
  try await withUnsafeThrowingContinuation { continuation in
    load { values, error in
      if let error {
        continuation.resume(throwing: error)
      } else if let values {
        continuation.resume(returning: values)
      } else {
        assertionFailure("Both parameters are nil")
      }
    }
  }
}

```

保证 `resume` 仅调用一次。

### 运行环境

异步函数有“传染性”，调用者也需变成异步函数。最顶层运行环境由 `Task` 提供。

同步函数内启动异步任务示例：

```swift
func syncMethod() throws {
  Task {
    try await asyncMethod()
  }
}

```

SwiftUI中使用 `.task` modifier示例：

```swift
var body: some View {
  ProgressView()
    .task {
      try? await load()
    }
}

```

---

## 结构化并发详解

结构化并发保证并发代码的单一入口和出口，避免回调地狱。

### Task Group

动态添加并发子任务：

```swift
await withTaskGroup(of: Int.self) { group in
  for i in 0..<3 {
    group.addTask {
      await work(i)
    }
  }

  for await result in group {
    print("Get result: \\(result)")
  }
}

```

### Async let

简化结构化并发：

```swift
async let v0 = work(0)
async let v1 = work(1)
async let v2 = work(2)

let result = await v0 + v1 + v2

```

### 对比

- `async let` 简洁，适合固定任务数。
- `withTaskGroup` 支持动态任务添加，更灵活适合复杂场景。

---

## 协作式任务取消

调用 `task.cancel()` 标记任务取消，但任务不会自动停止，需显式检查取消状态处理。

```swift
func work() async throws -> String {
  for c in "Hello" {
    try Task.checkCancellation()
    // 其他逻辑
  }
}

```

标准库API支持取消，例如 `Task.sleep` 在取消时抛出 `CancellationError`。

---

## 并发线程模型

Swift异步采用协作式线程池，执行环境抽象为轻量续体，任务分配给线程池中空闲线程，线程之间可切换，除非由 `MainActor` 限制。

异步调用示意：

1. `Task.init` 立即返回，任务体提交给调度队列。
2. 空闲线程从调度队列取任务，执行异步函数。
3. 遇到 `await` 时，任务挂起，线程释放执行其他任务。
4. 任务恢复时可能切换到不同线程继续执行。

![并发线程模型示意](http://zhiying.space/assets/img/post/swift-async/cooperative-1.png)

---