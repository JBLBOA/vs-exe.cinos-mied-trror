function onCreate()
    makeLuaSprite("paintXp", "paintXp", -900, -700)
    scaleObject("paintXp", 4.0, 4.5)
    setProperty('paintXp.antialiasing', false)
    addLuaSprite("paintXp")
end

function onUpdate()
    triggerEvent("Camera Follow Pos", 100, 100)
end