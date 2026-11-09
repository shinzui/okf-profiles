import type { AnalyticsEvent } from "./contract/wire.js";
import type { DeliveryOutcome } from "./retry.js";
import type { ResolvedKansokuOptions } from "./types.js";
export declare function serializeBatch(config: ResolvedKansokuOptions, events: AnalyticsEvent[], beacon?: boolean): string;
export declare function exitBudget(): {
    bytes: number;
};
export declare function sendBatch(config: ResolvedKansokuOptions, events: AnalyticsEvent[], { keepalive, serialized }?: {
    keepalive?: boolean;
    serialized?: string;
}): Promise<DeliveryOutcome>;
