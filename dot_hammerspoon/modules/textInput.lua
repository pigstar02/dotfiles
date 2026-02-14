local userInputText = -1

-- 函数用于显示输入框
function showInputPrompt()
    -- 只有在全局变量为-1时才显示输入框
    if userInputText == -1 then
        -- 创建模态对话框
        local result, text = hs.dialog.textPrompt("输入框", "请输入要输入的文字:", "", "确定", "取消")
        if result == "确定" then
            userInputText = text
        end
    else
        -- 模拟键盘输入用户输入的文字
        hs.eventtap.keyStrokes(userInputText)
        -- 设置定时器将全局变量重置为-1
        hs.timer.doAfter(0.1, function() userInputText = -1 end)
    end
end

-- 设置快捷键触发输入框
-- hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "P", showInputPrompt)