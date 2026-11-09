import type { BatchAck, ProblemDetails } from "./contract/wire.js";
export type DeliveryOutcome = {
    kind: "accepted";
    ack: BatchAck;
} | {
    kind: "permanent";
    status: number;
    envelope?: ProblemDetails;
} | {
    kind: "too_large";
} | {
    kind: "retryable";
    detail?: string;
    retryAfterMs?: number;
};
export declare function backoffDelayMs(attempt: number, baseMs: number, random?: () => number): number;
export declare function classifyResponse(response: Response, count: number): Promise<DeliveryOutcome>;
