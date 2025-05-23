import { OptionsReceived } from "@rbxts/pretty-format";
import { BoundFunctions, Queries } from "./get-queries-for-element";
import * as queries from "./queries";

export type Screen<Q extends Queries = typeof queries> = BoundFunctions<Q> & {
	/**
	 * Convenience function for `pretty-dom` which also allows an array of
	 * elements
	 */
	debug: (
		element?: Array<Element> | Element,
		maxLength?: number,
		options?: OptionsReceived,
	) => void;
	/**
	 * Convenience function for `Testing Playground` which logs and returns the
	 * URL that can be opened in a browser
	 */
	logTestingPlaygroundURL: (element?: Element) => string;
};

export const screen: Screen;
