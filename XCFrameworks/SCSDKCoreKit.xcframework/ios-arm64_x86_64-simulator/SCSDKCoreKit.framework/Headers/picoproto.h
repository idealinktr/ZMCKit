/**
 * copied from github.com/snapchat/tools/security/picoproto and changes must go upstream first
 * picoproto - lightweight proto buffer encoder library.
 *
 * Lightweight Google protocol buffer encoder optimized for reduced code size.
 *
 * It implements a subset of protocol buffer wire format with the follow limitations:
 * - Valid types: uint64, fixed64, fixed32, double, string, nested message, repeated fields
 * - No enums, although those can be emulated using int64 fields.
 * - Limited to 128KB output (configurable)
 *
 * TODO:
 * - Enums
 * - C header file generator for .proto files
 * - Prefix all external method with picoproto_ to avoid polluting the symbol table.
 * - More tests for error or exceptional conditions (ie: larger than  2KB output)
 * - Implement byte arrays, which are already used by the string type but not exposed.
 * - Implement signed integers
 *
 * Example usage for the following protocol buffer definition:
 *
 * message request {
 *   optional string method = 1;
 *   optional string path = 1;
 *   optional int64 count = 3;
 * }
 *
 * // Writing a request to stdout:
 *
 * PICOPROTO_STRING(method, 1)
 * PICOPROTO_STRING(path, 2)
 * PICOPROTO_VARINT(count, 3)
 *
 * picoproto_ctx *proto = picoproto_new();
 *
 * write_method(proto, "GET");
 * write_path(proto, "/counter");
 * write_count(proto, 5);
 *
 * write(STDOUT, proto->buffer, proto->len);
 *
 * picoproto_free(proto)
 *
 * Reference:
 * https://developers.google.com/protocol-buffers/docs/encoding
 *
 * Author: Filipe Almeida <filipe.almeida@snapchat.com>
 */

#import "picoproto_ctx.h"

#include <stdlib.h>

#define PICOPROTO_STRING(field_name, field)                                                                            \
    __unused static int picoproto_write_##field_name(picoproto_ctx* proto, const char* value) {                        \
        return picoproto_write_string_field(proto, field, value);                                                      \
    }

#define PICOPROTO_REPEATED_STRING(field_name, field)                                                                   \
    static int picoproto_write_##field_name(picoproto_ctx* proto, const char* value[], unsigned int count) {           \
        return picoproto_write_repeated_string_field(proto, field, value, count);                                      \
    }

#define PICOPROTO_EMBEDDED_MESSAGE(field_name, field)                                                                  \
    __unused static int picoproto_write_##field_name(picoproto_ctx* proto, picoproto_ctx* value,                       \
                                                     int free_embedded_messages_src) {                                 \
        return picoproto_write_embedded_message_field(proto, field, value, free_embedded_messages_src);                \
    }

#define PICOPROTO_REPEATED_EMBEDDED_MESSAGE(field_name, field)                                                         \
    __unused static int picoproto_write_##field_name(picoproto_ctx* proto, picoproto_ctx** value, size_t count,        \
                                                     int free_embedded_messages_src) {                                 \
        return picoproto_write_repeated_embedded_message_field(proto, field, value, count,                             \
                                                               free_embedded_messages_src);                            \
    }

#define PICOPROTO_FIXED32(field_name, field)                                                                           \
    static int picoproto_write_##field_name(picoproto_ctx* proto, unsigned long long value) {                          \
        return picoproto_write_fixed32_field(proto, field, value);                                                     \
    }

#define PICOPROTO_FIXED64(field_name, field)                                                                           \
    static int picoproto_write_##field_name(picoproto_ctx* proto, unsigned long long value) {                          \
        return picoproto_write_fixed64_field(proto, field, value);                                                     \
    }

#define PICOPROTO_VARINT(field_name, field)                                                                            \
    __unused static int picoproto_write_##field_name(picoproto_ctx* proto, unsigned long long value) {                 \
        return picoproto_write_varint_field(proto, field, value);                                                      \
    }

#define PICOPROTO_REPEATED_VARINT(field_name, field)                                                                   \
    __unused static int picoproto_write_##field_name(picoproto_ctx* proto, unsigned long long value[], size_t count) { \
        return picoproto_write_repeated_varint_field(proto, field, value, count);                                      \
    }

#define PICOPROTO_DOUBLE(field_name, field)                                                                            \
    __unused static int picoproto_write_##field_name(picoproto_ctx* proto, double value) {                             \
        return picoproto_write_double_field(proto, field, value);                                                      \
    }

/*
 * Error codes.
 */
typedef enum {
    PICOPROTO_OK = 0,
    PICOPROTO_INVALID_PARAMS,
    PICOPROTO_BAD_ENCODING,
    PICOPROTO_MAX_SIZE_REACHED,
    PICOPROTO_NOT_FOUND
} picoproto_status_t;

/**
 * Allocate a new instance of the pico proto serializer.
 */
picoproto_ctx* picoproto_new(const char name[]);

picoproto_ctx* picoproto_new_from_bytes(const char name[], const char* bytes, size_t len);

double convertUnsignedLongLongToDouble(long long x);

/**
 * Dealocate an instance of the pico proto serializer.
 */
void picoproto_free(picoproto_ctx* ctx);

/*
 * Append a string field as a variable length buffer
 */
int picoproto_write_string_field(picoproto_ctx* proto, unsigned long long field, const char* string);

/*
 * Append a string list field
 */
int picoproto_write_repeated_string_field(picoproto_ctx* proto, unsigned long long field, const char* strings[],
                                          size_t count);

/**
 * Embed a protobuf meessage in another protobuf message.
 * @param proto message to embed \p embedded_message in
 * @param field field number
 * @param embedded_message message to embed in \p proto
 * @param free_embedde_message_src whether or not to free \p embedded_message after embedding
 * @return 0 if success
 */
int picoproto_write_embedded_message_field(picoproto_ctx* proto, unsigned long long field,
                                           picoproto_ctx* embedded_message, int free_embedde_message_src);

/**
 * Embed a list of protobuf messages in another protobuf message as a repeated field.
 * @param proto message to embed \p embedded_message in
 * @param field field number
 * @param embedded_messages message to embed in \p proto
 * @param count number of messages in \p in embedded_messages
 * @param free_embedded_messages_src whether or not to free \p embedded_message after embedding
 * @return 0 if success
 */
int picoproto_write_repeated_embedded_message_field(picoproto_ctx* proto, unsigned long long field,
                                                    picoproto_ctx** embedded_messages, size_t count,
                                                    int free_embedded_messages_src);

/*
 * Append a 32bit fixed size unsigned integer to the buffer.
 */
int picoproto_write_fixed32_field(picoproto_ctx* proto, unsigned long long field, unsigned long value);

/*
 * Append a 64bit fixed size unsigned integer to the buffer.
 */
int picoproto_write_fixed64_field(picoproto_ctx* proto, unsigned long long field, unsigned long long value);

/*
 * Append a variable sized unsigned integer to the buffer.
 */
int picoproto_write_varint_field(picoproto_ctx* proto, unsigned long long field, unsigned long long value);

/*
 * Append a list of variable sized unsigned integers to the buffer.
 */
int picoproto_write_repeated_varint_field(picoproto_ctx* proto, unsigned long long field, unsigned long long value[],
                                          size_t count);

/*
 * Append a double to the buffer.
 */
int picoproto_write_double_field(picoproto_ctx* proto, unsigned long long field, double value);

/*
 * Read the first varint field of the protobuf.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     value: Output variable where the value read will be stored.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_varint_field(const picoproto_ctx* proto, const uint64_t field_id, uint64_t* value);

/*
 * Read the first varint field of the protobuf after |start|.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     start: Position at which to start searching for the varint.
 *     value: Output variable where the value read will be stored.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_next_varint_field(const picoproto_ctx* proto, const uint64_t field_id, size_t* start,
                                     uint64_t* value);

/*
 * Read the first fixed32 field of the protobuf.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     value: Output variable where the value read will be stored.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_fixed32_field(const picoproto_ctx* proto, const uint64_t field_id, uint32_t* value);

/*
 * Read the first fixed32 field of the protobuf after |start|.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     start: Position at which to start searching for the fixed32.
 *     value: Output variable where the value read will be stored.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_next_fixed32_field(const picoproto_ctx* proto, const uint64_t field_id, size_t* start,
                                      uint32_t* value);

/*
 * Read the first fixed64 field of the protobuf.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     value: Output variable where the value read will be stored.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_fixed64_field(const picoproto_ctx* proto, const uint64_t field_id, uint64_t* value);

/*
 * Read the first fixed64 field of the protobuf after |start|.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     start: Position at which to start searching for the fixed64.
 *     value: Output variable where the value read will be stored.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_next_fixed64_field(const picoproto_ctx* proto, const uint64_t field_id, size_t* start,
                                      uint64_t* value);

/*
 * Read the first string field of the protobuf.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     output: Output variable where the char buffer address will be stored. The
 *             caller is responsible for freeing the string.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_string_field(const picoproto_ctx* proto, const uint64_t field_id, char** output);

/*
 * Read the first string field of the protobuf after |start|.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     start: Position at which to start searching for the string.
 *     output: Output variable where the char buffer address will be stored. The
 *             caller is responsible for freeing the string.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_next_string_field(const picoproto_ctx* proto, const uint64_t field_id, size_t* start, char** output);

/*
 * Read the first message field of the protobuf.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     output: Output protobuf where the message will be stored.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_message_field(const picoproto_ctx* proto, const uint64_t field_id, picoproto_ctx* output);

/*
 * Read the first message field of the protobuf after |start|.
 *
 * Args:
 *     proto: The proto object to read from.
 *     field_id: Id of the field to find.
 *     start: Position at which to start searching for the message.
 *     output: Output protobuf where the message will be stored.
 *
 * Returns:
 *     PICOPROTO_OK on success, error code otherwise.
 */
int picoproto_read_next_message_field(const picoproto_ctx* proto, const uint64_t field_id, size_t* start,
                                      picoproto_ctx* output);
