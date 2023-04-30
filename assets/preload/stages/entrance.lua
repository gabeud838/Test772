--How makeLuaSprite works:
--makeLuaSprite(<SPRITE VARIABLE>, <SPRITE IMAGE FILE NAME>, <X>, <Y>);
--"Sprite Variable" is how you refer to the sprite you just spawned in other methods like "setScrollFactor" and "scaleObject" for example

--so for example, i made the sprites "stagelight_left" and "stagelight_right", i can use "scaleObject('stagelight_left', 1.1, 1.1)"
--to adjust the scale of specifically the one stage light on left instead of both of them

dialog = "tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt"
curAnim = "normal"
floweyconfused = false
dadZoom = 0
bfZoom = 0
curSound = 'floweytalk'

local TM = require([[mods\VSCHARA\module\TweenModule]])
local ascendtween
local screentween
local dadpos = {}
local bfpos = {}

function hideDialogue(v)
    v = not v
    setProperty("dialogueBox.visible", v)
    setProperty("flowey.visible", v)
    setProperty("starThing.visible", v)
    setProperty("dialogueText.visible", v)
end

function onCreate()
    dadZoom = getProperty('defaultCamZoom')
    bfZoom = getProperty('defaultCamZoom')

    floweyconfused = false
    precacheSound('floweytalk')
    precacheSound('floweyeviltalk')
   -- precacheSound('music/utmenu')

    --luaDebugMode = true

	makeLuaSprite('entrance', 'backgrounds/entrance/entrance', -600, -300);
	setScrollFactor('entrance',1, 1);

	addLuaSprite('entrance', false);

    makeLuaSprite('light', 'backgrounds/entrance/light', -750, -330);
	setScrollFactor('light',1, 1);
    setBlendMode('light', 'add')

	addLuaSprite('light', true);

    makeLuaSprite('rocks', 'backgrounds/entrance/rocks', -700, -300);
	setScrollFactor('rocks',0.9,0.9);

	addLuaSprite('rocks', false);

    makeLuaSprite('blackscreen', 'backgrounds/entrance/blackscreen')
    setObjectCamera('blackscreen', 'other')
    screenCenter('blackscreen')
    setProperty('blackscreen.alpha', 0)
    addLuaSprite('blackscreen', true)

    makeLuaSprite('dialogueBox', 'dialogue/uttextbox')
	setScrollFactor('dialogueBox', 1, 1);
    setObjectCamera('dialogueBox', 'other')
    screenCenter('dialogueBox')
    setProperty('dialogueBox.y', getProperty('dialogueBox.y') + 200)
    addLuaSprite('dialogueBox', true);

	makeAnimatedLuaSprite('flowey', 'dialogue/dialogue_flowey', 90, 400);
	addAnimationByPrefix('flowey', 'normal', 'floweynormal0', 24, false);
    addAnimationByPrefix('flowey', 'normal_talk', 'floweynormal_talk0', 24, false);
    addAnimationByPrefix('flowey', 'smug', 'floweysmug0', 24, false);
    addAnimationByPrefix('flowey', 'smug_talk', 'floweysmug_talk0', 24, false);
    addAnimationByPrefix('flowey', 'annoyed', 'floweyannoyed0', 24, false);
    addAnimationByPrefix('flowey', 'annoyed_talk', 'floweyannoyed_talk0', 24, false);
    addAnimationByPrefix('flowey', 'evil', 'floweyevil0', 24, false);
    addAnimationByPrefix('flowey', 'evil_talk', 'floweyevil_talk0', 24, false);
    playAnim('flowey', 'normal')
    setObjectCamera('flowey', 'other')
    scaleObject('flowey', 0.8, 0.8)
    updateHitbox('flowey')
    setProperty('flowey.x', 130)
    setProperty('flowey.y', 457)
	addLuaSprite('flowey', true);

    makeLuaText('starThing', '*', screenWidth * 0.6, 350, 500)
    setTextFont('starThing', 'determination.ttf');
    setTextSize('starThing', 44);
    setTextBorder('starThing', 0, 0);
    setTextAlignment('starThing', 'left');
    setObjectCamera('starThing', 'other')
    addLuaText('starThing')

    makeLuaText('dialogueText', '', screenWidth * 0.6, 400, 500)
    setTextFont('dialogueText', 'determination.ttf');
    setTextSize('dialogueText', 44);
    setTextBorder('dialogueText', 0, 0);
    setTextAlignment('dialogueText', 'left');
    setObjectCamera('dialogueText', 'other')
    addLuaText('dialogueText')

	setPropertyFromClass('GameOverSubstate', 'characterName', 'frisk');

	--SOUNDS
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameoverut'); --file goes inside sounds/ folder
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --file goes inside music/ folder
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --file goes inside music/ folder
    
end

function onCreatePost()
    dadpos = {x = getProperty('dad.x'),y = getProperty('dad.y')}
    bfpos = {x = getProperty('boyfriend.x'),y = getProperty('boyfriend.y')}
    ascendtween = TM.Create('ascend',{500,-1200},2.5,{EaseDirection = 'inoutQuad'})

    hideDialogue(true)
end

function dialoguelol(text, anim, evil)
    curAnim = anim
    dialog = text
    if evil == true then
        runTimer('add dialogue letter evil', 0.04, string.len(dialog));
    else
        runTimer('add dialogue letter', 0.04, string.len(dialog));
    end 
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
    if tag == 'add dialogue letter' then
        setTextString('dialogueText', string.sub(dialog, 0, (loops - loopsLeft)));
        playSound('floweytalk', 0.8);
        playAnim('flowey', curAnim..'_talk')
        if loopsLeft == 0 then
            playAnim('flowey', curAnim)
            --debugPrint('Text finished!')
            --dialogueEnded = true;
        end
    elseif tag == 'add dialogue letter evil' then
        setTextString('dialogueText', string.sub(dialog, 0, (loops - loopsLeft)));
        playSound('floweyeviltalk', 0.8);
        playAnim('flowey', curAnim..'_talk')
        if loopsLeft == 0 then
            playAnim('flowey', curAnim)
            --debugPrint('Text finished!')
            --dialogueEnded = true;
        end
    end
end

function onPause()
   -- playMusic('utmenu', 1) 
end

function onUpdate()
    if mustHitSection then
        setProperty('defaultCamZoom', bfZoom)
    else
        setProperty('defaultCamZoom', dadZoom)
    end
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think

    if counter == 4 then
        hideDialogue(false)
        dialoguelol("See those arrows? That's your rhythm, which is essential for increasing your LV.", "normal", false)
    end
end

function onStepHit()

    if curStep == 31 then
        dialoguelol("LV stands for LOVE and can be strengthened by the LOVE of others!", "normal", false)
    end

    if curStep == 56 then
        dialoguelol("Sing along with me!", "normal", false)
    end

    if curStep == 66 then
        hideDialogue(true)
    end

    if curStep == 1235 then
        triggerEvent('Play Animation', 'fireballed', 'dad')
    end

    if curStep == 230 then
        setTextString('dialogueText', "");
        playAnim('flowey', 'smug')
    end

    if curStep == 231 then
        hideDialogue(false) 
        dialoguelol("Hey buddy, you're not singing along with me.", "smug", false)
    end

    if curStep == 248 then
        dialoguelol("Let's try again, okay?", "smug", false)
    end

    if curStep == 262 then
        hideDialogue(true)
    end

    if curStep == 296 then
        setTextString('dialogueText', "");
        playAnim('flowey', 'annoyed')
    end

    if curStep == 300 then
        dialoguelol("You're supposed to sing along, not the other way around!", "annoyed", false)
        hideDialogue(false) 
    end
    
    if curStep == 325 then
        hideDialogue(true) 
        setTextString('dialogueText', "");
    end

    if curStep == 368 then
        doTweenAlpha('blackscreene', 'blackscreen', 1, 1.5, 'linear')
    end

    if curStep == 395 then
        playAnim('flowey', 'evil')
    end

    if curStep == 396 then
        hideDialogue(false) 
        curSound = "floweyeviltalk"
        dialoguelol("You know what's going on here, don't you?", "evil", true)
    end

    if curStep == 416 then
        dialoguelol("You just wanted to see me suffer.", "evil", true)
    end

    if curStep == 438 then
        hideDialogue(true)
    end

    if curStep == 440 then
        doTweenAlpha('blackscreene', 'blackscreen', 0, 1, 'linear')
    end

    if curStep == 1240 then
        ascendtween:Play()
    end
end

function onBeatHit()
    if curBeat == 302 then
        floweyconfused = true
        setProperty("health", 2)
        playAnim('dad', 'confused')
        triggerEvent('Alt Idle Animation', 'dad', '-alt')
    end
    if curBeat == 306 then
        dadZoom = 1.1
    end

end

function onUpdatePost(elapsed)
    TM.Update(elapsed)
    if curStep >= 1238 and curStep <= 1360 then
        setPropertyFromClass('flixel.FlxG','save.data.setFollowBool', false)
        triggerEvent('Camera Follow Pos',dadpos.x + 200, ascendtween.position)
    end
    if curBeat == 319 then
        setPropertyFromClass('flixel.FlxG','save.data.setFollowBool', true)
    end
end