import type { KansokuOptions } from "./types.js";
export declare function installNavigationCapture(state: {
    timers: NonNullable<KansokuOptions["timers"]>;
}, onNavigate: () => void): () => void;
