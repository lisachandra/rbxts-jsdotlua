-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/types/suggestions.d.ts
local LuauPolyfill = require(script.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('luau-polyfill'))
type Array<T> = LuauPolyfill.Array<T>

local RegExp = require(script.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('luau-regexp'))
type RegExp = RegExp.RegExp

local exports = {}

export type QueryOptions = { [string]: RegExp | boolean }

export type QueryArgs = Array<string | QueryOptions?>

export type Suggestion = {
	queryName: string,
	queryMethod: string,
	queryArgs: QueryArgs,
	variant: string,
	warning: string?,
	toString: () -> string
}

export type Variant = "find" | "findAll" | "get" | "getAll" | "query" | "queryAll"

-- ROBLOX deviation START: commenting out unsupported methods
export type Method =
	-- "AltText"
	-- | "alttext"
	"DisplayValue"
	| "displayvalue"
	-- | "LabelText"
	-- | "labeltext"
	| "PlaceholderText"
	| "placeholdertext"
	-- | "Role"
	-- | "role"
	| "TestId"
	| "testid"
	| "Text"
	| "text"
-- | "Title"
-- | "title"
-- ROBLOX deviation END

export type getSuggestedQuery = (element: Instance, variant: Variant?, method: Method?) -> Suggestion | nil

return exports
