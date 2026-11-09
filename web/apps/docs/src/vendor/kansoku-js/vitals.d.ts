import type { Metric } from "web-vitals";
export type Sample = Pick<Metric, "name" | "value" | "id" | "navigationType">;
type Sink = (sample: Sample) => void;
export declare function vitalProperties(name: string, value: number): {
    metric: string;
    value: number;
} | undefined;
export declare function subscribe(sink: Sink): () => void;
export {};
