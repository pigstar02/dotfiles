require "modules.reload"
require "config"
-- require "modules.window"
require "modules.launcher"
-- require "modules.input"
-- require "modules.defaultInput"
require "modules.bluetoothSleep"
require "modules.wifi"
require "modules.autoQuit"
require "modules.clock"
require "modules.textInput"
require "modules.AClock"
require "modules.NewBlog"
require "modules.translate"

local screenFrame = hs.screen.mainScreen():frame()
local func_list = {}
local desc_list = {}
local toggle_list = {}
local stopFunc_list = {}
-- 创建一个选项表
local choices = {}
-- 创建一个选择器
local chooser = hs.chooser.new(function(choice)
    if not choice then return end
    if stopFunc_list[choice["text"]] ~= nil then
        if toggle_list[choice["text"]] then
            toggle_list[choice["text"]] = false
            stopFunc_list[choice["text"]]()
        else
            toggle_list[choice["text"]] = true
            func_list[choice["text"]]()
        end
        return
    end
    func_list[choice["text"]]()
end)

-- 注册功能
function register_func(name, func, des, kStopFunc)
    func_list[name] = func
    if des ~= nil then
        desc_list[name] = des
    end
    table.insert(choices, {["text"] = name, ["subText"] = desc_list[name]})
    if kStopFunc then
        stopFunc_list[name] = kStopFunc
    end
    chooser:choices(choices)  -- 更新选择器的选项
end

-- 更新选择器内容
function update_choices(kName, kParam, Newdata)
    for _, v in ipairs(choices) do
        if v["text"] == kName then
            v[kParam] = Newdata
            chooser:choices(choices)  -- 更新选择器的选项
            return
        end
    end
end

--------------------------------下面是函数--------------------------------

-- 当前文件夹路径打开终端
function openTerminalInCurrentFolder()
    local script = [[
        tell application "Finder"
            set thePath to POSIX path of (insertion location as alias)
        end tell
        return thePath
    ]]
    local _, result = hs.osascript.applescript(script)
    local folderPath = result:gsub("^%s*(.-)%s*$", "%1")
    if folderPath ~= "" then
        hs.execute('open -a iTerm.app "' .. folderPath .. '"')
    end
end

-- 第一个参数 "displayIdle" 是要设置的选项，指定了控制显示器休眠的选项。
-- 第二个参数 true 表示启用这个选项，也就是让计算机保持唤醒状态。
-- 第三个参数 true 表示在设置这个选项后立即生效。
local function manageSleep()
    local hour = os.date("*t").hour
    if hour >= 6 and hour < 24 then
        hs.caffeinate.set("displayIdle", true, true)
        hs.alert.show("manageSleep called")

    else
        hs.caffeinate.set("displayIdle", false, true)
    end
end
-- hs.timer.doEvery(60 * 30, manageSleep)

-- 番茄钟功能
local pomodoroDuration = 25 * 60 -- 25分钟
local breakDuration = 5 * 60 -- 5分钟
local isPomodoro = true
local timerDisplay
local circleDisplay
local timer

local function updateTimerDisplay(remainingTime, isPomodoro)
    local minutes = math.floor(remainingTime / 60)
    local seconds = remainingTime % 60
    local timeText = string.format('%02d:%02d', minutes, seconds)
    local iconText = isPomodoro and '    🍅' or '    ☕'
    timerDisplay:setText(iconText .. '\n' .. timeText)
end

local function startPomodoro()
    update_choices("番茄钟", "subText", isPomodoro and "🍅正在工作" or "☕️正在休息")
    local remainingTime = pomodoroDuration
    if not isPomodoro then
        remainingTime = breakDuration
    end

    local centerX = screenFrame.x + (screenFrame.w / 2)
    local centerY = screenFrame.y + (screenFrame.h / 2)

    if timerDisplay then
        timerDisplay:delete()
    end

    if circleDisplay then
        circleDisplay:delete()
    end

    -- 绘制背景圆环
    circleDisplay = hs.drawing.arc(hs.geometry.rect(centerX - 40, centerY, 400, 400),150, 0, 0)
    circleDisplay:setFillColor({red=isPomodoro and 1 or 0, green=isPomodoro and 0 or 1, blue=0, alpha=0.2})
    circleDisplay:setStroke(false)
    circleDisplay:setLevel(hs.drawing.windowLevels.overlay)
    circleDisplay:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
    circleDisplay:show()

    timerDisplay = hs.drawing.text(hs.geometry.rect(centerX - 150, centerY - 100, 400, 200), '')
    timerDisplay:setTextSize(80)
    timerDisplay:setTextColor({red=1, green=1, blue=1, alpha=0.5}) -- 半透明白色
    timerDisplay:setLevel(hs.drawing.windowLevels.overlay)
    timerDisplay:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
    timerDisplay:show()

    timer = hs.timer.doEvery(1, function()
        if remainingTime > 0 then
            remainingTime = remainingTime - 1
            local totalDuration = isPomodoro and pomodoroDuration or breakDuration
            local progress = remainingTime / totalDuration
            
            -- 更新进度圆弧
            local endAngle = (360 * (1 - progress))
            circleDisplay:setArcAngles(0, endAngle)
            
            updateTimerDisplay(remainingTime, isPomodoro)
        else
            hs.alert.show(isPomodoro and 'Time for a break!' or 'Back to work!')
            isPomodoro = not isPomodoro
            timer:stop()
            startPomodoro()
        end
    end)
end
local stopPomodoro = function()
    update_choices("番茄钟", "subText", "番茄钟未开启")
    if timer then
        timer:stop()
    end
    if timerDisplay then
        timerDisplay:delete()
    end
    if circleDisplay then
        circleDisplay:delete()
    end
end



register_func("openTerminalInCurrentFolder", openTerminalInCurrentFolder, "打开当前文件夹终端")
register_func("blog元数据生成", createBlogEntry, "快捷生成博客元数据")
register_func("模拟输入", showInputPrompt, "输入文字")
register_func("番茄钟", startPomodoro, "番茄钟未开启", stopPomodoro)

-- 设置快捷键，按下 Hyper + Z 显示选择器
hs.hotkey.bind(hyperHotkey, "z", function()
    chooser:show()
end)
hs.hotkey.bind(menuHotkey, "m", function()
    chooser:show()
end)





