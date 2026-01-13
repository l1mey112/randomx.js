import { test, expect } from 'vitest'
import { fillAes1Rx4, soft_aesdec, soft_aesenc }  from './rx_harness'

test('fillAes1Rx4', () => {
	const state = new Uint8Array([108, 25, 83, 110, -78, -34, 49, -74, -64, 6, 95, 127, 17, 110, -122, -7, 96, -40, -81, 12, 87, 33, 10, 101, -124, -61, 35, 123, -99, 6, 77, -57, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
	const result = fillAes1Rx4(state)
	expect(result).toEqual(new Uint8Array([-6, -119, 57, 125, -42, -54, 66, 37, 19, -82, -83, -70, 63, 18, 75, 85, 64, 50, 76, 74, -44, -74, -37, 67, 67, -108, 48, 122, 23, -56, 51, -85, -93, 48, 64, 109, -108, 44, -58, -51, 29, 43, -110, -90, 23, -79, 114, 108, 86, -30, -116, 9, 31, 82, -39, -46, -21, 47, 82, 117, 55, -14, 117, 42]))
})

test('aes', () => {
	const test_data = new TextEncoder().encode('test hash 00ss0')
	const test_key = new TextEncoder().encode('adss key 000000')

	const edata = soft_aesenc(test_data, test_key)
	const ddata = soft_aesdec(test_data, test_key)
	expect(edata).toEqual(new Uint8Array([246, 19, 9, 89, 1, 55, 192, 55, 32, 117, 117, 250, 9, 11, 59, 32]))
	expect(ddata).toEqual(new Uint8Array([140, 118, 195, 254, 61, 171, 239, 198, 67, 250, 138, 254, 142, 242, 80, 213]))
});
