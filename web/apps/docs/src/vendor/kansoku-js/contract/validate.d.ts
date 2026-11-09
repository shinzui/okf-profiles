import type { AnalyticsEvent } from "./wire.js";
export declare function isPlainObject(value: unknown): value is Record<string, unknown>;
export declare function validateIdentifiers(value: unknown): string[];
export declare function validateExperimentName(value: unknown): boolean;
export declare function validateEvent(event: AnalyticsEvent): string[];
export declare function validateGovernedTraits(event: Pick<AnalyticsEvent, "eventName" | "schemaVersion" | "userId" | "properties">): string[];
