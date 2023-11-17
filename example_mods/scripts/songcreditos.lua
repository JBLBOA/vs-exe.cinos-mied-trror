function onCreate()
    makeLuaSprite("creditos", "creditos", 1000, 1000)
    setObjectCamera("creditos", 'other')
    addLuaSprite("creditos")

    makeLuaSprite("mousecredits", "mousecredits", 1000, 1000)
    setObjectCamera("mousecredits", 'other')
    addLuaSprite("mousecredits")
end

function onSongStart()
    if songName == "cinosrealnofake" then
        Credits("BENJA", "MAU/DORE", 450, 170)
    elseif songName == "Recolors" then
        Credits("BENJA", "MAU/DORE", 450, 170)  
    end
end

function onUpdate()
    if songName == "Recolors" then
        if curStep == 1567 then
            Credits("ROBERTO", "MAU/DORE", 450, 170)  
        end
    end
end

function Credits(curCharter, curMusic, x, y)

    setProperty("creditos.x", 1000)
    setProperty("creditos.y", 1000)

    setProperty("mousecredits.x", 1000)
    setProperty("mousecredits.y", 1000)

    makeLuaText("charter", "chart: "..curCharter, 0, 1000, 1000)
    setTextSize("charter", 25)
    setObjectCamera("charter", 'other')
    addLuaText("charter")

    makeLuaText("musico", "music: "..curMusic, 0, 1000, 1000)
    setTextSize("musico", 25)
    setObjectCamera("musico", 'other')
    addLuaText("musico")

    doTweenX("creditosX", "creditos", x, 1.5, "circInOut")
    doTweenY("creditosY", "creditos", y, 1.5, "circInOut")

    doTweenX("mousecreditsX", "mousecredits", x, 1.5, "circInOut")
    doTweenY("mousecreditsY", "mousecredits", y, 1.5, "circInOut")

    doTweenX("charterTXTX", "charter", x + 20, 1.5, "circInOut")
    doTweenY("charterTXTY", "charter", y + 100 - 70 + 30, 1.5, "circInOut")

    doTweenX("musicoTXTX", "musico", x + 20, 1.5, "circInOut")
    doTweenY("musicoTXTY", "musico", y + 100 - 70 + 55, 1.5, "circInOut")

    runTimer("irse", 2.5)
end

function onTimerCompleted(t) 
    if t == "irse" then
        doTweenX("creditosX3", "creditos", -100, 1.5, "circInOut")
        doTweenY("creditosY3", "creditos", 1000, 1.5, "circInOut")

        doTweenX("mousecreditsX4", "mousecredits", -100, 1.5, "circInOut")
        doTweenY("mousecreditsY4", "mousecredits", 1000, 1.5, "circInOut")
        
        doTweenX("charterTXTX4", "charter", -100, 1.5, "circInOut")
        doTweenY("charterTXTY4", "charter", 1000, 1.5, "circInOut")
        
        doTweenX("musicoTXTX4", "musico", -100, 1.5, "circInOut")
        doTweenY("musicoTXTY4", "musico", 1000, 1.5, "circInOut")
    end
end