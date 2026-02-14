-- 引入Hammerspoon弹出表单对话框所需的模块
hs.application.enableSpotlightForNameSearches(true)
local alert = require("hs.alert")



-- 创建一个函数，用于弹出表格并获取用户输入标题和标签
function createBlogEntry()
    local button1, title = hs.dialog.textPrompt("博客信息", "标题:", "", "确定", "取消")
    if button1 == "确定" then
        local button2, tags = hs.dialog.textPrompt("博客信息", "标签（用减号-分隔）:", "", "确定", "取消")
        if button2 == "确定" then
            local button3, coverUrl = hs.dialog.textPrompt("博客信息", "封面图片链接:", "", "确定", "取消")
            if button3 == "确定" then
                generateMarkdown(title, tags, coverUrl)
            end
        end
    end
end

-- 创建一个函数，用于生成Markdown格式的文本
function generateMarkdown(title, tags,coverUrl)
    local tagLines = ""
    for tag in string.gmatch(tags, "[^-%s]+") do
        tagLines = tagLines .. "- " .. tag .. "\n"
    end

    hs.alert(tagLines)
    local blogData = [[
---
author: pigstar
cover:
  alt: cover
  square: COVER_URL
  url: COVER_URL
description: ''
keywords: TAGS
layout: ../../layouts/MarkdownPost.astro
meta:
- content: pigstar
  name: author
- content: TAGS
  name: keywords
pubDate: CURRENT_TIME
tags: 
TAGSLINE
theme: light
title: TITLE
---

]]
    
    -- 获取当前时间
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    -- 替换标题、标签和当前时间
    blogData = blogData:gsub("CURRENT_TIME", currentTime)
    blogData = blogData:gsub("TITLE", title)
    blogData = blogData:gsub("TAGSLINE", tagLines)
    blogData = blogData:gsub("TAGS", tags)
    blogData = blogData:gsub("COVER_URL", coverUrl)
    
    -- 将Markdown数据复制到剪贴板
    hs.pasteboard.setContents(blogData)
    
    -- 提示用户Markdown数据已复制到剪贴板
    hs.alert("Markdown数据已生成并复制到剪贴板")
end



