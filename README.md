 OSINT Scraper — Document Scrubbing and Instance Finder

Takes a document or plaintext dump of scraped page content and searches it
for a configurable set of keywords, returning each match with surrounding
context.

The current build is scoped to my own resume — it looks for terms from it
across scraped source material to check whether a target site or document
already contains relevant information. Support for pointing it at an
arbitrary directory or file set instead is in progress.

The intended use is building a picture for a social-engineering assessment:
which passages contain relevant terms, what context surrounds them, and
whether they're worth following up. It could reasonably be extended to
crawl a target directory for credentials or other artifacts.

Written with Google Gemini assistance for the scaffolding.

## Scope

For use in authorized, controlled environments only — labs, CTFs, or
engagements you're cleared for. Not intended for use against systems
without permission.
