-- app:allWindows() 不够准确，例如对 Chrome
function getWinList(name)
    return hs.window.filter.new(false):setAppFilter(name, { currentSpace = true }):getWindows()
end

function launchOrNextWindow(name, showName)
    local findName = name
    local appName = hs.application.frontmostApplication():name()
     -- 模拟释放 Option 键, 不释放sublime会进入safe mode
     hs.eventtap.event.newKeyEvent(nil, 58, false):post()
    if name == appName or showName == appName then
        local wlist = getWinList(appName)
        local wcount = #wlist
        if wcount > 1 then
            hs.eventtap.keyStroke({'cmd'}, '`')
        elseif wcount == 1 then
            local win = wlist[1]
            if win:isVisible() then win:application():hide() end
        else
            hs.application.launchOrFocus(name)
        end
        return
        
    end
    hs.application.launchOrFocus(name)
end



hs.fnutils.each(applist, function(entry)
    hs.hotkey.bind(launcherHotkey, entry.shortcut, entry.appname, function()
        launchOrNextWindow(entry.appname, entry.showName)
    end)
end)

