-- 导入CountDown Spoon
local CountDown = hs.loadSpoon("CountDown")
CountDown:init()
-- CountDown:startFor(25)
hs.hotkey.bind({"cmd", "alt"}, "P", function()
    spoon.CountDown:pauseOrResume()
end)



