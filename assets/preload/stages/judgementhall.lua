function onCreate()
	-- background shit

	makeLuaSprite('judgementhall', 'backgrounds/judgementhall/judgementhall', -600, -300);
	setScrollFactor('judgementhall',1, 1);

	addLuaSprite('judgementhall', false);

    makeLuaSprite('light', 'backgrounds/judgementhall/light', -400, 0);
	setScrollFactor('light',1, 1);
    setBlendMode('light', 'add')

	addLuaSprite('light', true);

	setPropertyFromClass('GameOverSubstate', 'characterName', 'bfre');

	makeLuaSprite('blackscreen', 'backgrounds/entrance/blackscreen')
    setObjectCamera('blackscreen', 'other')
    screenCenter('blackscreen')
    setProperty('blackscreen.alpha', 1)
   -- addLuaSprite('blackscreen', true)

	--SOUNDS
	--setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameoverut'); --file goes inside sounds/ folder
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --file goes inside music/ folder
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --file goes inside music/ folder
end
