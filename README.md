# edgeTXLEDS
A collection of RGBLed Lua Scripts for EdgeTX

## RSSI Lua
- Uses the LEDs to show RSSI (1RSS and/or 2RSS)
- Best on LED Rings, but if you only have non-diversity receivers, it will look better on the Customizable Switches

### LQ Lua
- Uses the LEDs to show LQ Level
- fullLQ.lua is best used for the Customizable Switches
- halvedLQ.lua is the same as fullLQ, but it will use 2 segments. Great for LED Rings.

## Compatible Radios (with RGB LED Special Function):
- Radiomaster GX12 (tested)
- Radiomaster TX15 (tested)
- Radiomaster TX16S MK3 (tested)
- HelloRadio V16/R (tested)
- HelloRadio V14 (tested)
- FlySky FS-ST16
- FlySky PA01 (tested)
- Jumper T15 Pro (tested)

These scripts are inspired by [btastic](https://github.com/btastic/rgb-throttle-edgetx.git)

Note: you will need the ledfinder.lua from the aforementioned repository if you want to make sure your LED strings are correct.