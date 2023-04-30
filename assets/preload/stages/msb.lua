dadZoom = 0
bfZoom = 0
switchplaces = false

local bfXPos
local charaXPos

function onCreate()   
	addCharacterToList('bfre-flip')
	addCharacterToList('chara-flip')

	dadZoom = getProperty('defaultCamZoom')
    bfZoom = getProperty('defaultCamZoom')
	-- background shit

	makeLuaSprite('999', 'backgrounds/msb/999', -600, -300);
	setScrollFactor('999',1, 1);
	screenCenter("999")

	addLuaSprite('999', false);

	makeAnimatedLuaSprite('1left', 'backgrounds/msb/1left', 90, 400);
	addAnimationByPrefix('1left', '1left', '1left', 24, false);
    playAnim('1left', '1left')
	screenCenter("1left")
	setProperty('1left.y', getProperty('1left.y')- 150)

	addLuaSprite('1left', false);

    makeLuaSprite('overlay', 'backgrounds/msb/overlay', -60, -330);
	setScrollFactor('overlay',1, 1);
    setBlendMode('overlay', 'add')
    screenCenter('overlay')

	addLuaSprite('overlay', true);

	makeAnimatedLuaSprite('jumpscare', 'backgrounds/msb/jumpscare', -60, -330);
	addAnimationByPrefix('jumpscare', 'jumpscare', 'jumpscare', 24, false);
	playAnim('jumpscare','jumpscare')
	setScrollFactor('jumpscare',1, 1);
	setObjectCamera('jumpscare', 'other')
    screenCenter('jumpscare')
	setProperty('jumpscare.y', getProperty("jumpscare.y") - 4)
	setProperty('jumpscare.visible', false)
	

	makeLuaSprite('blackscreen', 'backgrounds/msb/blackscreen')
    setObjectCamera('blackscreen', 'other')
    screenCenter('blackscreen')
    setProperty('blackscreen.visible', false)
    addLuaSprite('blackscreen', true)

	addLuaSprite('jumpscare', true);

	setPropertyFromClass('GameOverSubstate', 'characterName', 'bfre');

	--SOUNDS

	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --file goes inside music/ folder
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --file goes inside music/ folder
end

function onCreatePost()
	setObjectOrder('boyfriendGroup', getObjectOrder('dadGroup') - 1)

	bfXPos = getProperty("boyfriend.x")
	charaXPos = getProperty("dad.x")
end

function onUpdatePost()
	playAnim('1left', '1left')
end

function onUpdate()
	if mustHitSection then
		setProperty('defaultCamZoom', bfZoom)
    else
		setProperty('defaultCamZoom', dadZoom)
	end
end

function onBeatHit()

	if curBeat == 232 or curBeat == 251 or curBeat == 255 or curBeat == 301 or curBeat == 548 or curBeat == 586 then
		triggerEvent('Play Animation', 'attack', 'dad')
	end

	if curBeat == 306 then
		setProperty('showRating', false);
		setProperty('showComboNum', false);
		dadZoom = 1.25
		setPropertyFromClass('flixel.FlxG','save.data.setFollowBool', false)
		triggerEvent('Camera Follow Pos',getProperty("dad.x") + 250, getProperty("dad.y") + 100)
	end

	if curBeat == 328 then
		setProperty('showRating', true);
		setProperty('showComboNum', true);
		setPropertyFromClass('flixel.FlxG','save.data.setFollowBool', true)
		triggerEvent('Camera Follow Pos')
		dadZoom = 0.75
	end

	if curBeat == 572 then
		setProperty('showRating', false);
		setProperty('showComboNum', false);
		dadZoom = 1.25
		setPropertyFromClass('flixel.FlxG','save.data.setFollowBool', false)
		triggerEvent('Camera Follow Pos',getProperty("dad.x") + 250, getProperty("dad.y") + 100)
	end

	if curBeat == 585 then
		setProperty('showRating', true);
		setProperty('showComboNum', true);
	end

	if curBeat == 586 then
		setPropertyFromClass('flixel.FlxG','save.data.setFollowBool', true)
		triggerEvent('Camera Follow Pos') 
	end

	if curBeat == 588 then
		dadZoom = 0.75
	end

	if curBeat == 580 then
		switchplaces = true
		setPropertyFromClass('GameOverSubstate', 'characterName', 'bfre-flip');
		triggerEvent('Alt Idle Animation', 'Dad', '-stare')
		playAnim('dad', 'idle-stare')
		setProperty('boyfriend.x', charaXPos)
		setProperty('dad.x', bfXPos)
		triggerEvent('Camera Follow Pos',getProperty("dad.x") + 210, getProperty("dad.y") + 100) 

		setPropertyFromGroup('playerStrums', 0, 'x', defaultOpponentStrumX0)
		
		setPropertyFromGroup('playerStrums', 1, 'x', defaultOpponentStrumX1)

		setPropertyFromGroup('playerStrums', 2, 'x', defaultOpponentStrumX2)

		setPropertyFromGroup('playerStrums', 3, 'x', defaultOpponentStrumX3)

		setPropertyFromGroup('playerStrums', 4, 'x', defaultOpponentStrumX4)

		setPropertyFromGroup('opponentStrums', 0, 'x', defaultPlayerStrumX0 + 0)

		setPropertyFromGroup('opponentStrums', 1, 'x', defaultPlayerStrumX1 + 0)

		setPropertyFromGroup('opponentStrums', 2, 'x', defaultPlayerStrumX2 + 0)

		setPropertyFromGroup('opponentStrums', 3, 'x', defaultPlayerStrumX3 + 0)

		setPropertyFromGroup('opponentStrums', 4, 'x', defaultPlayerStrumX4 + 0)

	end

	if curBeat == 636 then
		setProperty('boyfriend.x', bfXPos)
		setProperty('dad.x', charaXPos)
		setPropertyFromClass('GameOverSubstate', 'characterName', 'bfre');
	end

	if curBeat == 658 then
		setProperty('blackscreen.visible', true)
	end

	if curBeat == 662 then
		setProperty('jumpscare.visible', true)
		playAnim('jumpscare','jumpscare')
	end

	if curBeat == 668 then
		setProperty('jumpscare.visible', true)
		doTweenAlpha('jumpscaretween', 'jumpscare', 0, 1, 'quadIn')
	end

end

function onUpdatePost()


end