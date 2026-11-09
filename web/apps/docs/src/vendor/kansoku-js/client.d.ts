import type { AnalyticsEvent, JsonObject } from "./contract/wire.js";
import type { WebFields } from "./envelope.js";
import type { DropReason, KansokuClient, KansokuOptions, ResolvedKansokuOptions, TrackOptions } from "./types.js";
export declare function resolveOptions(options: KansokuOptions): ResolvedKansokuOptions;
export declare function createInternalClient(options: KansokuOptions, deferStart?: boolean): {
    config: Readonly<Required<Omit<KansokuOptions, "beforeSend" | "onDrop" | "cookieDomain">> & Pick<KansokuOptions, "beforeSend" | "onDrop" | "cookieDomain">>;
    readonly stats: Readonly<{
        accepted: number;
        bestEffortQueued: number;
        rejected: number;
        dropped: number;
        queued: number;
    }>;
    track(name: string, properties?: JsonObject, trackOptions?: TrackOptions): void;
    flush: () => Promise<void>;
    start(): void;
    stop(): void;
    shutdown(): Promise<void>;
    optOut(): void;
    optIn(): void;
    isOptedOut: () => boolean;
    getAnonymousId: () => string;
    getUserId: () => string | undefined;
    getSessionId: () => string;
    buildEvent: (name: string, properties?: JsonObject, trackOptions?: TrackOptions, webFields?: WebFields, ids?: {
        anonymousId?: string;
        userId?: string;
    }) => AnalyticsEvent;
    enqueueBuilt: (event: AnalyticsEvent, save?: boolean) => boolean;
    enqueueMany(events: AnalyticsEvent[]): void;
    registerContextProvider(provider: () => JsonObject): () => void;
    onStart: (install: () => (() => void) | void) => void;
    onExit(listener: () => void): () => void;
    drop: (reason: DropReason, events: AnalyticsEvent[], detail?: string) => void;
    isSuppressed: () => boolean;
    isStarted: () => boolean;
    setSuppression(check: () => boolean): void;
    identity: {
        hadPersistedIdentity: boolean;
        adoptAnonymousId(value: string): void;
        snapshot(): import("./envelope.js").IdentitySnapshot;
        setUserId(value: string): void;
        setOrganizationId(value: string): void;
        setIdentifiers(value: Partial<Record<import("./types.js").IdentifierKind, string>>): void;
        rotateAnonymousId(): string;
        clearUser(): void;
    };
    session: {
        current(nowMs: number): {
            id: string;
            started: boolean;
        };
        touch(nowMs: number): void;
        rotate: (nowMs: number) => {
            id: string;
            started: boolean;
        };
    };
    storage: import("./types.js").StorageAdapter;
    rotateSession(): void;
};
export type InternalClient = ReturnType<typeof createInternalClient>;
export declare function createKansoku(options: KansokuOptions): KansokuClient;
