-- RSSI LED Bar script
-- This script is based on the throttle indicator on the LED bar
-- by btastic_fpv

local LED_GROUP1 = {22,21,20}
local LED_GROUP2 = {23,24,25}
local LED_COUNT = 3

local function init()
end

local function fillNormal(ledValue)
  local numLedsTotal = LED_COUNT
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
     
  -- Light up group 2 LEDs progressively
  for i = 1, numLedsTotal, 1 do
    local ledIndex = i - 1
    if ledIndex < numLeds - 1 then
      setRGBLedColor(LED_GROUP1[i], 0, 255, 0)
      setRGBLedColor(LED_GROUP2[i], 0, 255, 0)
    elseif ledIndex == numLeds - 1 then
      setRGBLedColor(LED_GROUP1[i], 0, brightness, 0)
      setRGBLedColor(LED_GROUP2[i], 0, brightness, 0)
    else
      setRGBLedColor(LED_GROUP1[i], 0, 0, 0)
      setRGBLedColor(LED_GROUP2[i], 0, 0, 0)
    end
  end
  
  
end

local function run()
  -- Get LQ Telem value
  local lqPercent = getValue("RQly")
  
  -- map LQ values to brightness level 0..255
  local ledValue = math.floor(lqPercent * 255 / 100)
   
  -- Clamp value to ensure it stays within 0-255
  ledValue = math.max(0, math.min(255, ledValue))
  
  fillNormal(ledValue)
  
  applyRGBLedColors()
end

local function background()
end

return { run=run, background=background, init=init }