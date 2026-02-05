-- RSSI LED Ring script
-- This script is based on the throttle indicator on the LED bar
-- by btastic_fpv

local LED_GROUP1 = {10,11,12,13,14,15,16,17,18,19}
local LED_GROUP2 = {0,1,2,3,4,5,6,7,8,9}

local function init()
end

local function fillLeft(ledValue)
	
	local numLedsTotal = #LED_GROUP1
	local segmentSize = 255 / numLedsTotal
	
  -- Calculate how many LEDs should be lit
  local numLeds = math.floor(ledValue / segmentSize) + 1
  numLeds = math.max(1, math.min(numLedsTotal, numLeds))
  
  -- Calculate brightness for the highest LED
  local segment = (ledValue % segmentSize) / segmentSize
  local brightness = math.floor(5 + (segment * 250))
  
  -- Special case: all LEDs full brightness
  if ledValue == 255 then
    numLeds = numLedsTotal
    brightness = 255
  end

	-- LEDs are blue
  for i = 1, numLedsTotal, 1 do
    local ledIndex = i - 1
    if ledIndex < numLeds - 1 then
      setRGBLedColor(LED_GROUP1[i], 0, 0, 255)
    elseif ledIndex == numLeds - 1 then
      setRGBLedColor(LED_GROUP1[i], 0, 0, brightness)
    else
      setRGBLedColor(LED_GROUP1[i], 0, 0, 0)
    end
  end 

end

local function fillRight(ledValue)
	
	local numLedsTotal = #LED_GROUP2
	local segmentSize = 255 / numLedsTotal
	
  -- Calculate how many LEDs should be lit
  local numLeds = math.floor(ledValue / segmentSize) + 1
  numLeds = math.max(1, math.min(numLedsTotal, numLeds))
  
  -- Calculate brightness for the highest LED
  local segment = (ledValue % segmentSize) / segmentSize
  local brightness = math.floor(5 + (segment * 250))
  
  -- Special case: at 100% LQ, all LEDs full brightness
  if ledValue == 255 then
    numLeds = numLedsTotal
    brightness = 255
  end
	
	-- LEDs are blue
  for i = 1, numLedsTotal, 1 do
    local ledIndex = i - 1
    if ledIndex < numLeds - 1 then
      setRGBLedColor(LED_GROUP2[i], 0, 0, 255)
    elseif ledIndex == numLeds - 1 then
      setRGBLedColor(LED_GROUP2[i], 0, 0, brightness)
    else
      setRGBLedColor(LED_GROUP2[i], 0, 0, 0)
    end
  end 

end

local function calcLEDValue(source)

	-- map -117dBm ... -3dBm into 0...255
  local ledValue = math.floor((source + 117) * 255 / 114)
	ledValue = math.max(0, math.min(255, ledValue))
	
	return ledValue
end

local function run()
  -- Get RSSI Telem values
  local elrs1RSS = getValue("1RSS")
	local elrs2RSS = getValue("2RSS")
	
	local ledValue1 = calcLEDValue(elrs1RSS)
	local ledValue2 = calcLEDValue(elrs2RSS)
  
  if not elrs1RSS == nil or elrs1RSS == 0 then
		fillLeft(0)
	else
		fillLeft(ledValue1)
	end
	if not elrs2RSS == nil or elrs2RSS == 0 then
		fillRight(0)
	else
		fillRight(ledValue2)
	end
  
  applyRGBLedColors()
end

local function background()
end

return { run=run, background=background, init=init }