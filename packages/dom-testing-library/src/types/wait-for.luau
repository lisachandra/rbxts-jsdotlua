local LuauPolyfill = require(script.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('luau-polyfill'))
type Error = LuauPolyfill.Error
type Object = LuauPolyfill.Object
type Promise<T> = LuauPolyfill.Promise<T>

-- ROBLOX deviation START: unknown types
type HTMLElement = Instance
type MutationObserverInit = Object
-- ROBLOX deviation END

local exports = {}

export type waitForOptions = {
	container: HTMLElement?,
	timeout: number?,
	interval: number?,
	onTimeout: ((error_: any) -> Error)?,
	mutationObserverOptions: MutationObserverInit?
}
export type waitFor = <T>(callback: () -> Promise<T> | T, options: waitForOptions?) -> Promise<T>

return exports
