-- ROBLOX upstream: https://github.com/testing-library/react-testing-library/blob/v12.1.5/src/pure.js
local LuauPolyfill = require(script.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('luau-polyfill'))
local Error = LuauPolyfill.Error
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local console = LuauPolyfill.console
type Object = LuauPolyfill.Object

local Promise = require(script.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('promise'))
local ReactRoblox = require(script.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('react-roblox'))

local exports = {}

local React = require(script.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('react'))-- local ReactDOM = require("@pkg/react-dom").default

local domModule = require(script.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('dom-testing-library'))
local getQueriesForElement = domModule.getQueriesForElement
local prettyDOM = domModule.prettyDOM
local configureDTL = domModule.configure
local act_compatModule = require(script.Parent:WaitForChild('act-compat'))
local act = act_compatModule.default
local asyncAct = act_compatModule.asyncAct
local fireEvent = require(script.Parent:WaitForChild('fire-event')).fireEvent

-- ROBLOX deviation START: predefine variable
local cleanupAtContainer
-- ROBLOX deviation END

configureDTL({
	asyncWrapper = function(cb)
		return Promise.resolve():andThen(function()
			local result
			asyncAct(function()
				return Promise.resolve():andThen(function()
					result = cb():expect()
				end)
			end):expect()
			return result
		end)
	end,
	eventWrapper = function(cb)
		local result
		act(function()
			result = cb()
		end)
		return result
	end,
})

local mountedContainers = Set.new()
-- ROBLOX deviation START: required because we don't have ReactDOM
local renderer
-- ROBLOX deviation END

local function render(ui, ref_: Object?)
	local ref = (if ref_ == nil then {} else ref_) :: Object
	local container, baseElement, queries, hydrate, WrapperComponent =
		ref.container,
		if ref.baseElement == nil then ref.container else ref.baseElement,
		ref.queries,
		if ref.hydrate == nil then false else ref.hydrate,
		ref.wrapper

	if not baseElement then
		-- default to document.body instead of documentElement to avoid output of potentially-large
		-- head elements (such as JSS style blocks) in debug output
		-- ROBLOX deviation START: no document.body, default to document
		baseElement = domModule.document
		-- ROBLOX deviation END
	end
	if not container then
		-- ROBLOX deviation START: replace ReactDom
		container = Instance.new("Folder")
		container.Parent = baseElement
		renderer = ReactRoblox.createLegacyRoot(container)
		-- baseElement:render(container)
	end

	-- we'll add it to the mounted containers regardless of whether it's actually
	-- added to document.body so the cleanup method works regardless of whether
	-- they're passing us a custom container or not.
	mountedContainers:add(container)

	local function wrapUiIfNeeded(innerElement)
		return if WrapperComponent then React.createElement(WrapperComponent, nil, innerElement) else innerElement
	end

	act(function()
		if hydrate then
			-- ROBLOX deviation START: hydrate is not supported
			error(Error.new("hydrate not supported"))
			-- renderer:hydrate(wrapUiIfNeeded(ui))
			-- ROBLOX deviation END
		else
			-- ROBLOX deviation START: deviates from using ReactDOM:render
			-- ReactDOM:render(wrapUiIfNeeded(ui), container)
			renderer:render(wrapUiIfNeeded(ui) :: any)
			-- ROBLOX deviation END
		end
	end)

	return Object.assign({}, {
		container = container,
		baseElement = baseElement,
		debug = function(el: any?, maxLength, options)
			if el == nil then
				el = baseElement
			end
			return if Array.isArray(el)
				then -- eslint-disable-next-line no-console
					Array.forEach(el :: any, function(e)
						return console.log(prettyDOM(e, maxLength, options))
					end)
				else -- eslint-disable-next-line no-console,
					console.log(prettyDOM(el, maxLength, options))
		end,
		unmount = function()
			act(function()
				-- ROBLOX deviation START. not using ReactDOM:unmountComponentAtNode
				-- ReactDOM:unmountComponentAtNode(container)
				renderer:unmount()
				-- ROBLOX deviation END
			end)
		end,
		rerender = function(rerenderUi)
			render(wrapUiIfNeeded(rerenderUi), { container = container, baseElement = baseElement })
			-- Intentionally do not return anything to avoid unnecessarily complicating the API.
			-- folks can use all the same utilities we return in the first place that are bound to the container
		end,
		asFragment = function()
			--[[ istanbul ignore else (old jsdom limitation) ]]
			-- ROBLOX deviation START: no createRange
			-- if typeof(document.createRange) == "function" then
			-- 	return document:createRange():createContextualFragment(container.innerHTML)
			-- else
			-- local template = document:createElement("template")
			-- template.innerHTML = container.innerHTML
			-- return template.content
			-- end
			warn("asFragment not supported")
			-- ROBLOX deviation END
		end,
	}, getQueriesForElement(baseElement, queries))
end

local function cleanup()
	mountedContainers:forEach(cleanupAtContainer)
end

-- maybe one day we'll expose this (perhaps even as a utility returned by render).
-- but let's wait until someone asks for it.
function cleanupAtContainer(container)
	act(function()
		-- ROBLOX deviation START. not using ReactDOM:unmountComponentAtNode
		-- ReactDOM:unmountComponentAtNode(container)
		renderer:unmount()
	end)
	if container.Parent == domModule.document then
		container.Parent = nil
	end
	mountedContainers:delete(container)
end

-- just re-export everything from dom-testing-library
Object.assign(exports, require(script.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('dom-testing-library')))
exports.render = render
exports.cleanup = cleanup
exports.act = act
exports.fireEvent = fireEvent

-- NOTE: we're not going to export asyncAct because that's our own compatibility
-- thing for people using react-dom@16.8.0. Anyone else doesn't need it and
-- people should just upgrade anyway.
--[[ eslint func-name-matching:0 ]]
return exports
