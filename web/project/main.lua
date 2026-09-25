local Lunar = require("lunar")
local Page = Goose.Page

local Function = Goose:LoadString("console.log('hellloo!!')")
print(Function)
Function()
