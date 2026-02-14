
-- 函数用于显示输入框
function translateInputField()
    hs.eventtap.keyStroke("cmd", "a")
    hs.eventtap.keyStroke("option", "d")
    -- hs.pasteboard.setContents(blogData)
    -- hs.alert(hs.pasteboard.getContents())
    hs.timer.doAfter(1, function()
        -- 模拟按下并释放Escape键
        hs.eventtap.keyStroke({}, "escape")
        hs.eventtap.keyStroke("cmd", "v")
    end)
end

-- 设置快捷键触发输入框
hs.hotkey.bind(hyperHotkey, "t", translateInputField)