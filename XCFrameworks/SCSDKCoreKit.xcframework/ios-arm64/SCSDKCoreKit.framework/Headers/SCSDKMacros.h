//
//  SCSDKMacros.h
//  SCSDKCoreKit
//

// @phantom-linter off define

#ifndef Snapchat_SCSDKMacros_h
#define Snapchat_SCSDKMacros_h

/*
 * Prevents the C++ compiler from mangling C function names.
 */
#ifdef __cplusplus
#define SCSDK_EXTERN_C_BEGIN extern "C" {
#define SCSDK_EXTERN_C_END }
#else
#define SCSDK_EXTERN_C_BEGIN
#define SCSDK_EXTERN_C_END
#endif

/*
 * Forces the a function to always be inlined if possible. For example, it can't inline a function imported from a
 * header, where the function's implementation is not in that header.
 * In general, prefer inline over this if the goal is to make the function call faster, and only use this in special
 * cases. For example, we use this in SCAppEnvironment to ensure dead code stripping.
 */
#define SCSDK_ALWAYS_INLINE __inline__ __attribute__((__always_inline__))

/*
 * Follows the idea of the `guard` statement in Swift.
 * Early exits if a condition is not met.
 */
#define SCSDK_GUARD(condition)                                                                                         \
    if (condition) {                                                                                                   \
    }
#define SCSDK_GUARD_ELSE_RUN_AND_RETURN_VALUE(condition, statement, value)                                             \
    SCSDK_GUARD(condition) else {                                                                                      \
        statement;                                                                                                     \
        return value;                                                                                                  \
    }
#define SCSDK_GUARD_ELSE_RUN_AND_RETURN(condition, statement)                                                          \
    SCSDK_GUARD_ELSE_RUN_AND_RETURN_VALUE(condition, statement, )
#define SCSDK_GUARD_ELSE_RETURN_VALUE(condition, value) SCSDK_GUARD_ELSE_RUN_AND_RETURN_VALUE(condition, , value)
#define SCSDK_GUARD_ELSE_RETURN(condition) SCSDK_GUARD_ELSE_RUN_AND_RETURN_VALUE(condition, , )

#endif

// @phantom-linter on define
