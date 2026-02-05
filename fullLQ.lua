-- LQ LED Bar script
-- This script is based on the throttle indicator on the LED bar
-- by btastic_fpv

local LED_START = 20    -- First LED in the bar
local LED_END = 25      -- Last LED in the bar
local INDICATOR_LED = -1  -- Separate indicator LED (set to -1 to disable)

local function init()
end

local function fillNormal(ledValue)
  -- Calculate total number of LEDs
  local numLedsTotal = LED_END - LED_START + 1
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
    
  -- Light up LEDs progressively
  for i = LED_START, LED_END, 1 do
    local ledIndex = i - LED_START
    if ledIndex < numLeds - 1 then
      setRGBLedColor(i, 0, 255, 0)
    elseif ledIndex == numLeds - 1 then
      setRGBLedColor(i, 0, brightness, 0)
    else
      setRGBLedColor(i, 0, 0, 0)
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
  
  -- Optional indicator LED
  if INDICATOR_LED >= 0 then
    setRGBLedColor(INDICATOR_LED, 50, 0, 0)
  end
  
  applyRGBLedColors()
end

local function background()
end

return { run=run, background=background, init=init }