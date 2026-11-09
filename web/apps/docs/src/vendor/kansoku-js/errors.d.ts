import type { InternalClient } from "./client.js";
import type { AnalyticsEvent, JsonObject } from "./types.js";
export declare function errorProperties(value: unknown, rejection?: boolean, crossOrigin?: boolean): JsonObject;
export declare function createErrorCapture(core: InternalClient, snapshot: () => AnalyticsEvent | undefined, copy: (original: AnalyticsEvent, name: string, properties: JsonObject) => AnalyticsEvent): () => void;
