import { RANDOMX_ARGON_ITERATIONS, RANDOMX_ARGON_LANES, RANDOMX_ARGON_MEMORY, RANDOMX_ARGON_SALT } from "../../include/configuration";
import type { Blake2b } from "../blake2b/blake2b";
import { store32 } from "../utils";

/* argon2_context context;

context.out = nullptr;
context.outlen = 0;
context.pwd = CONST_CAST(uint8_t *)key;
context.pwdlen = (uint32_t)keySize;
context.salt = CONST_CAST(uint8_t *)RANDOMX_ARGON_SALT;
context.saltlen = (uint32_t)randomx::ArgonSaltSize;
context.secret = NULL;
context.secretlen = 0;
context.ad = NULL;
context.adlen = 0;
context.t_cost = RANDOMX_ARGON_ITERATIONS;
context.m_cost = RANDOMX_ARGON_MEMORY;
context.lanes = RANDOMX_ARGON_LANES;
context.threads = 1;
context.allocate_cbk = NULL;
context.free_cbk = NULL;
context.flags = ARGON2_DEFAULT_FLAGS;
context.version = ARGON2_VERSION_NUMBER; */

/* store32(&value, context->lanes);
store32(&value, context->outlen);
store32(&value, context->m_cost);
store32(&value, context->t_cost);
store32(&value, context->version);
store32(&value, (uint32_t)type);
store32(&value, context->pwdlen); */

const ARGON2_PREHASH_DIGEST_LENGTH = 64
const ARGON2_PREHASH_SEED_LENGTH = 72
const ARGON2_BLOCK_SIZE = 1024

function rxa2_initial_hash(blake2b: Blake2b, key: Uint8Array, blockhash: Uint8Array) {
	blake2b.module.blake2b_init(ARGON2_PREHASH_DIGEST_LENGTH, 0)
	
	store32(blake2b.scratch, 0, RANDOMX_ARGON_LANES) // lanes
	blake2b.module.blake2b_update(4)

	store32(blake2b.scratch, 0, 0) // outlen
	blake2b.module.blake2b_update(4)

	store32(blake2b.scratch, 0, RANDOMX_ARGON_MEMORY) // m_cost
	blake2b.module.blake2b_update(4)

	store32(blake2b.scratch, 0, RANDOMX_ARGON_ITERATIONS) // t_cost
	blake2b.module.blake2b_update(4)

	store32(blake2b.scratch, 0, 0x13) // version (ARGON2_VERSION_13)
	blake2b.module.blake2b_update(4)

	store32(blake2b.scratch, 0, 0) // type (Argon2_d)
	blake2b.module.blake2b_update(4)

	store32(blake2b.scratch, 0, key.length) // pwdlen
	blake2b.module.blake2b_update(4)

	blake2b.scratch.set(key) // pwd
	blake2b.module.blake2b_update(key.length)

	store32(blake2b.scratch, 0, RANDOMX_ARGON_SALT.length) // saltlen
	blake2b.module.blake2b_update(4)

	blake2b.scratch.set(new TextEncoder().encode(RANDOMX_ARGON_SALT)) // salt
	blake2b.module.blake2b_update(RANDOMX_ARGON_SALT.length)

	store32(blake2b.scratch, 0, 0) // secretlen (no secret)
	blake2b.module.blake2b_update(4)

	store32(blake2b.scratch, 0, 0) // adlen (no associated data)
	blake2b.module.blake2b_update(4)

	blake2b.module.blake2b_finalise()

	blockhash.set(blake2b.scratch.subarray(0, ARGON2_PREHASH_DIGEST_LENGTH))
}

function blake2b_long1024(blake2b: Blake2b) {
	blake2b.module.blake2b_init(64, 0)
	blake2b.module.blake2b_update()
}

function rxa2_fill_first_blocks() {
	
}

function randomx_argon2_initialize(blake2b: Blake2b, key: Uint8Array) {
	const blockhash = new Uint8Array(ARGON2_PREHASH_SEED_LENGTH)
	rxa2_initial_hash(blake2b, key, blockhash)


}

export function argon2fill(blake2b: Blake2b, key: Uint8Array) {
	if (key.length > 60) {
		throw new Error('assertion failed: key.length <= 60')
	}

	// rxa2 initial hash

	
}
