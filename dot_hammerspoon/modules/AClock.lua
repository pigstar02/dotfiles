local AClock = hs.loadSpoon("AClock")

AClock:init()

hs.hotkey.bind({"cmd", "alt"}, "T", function()
    AClock:toggleShow()
end)