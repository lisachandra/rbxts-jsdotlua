-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/queries/index.ts
local LuauPolyfill = require(script.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('luau-polyfill'))
local Object = LuauPolyfill.Object

local exports = {}

-- Object.assign(exports, require(script["label-text"]))
Object.assign(exports, require(script["placeholder-text"]))
Object.assign(exports, require(script.text))
Object.assign(exports, require(script["display-value"]))
-- Object.assign(exports, require(script["alt-text"]))
-- Object.assign(exports, require(script.title))
-- Object.assign(exports, require(script.role))
Object.assign(exports, require(script["test-id"]))

return exports
