import type { IdentitySnapshot } from "./envelope.js";
import type { IdentifierKind, StorageAdapter } from "./types.js";
export declare function createIdentity(storage: StorageAdapter, prefix: string): {
    hadPersistedIdentity: boolean;
    adoptAnonymousId(value: string): void;
    snapshot(): IdentitySnapshot;
    setUserId(value: string): void;
    setOrganizationId(value: string): void;
    setIdentifiers(value: Partial<Record<IdentifierKind, string>>): void;
    rotateAnonymousId(): string;
    clearUser(): void;
};
