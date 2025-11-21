---
title: 文森的科技小站
description: "这是一个基于Hugo的主题Congo示例。"
---

{{< lead >}}
基于Tailwindcss的强大且轻量Hugo-Congo主题而构建的科技小站！
{{< /lead >}}

<div class="flex px-4 py-2 mb-8 text-base rounded-md bg-primary-100 dark:bg-primary-900">
  <span class="flex items-center pe-3 text-primary-400">
    {{< icon "triangle-exclamation" >}}
  </span>
  <span class="flex items-center justify-between grow dark:text-neutral-300">
    <span class="prose dark:prose-invert">布局：<code id="layout">page</code> </span>
    <button
      id="switch-layout-button"
      class="px-4 !text-neutral !no-underline rounded-md bg-primary-600 hover:!bg-primary-500 dark:bg-primary-800 dark:hover:!bg-primary-700"
    >
      切换布局 &orarr;
    </button>
  </span>
</div>

{{< figure src="festivities.svg" class="m-auto mt-6 max-w-prose" >}}
