--                  TWEEN MODULE BY RORUTOP                  --

function lerp(a,b,t) return a * (1-t) + b * t end
function limitToOne(min,max,t)
    return (t - min) / (max - min)
end
function cubicBezier(t, p0, p1, p2, p3)
	return (1 - t)^3*p0 + 3*(1 - t)^2*t*p1 + 3*(1 - t)*t^2*p2 + t^3*p3
end
function ValueToKey(t)
    local i={}
    for k,v in pairs(t) do 
        i[k] = k
    end
    return i
end
function FindValueByKey(tbl,key)
    for i,v in pairs(tbl) do
        if i == key then
            return v
        end
    end
    return nil
end
function getIndexFromValueById(tbl,specifyid,id)
    local letabel = {}
	for i,v in pairs(tbl) do
        table.insert(letabel,v)
	end
    for i,v in pairs(letabel) do
        if v[specifyid] == id then
			return i
		end
    end
	return nil
end
function isKeyinTbl(tbl)
    for i,v in pairs(tbl) do
        if type(i) == 'string' then
           return true
        end
    end
    return false
end

local valueLists = {['x'] = '.x' ,['y'] = '.y' ,['scalex'] = '.scale.x' ,['scaley'] = '.scale.y' ,['width'] = '.width' ,['height'] = '.height' ,['angle'] = '.angle' ,['alpha'] = '.alpha'}
local Ease = require([[mods\VSCHARA\module\Eases]])

local Tween = {}
Tween.CurrentTweens = {}
Tween.CurrentPlaying = {}
Tween.__index = Tween

local Signal = {}
Signal.Threads = {}
Signal.__index = Signal
function Signal.New(call)
    local self = {}
    self.Active = true
    self.Paused = false
    self.Elapsed = 0
    self.CallFunc = call
    function self:Pause()
        self.Paused = true
    end
    function self:Resume()
        self.Paused = false
    end
    function self:Disconnect()
        self.Active = false
    end
    table.insert(Signal.Threads,setmetatable(self,Signal))
    return setmetatable(self,Signal)
end

function Tween.Update(elapsed) -- cant use onUpdate cuz when using a script and require with it the onUpdate in module stops so put this shit in onUpdate or onUpdatePost with the elapsed parameter yeah idk
    for i,v in ipairs(Signal.Threads) do
        if v.Active and not v.Paused then
            v.CallFunc(elapsed)
        elseif not v.Paused then
            table.remove(Signal.Threads,getIndexFromValueById(Signal.Threads,'Active',false))
        end
    end
end

function Tween.Create(obj,position,duration,options)
    local lowercase = {{},{}}
    local self = {}
    if type(position) ~= 'table' then
        debugPrint('ERROR : Position must be a table.')
        return nil
    elseif isKeyinTbl(position) then
        for i,v in pairs(position) do
            lowercase[1][i:lower()] = v
        end
    end
    if type(options) ~= 'table' then
        debugPrint('WARNING : Options is not a table! Making it a default rn..')
        self.options = {easedirection = 'linear'}
    else
        for i,v in pairs(options) do
            lowercase[2][i:lower()] = v
        end
        self.options = lowercase[2]
    end
    self.obj = obj
    if not isKeyinTbl(position) then self.position = position[1] end
    self.pos = isKeyinTbl(position) and lowercase[1] or position
    -- POSITIONS: x , y , scalex , scaley , width , height , angle , alpha
    self.duration = duration
    -- OTHERS: EaseDirection , CallFunc
    table.insert(Tween.CurrentTweens,setmetatable(self,Tween))
    return setmetatable(self,Tween)
end

function Tween:Play()
    local obj = self.obj
    for i,v in pairs(Tween.CurrentPlaying) do
        if i:find(obj) and v == false then
            Tween.CurrentPlaying[i] = true
        end
    end

    local randomname = obj..math.random(10000000,99999999)
    Tween.CurrentPlaying[randomname] = false

    local currentOptions = self.options
    local easedir = ''
        local easefound = false
        for i,v in pairs(Ease) do
            if currentOptions.easedirection:lower() == i:lower() then
                easedir = i
                easefound = true
                break
            end
        end
        if not easefound then
            debugPrint('WARNING : Ease not found!!!!! Making it linear rn....')
            easedir = 'linear'
        end

    local currentDuration = self.duration
    local currentType = self.type
    local timer = 0
    if isKeyinTbl(self.pos) then
        local startValues = {}
        local currentValues = self.pos
        for i,v in pairs(self.pos) do
            startValues[i] = getProperty(obj..valueLists[i])
        end
        --local magnitude = {math.sqrt((self.pos.x or 0)^2 + (self.pos.y or 0)^2),math.sqrt(startValues.x^2 + startValues.y^2)}
        local lesignal
        lesignal = Signal.New(function(dt)
            if FindValueByKey(Tween.CurrentPlaying,randomname) == true then
                lesignal:Disconnect()
            end
            timer = timer + dt
            if timer >= currentDuration then
                timer = currentDuration
                if currentOptions.callfunc ~= nil then currentOptions.callfunc() end
                lesignal:Disconnect()
            end
            local ratio = Ease[easedir](timer,0,1,currentDuration)
            local destinated = {}
            for i,v in pairs(currentValues) do
                if type(v) ~= 'table' then
                    destinated[i] = lerp(startValues[i],v,ratio)
                else
                    destinated[i] = cubicBezier(ratio,startValues[i],v[1],v[2],v[3])
                end
            end
            for i,v in pairs(destinated) do
                if i == ValueToKey(valueLists)[i] then
                    setProperty(obj..valueLists[i],v)
                end
            end
        end)
    else
        local currentValues = self.pos
        local lesignal
        lesignal = Signal.New(function(dt)
            if FindValueByKey(Tween.CurrentPlaying,randomname) == true then
                lesignal:Disconnect()
            end
            timer = timer + dt
            if timer >= currentDuration then
                timer = currentDuration
                if currentOptions.callfunc ~= nil then currentOptions.callfunc() end
                lesignal:Disconnect()
            end
            local ratio = Ease[easedir](timer,0,1,currentDuration)
            if #currentValues >= 2 and #currentValues <= 3 then
                self.position = lerp(currentValues[1],currentValues[2],ratio)
            elseif #currentValues == 4 then
                self.position = cubicBezier(ratio,currentValues[1],currentValues[2],currentValues[3],currentValues[4])
            end
        end)
    end
end

function Tween:Stop()
    for i,v in pairs(Tween.CurrentPlaying) do
        if i:find(self.obj) and v == false then
            Tween.CurrentPlaying[i] = true
        end
    end
end

function Tween:Set(position,duration)
    local lowercase = {}
    if type(position) ~= 'table' then
        debugPrint('ERROR : Position must be a table.')
        return
    elseif isKeyinTbl(position) then
        for i,v in pairs(position) do
            lowercase[i:lower()] = v
        end
    end
    if not isKeyinTbl(position) then self.position = position[1] end
    self.pos = isKeyinTbl(position) and lowercase or position
    -- POSITIONS: x , y , scalex , scaley , width , height , angle , alpha
    self.duration = duration or self.duration
end

function Tween:SetOptions(options)
    local lowercase = {}
    if type(options) ~= 'table' then
        debugPrint('WARNING : Options is not a table! Making it a default rn..')
        self.options = {easedirection = 'linear'}
    else
        for i,v in pairs(options) do
            lowercase[i:lower()] = v
        end
        self.options = lowercase
    end
end

return Tween