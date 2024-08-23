/* import { test, expect } from 'bun:test'
import { blake2b } from "../src/blake2b/blake2b";
import { blakegenerator } from "../src/blake2b/blakegenerator";
import { detect } from "../src/detect/detect";

const feature = await detect()
const blake = await blake2b(feature)


test('superscalarhash', () => {
	const generator = blakegenerator(blake)

	const references = [
		"d3a4a6623738756f77e6104469102f082eff2a3e60be7ad696285ef7dfc72a61",
		"f5e7e0bbc7e93c609003d6359208688070afb4a77165a552ff7be63b38dfbc86",
		"85ed8b11734de5b3e9836641413a8f36e99e89694f419c8cd25c3f3f16c40c5a",
		"5dd956292cf5d5704ad99e362d70098b2777b2a1730520be52f772ca48cd3bc0",
		"6f14018ca7d519e9b48d91af094c0f2d7e12e93af0228782671a8640092af9e5",
		"134be097c92e2c45a92f23208cacd89e4ce51f1009a0b900dbe83b38de11d791",
		"268f9392c20c6e31371a5131f82bd7713d3910075f2f0468baafaa1abd2f3187",
		"c668a05fd909714ed4a91e8d96d67b17e44329e88bc71e0672b529a3fc16be47",
		"99739351315840963011e4c5d8e90ad0bfed3facdcb713fe8f7138fbf01c4c94",
		"14ab53d61880471f66e80183968d97effd5492b406876060e595fcf9682f9295",
	]

	for (let i = 0; i < references.length; i++) {
		
	}
}) */
