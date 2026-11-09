import type { StorageAdapter } from "./types.js";
export declare function createSession(storage: StorageAdapter, prefix: string, timeoutMs: number): {
    current(nowMs: number): {
        id: string;
        started: boolean;
    };
    touch(nowMs: number): void;
    rotate: (nowMs: number) => {
        id: string;
        started: boolean;
    };
};
