local Lunar = require("lunar")
local Page = Goose.Page

local Function = Goose:LoadString([[
  console.log('hellloo!!') 
  return 'successful'
]])
print(Function())
