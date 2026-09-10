# Entities

This document describes the entity semantic conventions.

## Namespace: `badger`

### `entity.badger`

A badger running an instrumented post-installation session.

badger.id and badger.instance.id jointly identify one post-installation runtime on one physical badger. Instrumentations MUST associate badger signals with this entity and MUST NOT duplicate identifying attributes as metric attributes.

| Property | Value |
|----------|-------|
| Stability | Development |

#### Attributes

| Attribute | Type | Role | Requirement Level | Example | Description |
|-----------|------|------|-------------------|---------|-------------|
| `badger.acquired_at` | `int` | Descriptive | Required | `1712345678` | The badger acquisition time as Unix time in seconds. Record the best available acquisition time. Freshness enforcement compares this value with the collector's session-admission time. |
| `badger.adapter.timing_class` | Enum (`bus`, `polled`) | Descriptive | Required | `polled` | The timing behavior of the badger adapter. Polled adapters smear timestamps by at least one millisecond. A polled session requires badger.timing.degraded=true on its root span. |
| `badger.adapter.type` | Enum (`duppy.cardbus`, `duppy.pci`, `sits.ethernet`, `sits.usb`) | Descriptive | Required | `duppy.cardbus` | The adapter connecting the controller to the badger. Adapter type identifies the product interface. Record timing behavior independently in badger.adapter.timing_class. The sits.usb adapter MUST use the polled timing class. |
| `badger.build_id` | `string` | Descriptive | Required | `vudu-6.6.13+ritual.4` | The identifier of the operating-system build installed on the badger. The value SHOULD identify an immutable build rather than a mutable release channel. |
| `badger.controller.name` | `string` | Descriptive | Required | `FleshGolem` | The name of the cyberspiritual controller program. Record the product name reported by the controller. |
| `badger.freshness.window` | `int` | Descriptive | Required | `21600` | The maximum allowed age in seconds when a collector admits a session. The value MUST be non-negative. On the first signal for a session, a collector enforcing freshness MUST compare its receive time with badger.acquired_at plus this window and reject the session when the receive time is later. |
| `badger.host.scheduling` | Enum (`preemptive`, `message_passing`, `cooperative`) | Descriptive | Required | `message_passing` | The scheduling discipline used by the badger host. Under cooperative scheduling, a task that does not yield cannot be distinguished from a hung host, so consumers MUST NOT present blocked time as per-task attribution. Under message passing, carry trace context on the message and mirror it into badger.traceparent. |
| `badger.id` | `string` | Identifying | Required | `badger-01J9ZQ3Y8FX6N5M4K2C7V1T0RA` | A globally unique identifier assigned to the physical badger. This identifier remains stable across installation attempts. It is entity identity and MUST NOT be copied to metric attributes. |
| `badger.instance.id` | `string` | Identifying | Required | `8f5c2f42-6ba1-4f79-89b8-c3e5b7d91a24` | An identifier for one post-installation lifetime of a physical badger. The component that starts the root `badger.session` span MUST generate this value once before the first signal for the session and retain it for the complete post-installation lifetime. It MUST distribute the same value to every observer of that runtime; observers MUST NOT generate independent values. An observer that cannot obtain both `badger.id` and `badger.instance.id` MUST NOT emit `entity.badger`.  The value MUST be unique within the associated `badger.id`; the pair identifies one post-installation runtime. A badger is consumed by a session, so this value MUST NOT be used as a metric attribute. |
| `badger.name` | `string` | Descriptive | Required | `meles-01` | The human-readable logical name of the badger. This name is not required to be globally unique; combine it with badger.namespace. |
| `badger.namespace` | `string` | Descriptive | Required | `detached-garage` | The namespace in which the badger's logical name is unique. Use a stable operational boundary such as a laboratory, garage, or fleet. The namespace and name form a human-readable identity. |
| `badger.condition.declared` | `string` | Descriptive | Recommended | `good condition` | The operator's declared condition of the badger at acquisition. Preserve this claim for audit only. Implementations MUST NOT derive decay or any other measurement from it. |
| `badger.controller.version` | `string` | Descriptive | Recommended | `4.2.1` | The version of the cyberspiritual controller program. Record the version string as reported by the controller. |

