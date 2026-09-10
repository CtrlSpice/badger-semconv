# Profiles: `badger`

This document describes conventions for profiling the runtime installed on a
badger.

**Important:** Weaver v0.26.1 does not model Profiles as a first-class
semantic-convention signal. The groups below are `attribute_group` definitions
that Weaver validates. Their OTLP attachment locations are normative prose and
are not enforced by Weaver.

These conventions target the Alpha [OpenTelemetry Profiles data model] and the
Development [OpenTelemetry Profiles semantic conventions].

## Signal model

A badger profile describes running code during the post-installation lifetime.
Its interval MUST begin no earlier than the root `badger.session` span and MUST
end no later than that span.

Place the attributes of the `badger` entity in
`ResourceProfiles.resource.attributes` and reference them from an `EntityRef`
in `ResourceProfiles.resource.entity_refs`. The reference MUST use `badger` as
its type and MUST list every identifying attribute declared by `entity.badger`
in `id_keys`. It SHOULD list each present descriptive attribute in
`description_keys`. Every listed key MUST exist in the containing Resource's
attributes. Identifying attributes MUST NOT be copied to `Profile` or `Sample`
attributes. `InstrumentationScope` SHOULD identify the profiling implementation.

Use native OTLP fields rather than custom attributes for profile identity,
timing, sample and period types, values, timestamps, stacks, and trace
correlation:

| Concept | OTLP representation |
|---------|---------------------|
| Profile identity | `Profile.profile_id` |
| Profile interval | `Profile.time_unix_nano` and `Profile.duration_nano` |
| Measured value and unit | `Profile.sample_type` |
| Sampling period | `Profile.period_type` and `Profile.period` |
| Values and observation times | `Sample.values` and `Sample.timestamps_unix_nano` |
| Stack | `Sample.stack_index` and the Profiles dictionary |
| Trace correlation | `Sample.link_index` and the referenced `Link` |

When a sample corresponds to an active span, producers SHOULD use the native
`Link` to record its trace and span identifiers. `badger.traceparent` remains an
audit copy of physically carried context and MUST NOT replace that link.

Executable build identifiers belong on `Mapping` as standard
`process.executable.build_id.*` attributes. `badger.build_id` identifies the
operating-system build installed on the entity and MUST NOT be used as an
executable mapping identifier.

## `profile.badger`

Attributes governing interpretation of a profile collected from a badger.

This is an attribute applicability group, not a first-class Profiles
signal definition. Weaver v0.26.1 does not define a `profile` group type.

Attach these attributes to the OTLP `Profile` through
`Profile.attribute_indices`. Do not repeat them on individual `Sample`
messages.

`badger.timing.degraded` MUST be true when the associated badger uses a
polled adapter and MUST agree with the root `badger.session` span when both
values are present. Consumers MUST refuse to render a degraded profile.

`badger.host.scheduling` MUST equal the associated badger entity value.
Under cooperative scheduling, consumers MUST NOT present blocked time as
per-task attribution.

### Attributes

| Attribute | Type | Requirement Level | Example | Description |
|-----------|------|-------------------|---------|-------------|
| `badger.host.scheduling` | Enum (`preemptive`, `message_passing`, `cooperative`) | Conditionally Required - If the profile measures blocked or off-CPU time. | `message_passing` | The scheduling discipline used by the badger host. Under cooperative scheduling, a task that does not yield cannot be distinguished from a hung host, so consumers MUST NOT present blocked time as per-task attribution. Under message passing, carry trace context on the message and mirror it into badger.traceparent. |
| `badger.timing.degraded` | `boolean` | Conditionally Required - If `badger.adapter.timing_class` is `polled`. | `true` | Whether adapter polling degraded the session's timing fidelity. This value MUST be true when badger.adapter.timing_class is polled. Consumers MUST refuse to render profiles from a degraded session. |

## `profile.badger.sample`

Attributes describing individual profile samples from a badger.

This is an attribute applicability group, not a first-class Profiles
signal definition. Attach these attributes to the OTLP `Sample` through
`Sample.attribute_indices`; Weaver v0.26.1 does not enforce this placement.

When collecting `badger.control.state`, producers MUST partition
observations by directly reported state before forming OTLP `Sample`
messages. Samples representing known-state observations MUST carry the
corresponding value; samples representing unknown-state observations
MUST omit the attribute. Observations with the same
`{stack_index, set_of(attribute_indices), link_index}` identity SHOULD be
combined by appending values and timestamps, including when a state recurs
after another state.

### Attributes

| Attribute | Type | Requirement Level | Example | Description |
|-----------|------|-------------------|---------|-------------|
| `badger.control.state` | Enum (`controlled`, `uncontrolled`) | Recommended - If a definitive per-observation control-status report is available. | `controlled` | The reported control state of the badger for one profile observation. Record this attribute only from a definitive control-status report emitted by the configured controller for the same observation. Conforming producers MUST emit only `controlled` or `uncontrolled` and MUST NOT infer either value from controller configuration, process presence or absence, or an earlier observation. Omit the attribute when no definitive report exists. Consumers MUST treat every other value as unknown. |

[OpenTelemetry Profiles data model]: https://github.com/open-telemetry/opentelemetry-specification/blob/v1.60.0/specification/profiles/data-format.md
[OpenTelemetry Profiles semantic conventions]: https://github.com/open-telemetry/semantic-conventions/blob/v1.44.0/docs/general/profiles.md
