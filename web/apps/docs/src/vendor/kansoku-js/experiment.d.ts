import type { InternalClient } from "./client.js";
import type { ExperimentOptions, JsonObject } from "./types.js";
export declare function recordExposure(client: InternalClient, experiment: string, variant: string, properties?: JsonObject, options?: ExperimentOptions): void;
