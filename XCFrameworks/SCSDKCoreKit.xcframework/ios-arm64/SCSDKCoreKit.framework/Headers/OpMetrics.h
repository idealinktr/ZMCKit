
#import <SCSDKCoreKit/picoproto.h>

/**
 * message Timestamp
 */
PICOPROTO_VARINT(Timestamp_seconds, 1);
PICOPROTO_VARINT(Timestamp_nanos, 2);

/**
 * message CounterMetric
 */
PICOPROTO_STRING(CounterMetric_name, 1);
PICOPROTO_EMBEDDED_MESSAGE(CounterMetric_timestamp, 2);
PICOPROTO_VARINT(CounterMetric_count, 3);

/**
 * message TimerMetric
 */
PICOPROTO_STRING(TimerMetric_name, 1);
PICOPROTO_EMBEDDED_MESSAGE(TimerMetric_timestamp, 2);
PICOPROTO_VARINT(TimerMetric_latency_millis, 3);

/**
 * message LevelMetric
 */
PICOPROTO_STRING(LevelMetric_name, 1);
PICOPROTO_EMBEDDED_MESSAGE(LevelMetric_timestamp, 2);
PICOPROTO_VARINT(LevelMetric_level, 3);

/**
 * message Metrics
 */
PICOPROTO_REPEATED_EMBEDDED_MESSAGE(Metrics_counters, 1);
PICOPROTO_REPEATED_EMBEDDED_MESSAGE(Metrics_timers, 2);
PICOPROTO_REPEATED_EMBEDDED_MESSAGE(Metrics_levels, 3);
