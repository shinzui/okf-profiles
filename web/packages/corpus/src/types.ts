import type { Heading } from "./headings"
export interface Bundle {
  name: string
  directory: string
  export?: string
  projectUri?: string | null
}
export interface ContentConfig {
  schemaVersion: 1
  projectUri: string | null
  documents: string[]
  bundles: Bundle[]
  assets: string[]
}
export interface Summary {
  path: string
  href: string
  title: string
  description: string
  identity: string
  bundle: string | null
  exportPath: string | null
  headings: Heading[]
  metadata: Record<string, string>
}
export interface Document extends Summary {
  bundleDirectory: string | null
  body: string
  links: Record<string, string>
}
export interface Corpus {
  documents: Document[]
  assets: string[]
  commit: string
  date: string
}
