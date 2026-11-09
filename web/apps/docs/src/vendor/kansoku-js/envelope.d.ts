import type { AnalyticsEvent, JsonObject } from "./contract/wire.js";
import type { IdentifierKind, TrackOptions } from "./types.js";
export interface IdentitySnapshot {
    anonymousId: string;
    userId?: string;
    organizationId?: string;
    identifiers?: Partial<Record<IdentifierKind, string>>;
}
export type WebFields = Pick<AnalyticsEvent, "url" | "referrer" | "utmSource" | "utmMedium" | "utmCampaign" | "utmContent" | "utmTerm">;
export interface EnvelopeDependencies {
    identity: IdentitySnapshot;
    sessionId: string;
    config: {
        sourceService?: string;
        schemaVersions: Readonly<Record<string, number>>;
        now: () => number;
    };
    baseContext?: JsonObject;
}
export declare function randomId(): string;
export declare function buildEvent(deps: EnvelopeDependencies, eventName: string, properties?: JsonObject, options?: TrackOptions, webFields?: WebFields, ids?: {
    anonymousId?: string;
    userId?: string;
}): AnalyticsEvent;
