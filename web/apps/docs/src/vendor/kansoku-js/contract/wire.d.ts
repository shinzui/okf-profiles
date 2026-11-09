import type { components } from "../generated/schema.js";
export type JsonValue = string | number | boolean | null | JsonObject | JsonValue[];
export interface JsonObject {
    [key: string]: JsonValue;
}
export type { paths } from "../generated/schema.js";
export type AnalyticsEvent = components["schemas"]["AnalyticsEvent"];
export type BeaconEnvelope = components["schemas"]["BeaconEnvelope"];
export type BatchAck = components["schemas"]["BatchAck"];
export type RejectedEvent = components["schemas"]["RejectedEvent"];
export type ProblemDetails = components["schemas"]["ProblemDetails"];
export type SchemaCatalog = components["schemas"]["SchemaCatalog"];
export type EventVersions = components["schemas"]["EventVersions"];
export type VersionedEventSchema = components["schemas"]["VersionedEventSchema"];
export type ContractProperty = components["schemas"]["ContractProperty"];
export type EventSource = components["schemas"]["EventSource"];
export type IngestAck = components["schemas"]["IngestAck"];
export type MetricPoint = components["schemas"]["MetricPoint"];
