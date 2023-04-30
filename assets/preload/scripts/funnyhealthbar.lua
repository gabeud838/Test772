
function onCreatePost()
    gradientBar()
end
function onEvent(n)
    if n == 'Change Character' then
        gradientBar()
    end
end
function onUpdatePost()
    if getProperty('health') > 1.4 then 
        setProperty('iconP2.x',300)
    else
        setProperty('iconP2.x',getProperty('iconP2.x') - 100)
    end
    if getProperty('health') < 0.7 then 
        setProperty('iconP1.x',800)
    else
        setProperty('iconP1.x',getProperty('iconP1.x') + 100)
    end
end
function gradientBar()
    runHaxeCode([[
        game.healthBar.createGradientBar(
             [0xFF]]..rgbToHex(getProperty('boyfriend.healthColorArray'))..[[, 0xFF]]..rgbToHex(getProperty('dad.healthColorArray'))..[[]
            ,[0xFF]]..rgbToHex(getProperty('boyfriend.healthColorArray'))..[[, 0xFF]]..rgbToHex(getProperty('dad.healthColorArray'))..[[]
        );
    ]])
end
function rgbToHex(array)
	return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end