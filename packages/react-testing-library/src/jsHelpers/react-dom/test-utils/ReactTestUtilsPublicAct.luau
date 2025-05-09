-- ROBLOX upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-dom/src/test-utils/ReactTestUtilsPublicAct.js

--[[
  Copyright (c) Facebook, Inc. and its affiliates.

  This source code is licensed under the MIT license found in the
  LICENSE file in the root directory of this source tree.

]]

local LuauPolyfill = require(script.Parent.Parent.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('luau-polyfill'))
local Boolean = LuauPolyfill.Boolean
local console = LuauPolyfill.console

local Promise = require(script.Parent.Parent.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('promise'))

local exports = {}

-- ROBLOX deviation: Thenable type comes from Shared in roact-alignment
-- local ReactFiberWorkLoopModule = require(Packages["react-reconciler"].src.ReactFiberWorkLoop)
local Shared = require(script.Parent.Parent.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('shared'))
type Thenable<R> = Shared.Thenable<R>

-- ROBLOX deviation: Not converting all of ReactDOM
-- local ReactDOM = require("@pkg/react-dom").default
local ReactSharedInternals = Shared.ReactSharedInternals
local enqueueTask = Shared.enqueueTask
local Scheduler = require(script.Parent.Parent.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('scheduler'))
-- Keep in sync with ReactDOM.js, and ReactTestUtils.js:


local ReactRoblox = require(script.Parent.Parent.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('react-roblox'))
local EventInternals = ReactRoblox.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.Events
-- ROBLOX deviation: EventInternals is a table in Lua
local IsThisRendererActing = EventInternals.IsThisRendererActing
local flushPassiveEffects = EventInternals.flushPassiveEffects

local batchedUpdates = ReactRoblox.unstable_batchedUpdates

local IsSomeRendererActing = ReactSharedInternals.IsSomeRendererActing

-- ROBLOX deviation: use realDelay in place of enqueueTask as a fallback to
-- avoid trouble caused by fake timers
local realDelay = require(script.Parent:WaitForChild('realTaskDelay.roblox.global'))
-- This is the public version of `ReactTestUtils.act`. It is implemented in
-- "userspace" (i.e. not the reconciler), so that it doesn't add to the
-- production bundle size.
-- TODO: Remove this implementation of `act` in favor of the one exported by
-- the reconciler. To do this, we must first drop support for `act` in
-- production mode.

-- TODO: Remove support for the mock scheduler build, which was only added for
-- the purposes of internal testing. Internal tests should use
-- `unstable_concurrentAct` instead.

local isSchedulerMocked = typeof(Scheduler.unstable_flushAllWithoutAsserting) == "function"
-- ROBLOX deviation: not using unstable_flushAllWithoutAsserting
local flushWork = function()
	local didFlushWork = false
	while flushPassiveEffects() do
		didFlushWork = true
	end
	return didFlushWork
end

local function flushWorkAndMicroTasks(onDone: (err: any?) -> ())
	local ok, err = pcall(function()
		flushWork()
		-- ROBLOX deviation START: We need to work around fake timers here in a
		-- way that upstream would in `enqueueTask`'s logic. See the upstream
		-- implementation here:
		-- https://github.com/facebook/react/blob/v17.0.1/packages/shared/enqueueTask.js#L16-L22
		local enqueueTaskWithRelevantTimers: (() -> ()) -> () = enqueueTask
		if type(task.delay) == "table" then
			-- ROBLOX TODO: the upstream implementation referenced above
			-- ultimately uses the _real_ implementation of `setImmediate`,
			-- which does wait for the next tick in the event loop. In our
			-- implementation, fake timers fundamentally block access to
			-- `task.delay`, which is our closest equivalent. Instead, it should
			-- be sufficient to ignore the engine frame boundary and use
			-- `task.defer` instead, which is unaffected by fake timers
			enqueueTaskWithRelevantTimers = function(fn)
				return realDelay(0, fn)
			end
		end
		enqueueTaskWithRelevantTimers(function()
			if flushWork() then
				flushWorkAndMicroTasks(onDone)
			else
				onDone()
			end
		end)
	end)

	if not ok then
		onDone(err)
	end
end

-- we track the 'depth' of the act() calls with this counter,
-- so we can tell if any async act() calls try to run in parallel.

local actingUpdatesScopeDepth = 0
local didWarnAboutUsingActInProd = false

-- ROBLOX deviation: This seems to be a bug in upstream. act-compat doesn't adhere to the callback typing upstream.
-- Added () -> () to align with how act is used in act-compat.
local function act(callback: (() -> Thenable<any>) | () -> ())
do
if didWarnAboutUsingActInProd == false then
			didWarnAboutUsingActInProd = true
			console.error("act(...) is not supported in production builds of React, and might not behave as expected.")
		end
end
local previousActingUpdatesScopeDepth = actingUpdatesScopeDepth
	actingUpdatesScopeDepth += 1

	local previousIsSomeRendererActing = IsSomeRendererActing.current
	local previousIsThisRendererActing = IsThisRendererActing.current
	IsSomeRendererActing.current = true
	IsThisRendererActing.current = true

	local function onDone()
		actingUpdatesScopeDepth -= 1
		IsSomeRendererActing.current = previousIsSomeRendererActing
		IsThisRendererActing.current = previousIsThisRendererActing









end

	local result
	local ok, res = pcall(function()
		result = batchedUpdates(callback)
	end)

	if not ok then
		onDone()
		error(res)
	end

	if result ~= nil and typeof(result) == "table" and typeof(result["andThen"]) == "function" then
		-- setup a boolean that gets set to true only
		-- once this act() call is await-ed
		local called = false

		-- in the async case, the returned thenable runs the callback, flushes
		-- effects and  microtasks in a loop until flushPassiveEffects() === false,
		-- and cleans up













return Promise.new(function(resolve, reject)
			called = true
			result:andThen(function()
				if
					actingUpdatesScopeDepth > 1
					or (isSchedulerMocked == true and previousIsSomeRendererActing == true)
				then
					onDone()
					resolve()
					return
				end
				-- we're about to exit the act() scope,
				-- now's the time to flush tasks/effects
				flushWorkAndMicroTasks(function(err)
					onDone()
					if Boolean.toJSBoolean(err) then
						reject(err)
					else
						resolve()
					end
				end)
			end, function(err)
				onDone()
				reject(err)
			end)
		end)
	else
		-- flush effects until none remain, and cleanup











local ok_, res_ = pcall(function()
			if
				actingUpdatesScopeDepth == 1
				and (isSchedulerMocked == false or previousIsSomeRendererActing == false)
			then
				-- we're about to exit the act() scope,
				-- now's the time to flush effects
				flushWork()
			end
			onDone()
		end)
		if not ok_ then
			onDone()
			error(res_)
		end

		-- in the sync case, the returned thenable only warns *if* await-ed
		return {
			andThen = function(self, resolve: () -> ())



resolve()
			end,
		}
	end
end

exports.default = act

return exports
