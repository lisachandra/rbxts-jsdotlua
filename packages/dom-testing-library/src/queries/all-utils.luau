-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/queries/all-utils.ts
local LuauPolyfill = require(script.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('luau-polyfill'))
local Object = LuauPolyfill.Object

local exports = {} :: { [string]: any }

Object.assign(exports, require(script.Parent.Parent.matches))
Object.assign(exports, require(script.Parent.Parent["get-node-text"]))
Object.assign(exports, require(script.Parent.Parent["query-helpers"]))
Object.assign(exports, require(script.Parent.Parent.config))

return exports
