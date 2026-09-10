# Badger Semantic Conventions

The badger registry describes one instrumented badger entity, its root session
span, the profiles collected during that session, and the measurements needed
to operate its enclosure. The detailed pages are generated from the registry
model:

- [Entity](entities.md)
- [Span](spans.md)
- [Metrics](metrics.md)
- [Profiles](profiles.md)

## Signal model

Every session consumes one badger. `badger.id` and `badger.instance.id` jointly
identify its post-installation runtime; `badger.namespace` and `badger.name` are
descriptive aliases. Identity belongs to the `badger` entity and never to metric
attributes: using `badger.instance.id` as a label would create one permanent
series per session. Spans and metrics declare an entity association instead.

The root `badger.session` span begins only after installation. Sampling is a
head decision made when that span starts. The elapsed time before the span,
from acquisition through installation, is represented by
`badger.prelude.duration` and its timestamp provenance.

## Timing and scheduling

A polled adapter smears timestamps by at least one millisecond. Such a session
sets `badger.timing.degraded=true`; consumers may display its spans but must not
render a profile from its sampled signals. The [Profiles](profiles.md) page
defines the profile- and sample-level interpretation attributes.

Scheduling discipline controls which analysis is defensible. Cooperative hosts
cannot distinguish a task that failed to yield from a hung machine, so blocked
time cannot be attributed per task. Message-passing hosts carry trace context
on the message structure and copy the physically carried value into
`badger.traceparent` for audit and cross-host comparison.

## Freshness and condition

Collectors enforce freshness before admitting the first signal for a session.
They compare their receive time with
`badger.acquired_at + badger.freshness.window` and reject the session when the
receive time is later. The convention defines the inputs and rule; the
collector owns the enforcement mechanism.

`badger.condition.declared` preserves the operator's acquisition-time claim.
It is never an input to measured decay. Condition derived from telemetry comes
from the increasing `badger.decay` counter.

The `{decay}` unit is not a calibrated UCUM quantity. Until a physical quantity
and protocol are fixed, decay values and rates are comparable only within one
operator protocol and cannot support a cross-operator freshness objective.

## Collection topology

Receivers bind to loopback only. Remote delivery is initiated by an exporter;
the receiver is not exposed on a network interface. Retention is bounded by a
finite physical storage budget rather than a promised wall-clock duration.
