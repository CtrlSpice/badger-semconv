# Spans: `badger`

This document describes the `badger` spans.

## `span.badger.session`

The post-installation lifetime of an instrumented badger.

This is the root span and SHOULD be named `badger.session`. Start it after installation completes. Make the sampling decision when the session starts; tail sampling is not suitable because the badger is consumed by the session.

| Property | Value |
|----------|-------|
| Span Kind | internal |
| Stability | Development |
| Entity Associations | `badger` |

### Attributes

| Attribute | Type | Requirement Level | Sampling Relevant | Example | Description |
|-----------|------|-------------------|-------------------|---------|-------------|
| `badger.prelude.timestamp_source` | Enum (`measured`, `claimed`) | Required | No | `measured` | The provenance of the acquisition and session-start timestamps. Record the source even when badger.prelude.duration is omitted. Claimed timestamps make an emitted duration a lower bound of unknown tightness rather than a measured duration. |
| `badger.session.id` | `string` | Required | No | `27a84bd4-2b52-45d5-a970-5f23f2baf3cd` | A unique identifier for the badger session. Generate this identifier before the sampling decision and retain it for the complete post-installation lifetime. |
| `badger.traceparent` | `string` | Required | No | `00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01` | The W3C traceparent value physically carried by the badger. This attribute is an audit record of the value placed on the badger, not a replacement for propagated span context. Recording it permits comparison across hosts and message-passing controllers. It MUST NOT be used to assign a parent to the root badger.session span. |
| `badger.timing.degraded` | `boolean` | Conditionally Required - If `badger.adapter.timing_class` is `polled`. | Yes | `true` | Whether adapter polling degraded the session's timing fidelity. This value MUST be true when badger.adapter.timing_class is polled. Consumers MUST refuse to render profiles from a degraded session. |
| `badger.tracestate` | `string` | Conditionally Required - If vendor state is physically present on the badger. | No | `vendorname=opaqueValue` | The W3C tracestate value physically carried by the badger. Record the exact vendor state carried with badger.traceparent. Omit this attribute when no vendor state is present. |
| `badger.prelude.duration` | `int` | Recommended | No | `1800` | The seconds from badger acquisition to session start. The prelude occurs before instrumentation exists. When badger.prelude.timestamp_source is claimed, consumers MUST treat this duration as a lower bound of unknown tightness. |

