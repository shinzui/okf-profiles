import type { KansokuOptions, StorageAdapter } from "./types.js";
export type { StorageAdapter } from "./types.js";
export declare function memoryStorage(): StorageAdapter;
export declare const localStorageAdapter: () => StorageAdapter;
export declare const sessionStorageAdapter: () => StorageAdapter;
export declare function cookieStorage({ domain, debug, }?: {
    domain?: string;
    debug?: boolean;
}): StorageAdapter;
export declare function resolveStorage(option: KansokuOptions["storage"], domain?: string, debug?: boolean): StorageAdapter;
export declare function readJSON(storage: StorageAdapter, key: string): unknown;
