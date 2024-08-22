import { type Feature } from "../detect/detect";

export function choose(feature: Feature) {
	if (feature === 'js') {
		return import('./main.c.js')
	} else {
		return import('./main.c.wasm')
	}
}