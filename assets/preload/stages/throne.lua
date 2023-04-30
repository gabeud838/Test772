dadZoom = 0
bfZoom = 0
ogZoom = 0
function onCreate()
    dadZoom = getProperty('defaultCamZoom')
    bfZoom = getProperty('defaultCamZoom')

	ogZoom = 0.6

	-- background shit

	makeLuaSprite('throneroom', 'backgrounds/throne/throneroom', -600, -300);
	setScrollFactor('throneroom',1, 1);

	addLuaSprite('throneroom', false);

    makeLuaSprite('light', 'backgrounds/throne/light', -60, -330);
	setScrollFactor('light',1, 1);
    setBlendMode('light', 'add')
    screenCenter('light', 'y')

	addLuaSprite('light', true);

	setPropertyFromClass('GameOverSubstate', 'characterName', 'frisk');

	--SOUNDS
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameoverut'); --file goes inside sounds/ folder
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --file goes inside music/ folder
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --file goes inside music/ folder
end

function onCreatePost()
	dadZoom = 0.6
end

function onUpdate()
    if mustHitSection then
        setProperty('defaultCamZoom', bfZoom)
    else
        setProperty('defaultCamZoom', dadZoom)
    end
end

function onStepHit()

	if curStep == 1392 then
		dadZoom = 0.65
	end

	if curStep == 1394 then
		dadZoom = 0.7
	end

	if curStep == 1395 then
		dadZoom = 0.75
	end

	if curStep == 1396 then
		dadZoom = 0.8
	end

	if curStep == 1398 then
		dadZoom = 0.825
	end

	if curStep == 1402 then
		dadZoom = 0.65
	end

	if curStep == 1406 then
		dadZoom = 0.45
	end

	if curStep == 1408 then
		dadZoom = ogZoom
	end
end