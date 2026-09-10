# Badger Semantic Conventions

[![Registry checks](https://github.com/CtrlSpice/badger-semconv/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/CtrlSpice/badger-semconv/actions/workflows/check.yml)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

This repository defines an independent OpenTelemetry semantic-convention
registry for instrumented post-mortem badger systems. It standardizes badger
entities, reanimation sessions, profile interpretation, and enclosure
measurements in a model validated by [Weaver].

The operational domain is adapted from Lucy A. Snyder's 2004 article,
["Installing Linux on a Dead Badger: User's Notes"]. The article is not
included in this repository.

This is not an official OpenTelemetry project.

["Installing Linux on a Dead Badger: User's Notes"]: https://strangehorizons.com/wordpress/non-fiction/articles/installing-linux-on-a-dead-badger-users-notes/
[Weaver]: https://github.com/open-telemetry/weaver

## Read the docs

Operational guidance and the generated reference are in
[`docs/badger`](docs/badger/README.md). Weaver generates the entity, span,
metric, and profile-attribute pages from the YAML definitions in
[`model/badger`](model/badger).

## Registry

| Type | Group | Description |
| --- | --- | --- |
| Entity | `entity.badger` | Identity and operational properties of one instrumented specimen. |
| Span | `span.badger.session` | Root span for the specimen's post-installation lifetime. |
| Metric | `metric.badger.*` | Monotonic decay and enclosure environment measurements. |
| Attribute group | `profile.badger`, `profile.badger.sample` | Profile- and sample-level interpretation attributes. |

The registry keeps specimen identity on the `badger` entity rather than metric
attributes. It also defines head-sampling, degraded-timing, freshness,
trace-context audit, scheduling, and decay requirements for the reanimated
runtime. Weaver v0.26.1 has no first-class Profiles group type; the
`profile.badger` groups define attribute applicability while the native OTLP
Profiles data model defines the signal.

## Wildlife and containment

> [!IMPORTANT]
> This registry is technical documentation, not legal advice or authorization
> to acquire, possess, modify, transport, reanimate, release, or dispose of
> wildlife. Operators are responsible for identifying and complying with every
> applicable national, Indigenous or Tribal, regional, and local requirement
> before handling a specimen.

Canada geese (*Branta canadensis*) are outside the supported specimen set unless
possession and the intended use are affirmatively authorized in every
applicable jurisdiction.[^canada-goose]

A reanimated specimen MUST be treated as requiring containment that remains
resource-intensive and operationally unreliable, independent of its separately
assessed disruption potential and hazard severity.[^scp-keter]

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

Except for quotations identified by their own attribution, this repository is
licensed under the [Apache License 2.0](LICENSE). The linked article remains
copyright Lucy A. Snyder.

[^canada-goose]: The Government of Canada's protected-bird lists identify
    *Branta canadensis* as **Canada Goose** in
    [English](https://www.canada.ca/en/environment-climate-change/services/migratory-birds-legal-protection/list.html)
    and **Bernache du Canada** in
    [French](https://www.canada.ca/fr/environnement-changement-climatique/services/protection-legale-oiseaux-migrateurs/liste.html).
    Section 5 of the
    [*Migratory Birds Convention Act, 1994*](https://laws-lois.justice.gc.ca/eng/acts/M-7.01/section-5.html)
    provides: "Except as authorized by the regulations, no person shall,
    without lawful excuse, (a) be in possession of a migratory bird or nest;"
    The official French text,
    [*Loi de 1994 sur la convention concernant les oiseaux migrateurs*](https://laws-lois.justice.gc.ca/fra/lois/M-7.01/section-5.html),
    provides: "Sauf conformément aux règlements, nul ne peut, sans excuse
    valable : a) avoir en sa possession un oiseau migrateur ou son nid;"
    Section 11 of the
    [*Migratory Birds Regulations, 2022*](https://laws-lois.justice.gc.ca/eng/regulations/SOR-2022-105/section-11.html)
    and its official French text,
    [*Règlement sur les oiseaux migrateurs (2022)*](https://laws-lois.justice.gc.ca/fra/reglements/DORS-2022-105/section-11.html)
    allow possession of a found-dead migratory bird without a permit only
    temporarily and only for lawful disposal, delivery to a laboratory for
    analysis as soon as circumstances permit, or laboratory analysis. Other
    wildlife, land-access, public-health, transport, and disposal rules may
    apply.

[^scp-keter]: Under the modern Anomaly Classification System, Keter remains a
    containment class; disruption and risk are assessed separately.
    "Keter-class SCP objects are anomalies that are exceedingly difficult to
    contain consistently or reliably, with containment procedures often being
    extensive and complex. [...] A Keter SCP does not mean the SCP is
    dangerous, just that it is simply very difficult or costly to contain."
    Quoted from ["Object Classes"](https://scp-wiki.wikidot.com/object-classes),
    SCP Foundation Wiki, by "Aelanna" (author) and "MayD" (rewrite author), per
    [SCPPER](https://scpper.com/page/22064647). The quotation remains licensed
    under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/), not
    Apache-2.0.
