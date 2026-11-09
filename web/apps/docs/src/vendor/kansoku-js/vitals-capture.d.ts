import type { InternalClient } from "./client.js";
import type { AnalyticsEvent, JsonObject } from "./types.js";
export declare const measurementLoader: {
    load: () => Promise<typeof import("./vitals.js")>;
};
export declare function createVitalCapture(core: InternalClient, copy: (original: AnalyticsEvent, name: string, properties: JsonObject) => AnalyticsEvent): {
    retire: () => void;
    page(event: AnalyticsEvent): void;
};
