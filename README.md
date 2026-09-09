# Badger Semantic Conventions

[![Registry checks](https://github.com/CtrlSpice/badger-semconv/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/CtrlSpice/badger-semconv/actions/workflows/check.yml)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

This repository defines an independent OpenTelemetry semantic-convention
registry for instrumented post-mortem badger systems. It standardizes badger
entities, reanimation sessions, and enclosure measurements in a model validated
by [Weaver].

The operational domain is adapted from Lucy A. Snyder's 2004 article,
["Installing Linux on a Dead Badger: User's Notes"]. The article is not
included in this repository.

This is not an official OpenTelemetry project.

["Installing Linux on a Dead Badger: User's Notes"]: https://strangehorizons.com/wordpress/non-fiction/articles/installing-linux-on-a-dead-badger-users-notes/
[Weaver]: https://github.com/open-telemetry/weaver

## Read the docs

Operational guidance and the generated reference are in
[`docs/badger`](docs/badger/README.md). Weaver generates the entity, span, and
metric pages from the YAML definitions in [`model/badger`](model/badger).

## Registry

| Type | Group | Description |
| --- | --- | --- |
| Entity | `entity.badger` | Identity and operational properties of one instrumented specimen. |
| Span | `span.badger.session` | Root span for the specimen's post-installation lifetime. |
| Metric | `metric.badger.*` | Monotonic decay and enclosure environment measurements. |

The registry keeps specimen identity on the `badger` entity rather than metric
attributes. It also defines head-sampling, degraded-timing, freshness,
trace-context audit, scheduling, and decay requirements for the reanimated
runtime.

## Development

Install [Weaver v0.26.1] and run:

```sh
make check
make generate
```

`make check` enables Weaver's future validation rules. `make generate` uses the
repository's Markdown templates and rewrites the generated files under
`docs/badger`. Pull requests fail when the model is invalid or the generated
reference is stale.

[Weaver v0.26.1]: https://github.com/open-telemetry/weaver/releases/tag/v0.26.1

## Stability

All conventions have `development` stability. The schema URL reserves version
0.1.0 for a future registry package; the model in this repository remains the
source of truth until that package is published.

## License

This repository is licensed under the [Apache License 2.0](LICENSE). The linked
article remains copyright Lucy A. Snyder.
