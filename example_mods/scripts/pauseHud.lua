function onCreate()
    makeLuaSprite("xpBar", "topbar", 0, 0)
    setObjectCamera("xpBar", "other")
    scaleObject("xpBar", 2.7, 1.5)
    screenCenter("xpBar", 'x')
   -- addLuaSprite("xpBar", false)

    makeLuaSprite("xpClose", "exit", 1200, 5)
    setObjectCamera("xpClose", "other")
    scaleObject("xpClose", 2.7, 1.5, true)
    --addLuaSprite("xpClose", false)

    makeLuaSprite("xpPause", "pause", 1100, 5)
    setObjectCamera("xpPause", "other")
    scaleObject("xpPause", 2.7, 1.5, true)
    --addLuaSprite("xpPause", false)
end

pauseOPTION = false

--function onUpdate()
    --if (getMouseX('camOther') > getProperty('xpClose.x') and getMouseX('camOther') < getProperty('xpClose.x') + getProperty('xpClose.width')) and (getMouseY('camOther') > getProperty('xpClose.y') and getMouseY('camOther') < getProperty('xpClose.y') + getProperty('xpClose.height') and mouseClicked('left')) then    
    --    endSong()
--
    --elseif (getMouseX('camOther') > getProperty('xpPause.x') and getMouseX('camOther') < getProperty('xpPause.x') + getProperty('xpPause.width')) and (getMouseY('camOther') > getProperty('xpPause.y') and getMouseY('camOther') < getProperty('xpPause.y') + getProperty('xpPause.height') and mouseClicked('left')) then   
    --    return Function_Stop;
    --end
--end