-- ** 自动关闭应用程序 **
function killForce(app, checkDelay)
    app:kill9()
    hs.timer.doAfter(checkDelay or 1, function()
        if app:isRunning() then
            print('~~~ ' .. app:name() .. ' kill9 again')
            app:kill9()
        end
    end)
end

function watchClose(name, forceKill)
    local wf = hs.window.filter.new(false):setAppFilter(name, { currentSpace = nil })
    wf:subscribe(hs.window.filter.windowDestroyed, function(win, appName)
        print(name .. ': ' .. tostring(#wf:getWindows()))
        if #wf:getWindows() == 0 then
            local app = win:application()
            print(name.."XXXXXXXXXXXXX")
            if app ~= nil then
                print('~~~ ' .. appName .. ': kill')
                if forceKill then killForce(app) else app:kill() end
            end
        end
    end, true)
end

-- runningApps = hs.application.runningApplications()

-- for _, app in ipairs(runningApps) do
--     print(app:name())
-- end
watchClose('预览')
watchClose('UPDF')
watchClose('Safari')
watchClose('Reeder')
watchClose('Google Chrome')
watchClose('Sublime Text')
watchClose('终端')
watchClose('iTerm')
watchClose('文本编辑')
watchClose('Code')
watchClose('活动监视器')
watchClose('Telegram')
watchClose('邮件')
watchClose('信息')
watchClose('IINA')
watchClose('WPS Office')
watchClose('Microsoft Excel', true)
watchClose('Microsoft Word', true)
watchClose('Microsoft PowerPoint', true)
