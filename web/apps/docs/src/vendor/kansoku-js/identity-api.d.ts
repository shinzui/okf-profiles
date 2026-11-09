import type { InternalClient } from "./client.js";
import type { IdentifierKind, JsonObject, TrackOptions } from "./types.js";
export declare function createIdentityApi(client: InternalClient): {
    identify(userId: string, traits?: JsonObject, options?: TrackOptions): void;
    identifyOnce(userId: string, traits?: JsonObject, options?: TrackOptions): void;
    alias(previousId: string, newId: string, properties?: JsonObject): void;
    group(organizationId: string, properties?: JsonObject): void;
    setIdentifiers(identifiers: Partial<Record<IdentifierKind, string>>): void;
    reset(): void;
};
