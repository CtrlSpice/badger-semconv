# Metrics: `badger`

This document describes the `badger` metrics.

## `badger.decay`

A monotonic count of decay observed since the session started.

Start at zero and report increasing values. OTLP's `is_monotonic` is a
boolean, not a direction; the data model defines monotonic sums as
nominally increasing without loss of generality. A cumulative value may
be negative provided it is not lower than the preceding value, but
backends interpret a decrease between cumulative samples as a counter
reset. Instrumentations MUST therefore encode the negated change from a
decreasing source in the prescribed increasing direction, not emit
negative deltas. Condition must be derived from this increasing decay
value rather than encoded as a gauge. A gauge would also lose its meaning
across collector restarts, which are an expected failure mode.

Although a synchronous Counter can represent these non-negative
increments, decay is observed by polling rather than incremented at a
call site. Implementations SHOULD therefore use an ObservableCounter and
report the absolute value. Negative-valued monotonic series in other
protocols likewise require an ObservableCounter because synchronous
Counters reject negative increments.

`{decay}` is an annotation-only unit with no calibrated UCUM quantity.
Values and rates MUST NOT be compared across operator protocols. No
badger identity attributes are permitted on this metric; use the
associated badger entity.

| Property | Value |
|----------|-------|
| Instrument | counter |
| Unit | `{decay}` |
| Stability | Development |
| Entity Associations | `badger` |

## `badger.enclosure.airflow`

The volumetric airflow through the badger enclosure.

Report the latest observed airflow. Associate the metric with the badger entity instead of adding badger identity attributes.

| Property | Value |
|----------|-------|
| Instrument | gauge |
| Unit | `m3/s` |
| Stability | Development |
| Entity Associations | `badger` |

## `badger.enclosure.temperature`

The temperature inside the badger enclosure.

Report the latest observed enclosure temperature. Associate the metric with the badger entity instead of adding badger identity attributes.

| Property | Value |
|----------|-------|
| Instrument | gauge |
| Unit | `Cel` |
| Stability | Development |
| Entity Associations | `badger` |

