-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/types/pretty-dom.d.ts
local exports = {}

local prettyFormat = require(script.Parent.Parent:WaitForChild('node_modules'):WaitForChild('.luau-aliases'):WaitForChild('@jsdotlua'):WaitForChild('pretty-format'))

export type PrettyDOMOptions = prettyFormat_OptionsReceived & {
	--[[*
       * Given a `Node` return `false` if you wish to ignore that node in the output.
       * By default, ignores `<style />`, `<script />` and comment nodes.
   ]]
	filterNode: ((node: Instance) -> boolean)?
}

export type prettyDOM = (dom: Instance?, maxLength: number?, options: PrettyDOMOptions?) -> string | false

export type logDOM = (dom: Instance?, maxLength: number?, options: PrettyDOMOptions?) -> ()

export type prettyFormat_Colors = prettyFormat.Colors
export type prettyFormat_CompareKeys = prettyFormat.CompareKeys
export type prettyFormat_Config = prettyFormat.Config
export type prettyFormat_Options = prettyFormat.Options
export type prettyFormat_OptionsReceived = prettyFormat.OptionsReceived
export type prettyFormat_OldPlugin = prettyFormat.OldPlugin
export type prettyFormat_NewPlugin = prettyFormat.NewPlugin
export type prettyFormat_Plugin = prettyFormat.Plugin
export type prettyFormat_Plugins = prettyFormat.Plugins
export type prettyFormat_PrettyFormatOptions = prettyFormat.PrettyFormatOptions
export type prettyFormat_Printer = prettyFormat.Printer
export type prettyFormat_Refs = prettyFormat.Refs
export type prettyFormat_Theme = prettyFormat.Theme

return exports
