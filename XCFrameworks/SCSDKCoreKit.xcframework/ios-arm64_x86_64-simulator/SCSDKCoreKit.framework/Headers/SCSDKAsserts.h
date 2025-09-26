//
//  SCAssertWrapper.h
//  SCSDKCoreKit
//

#import <Foundation/Foundation.h>

// @phantom-linter off define
// @phantom-linter off nsassert
#if !defined(SCAssert)
#if !defined(NS_BLOCK_ASSERTIONS)
#define SCAssert(condition, desc, ...) NSAssert((condition), @"ASSERT-" desc, ##__VA_ARGS__)
static inline BOOL SCAssertEnabled(void)
{
    return YES;
}
// Using the new API for dispatch_assert_queue.
#define SCAssertQueuePerformer(performer)                                                                              \
    do {                                                                                                               \
        if (&dispatch_assert_queue) {                                                                                  \
            dispatch_assert_queue(performer.queue);                                                                    \
        }                                                                                                              \
    } while (0)
#else
static inline BOOL SCAssertEnabled(void)
{
    return NO;
}

// No log otherwise
#define SCAssert(condition, desc, ...)
#define SCAssertQueuePerformer(performer)
#endif
#endif

#define SCAssertFail(desc, ...) SCAssert(NO, desc, ##__VA_ARGS__)
#define SCAssertTrue(condition) SCAssert((condition), @ #condition)

#define SCAssertClass(INSTANCE, CLASSNAME)                                                                             \
    SCAssert([INSTANCE isKindOfClass:[CLASSNAME class]],                                                               \
             @"Expecting an instance of class: %@, but the provided instance is of class: %@",                         \
             NSStringFromClass([CLASSNAME class]), NSStringFromClass([INSTANCE class]))

#define SCParameterAssert(condition) SCAssert((condition), @"Invalid parameter not satisfying: %@", @ #condition)

#define SCAssertEqualObjects(param1, param2)                                                                           \
    SCAssert([@(param1) isEqual:@(param2)], @"Error: %@ and %@ are not equal.", @(param1), @(param2))

#define SC_STATIC_ASSERT(condition, msg) typedef char _static_assert_##msg[((condition) ? 1 : -1)]

#define SCAssertMainThread() SCAssert([NSThread isMainThread], @"Error: Observed values changed off main thread.")

#define SCAssertNotMainThread() SCAssert(![NSThread isMainThread], @"Error: Should be called off the main thread.")

#define SCAssertPerformer(performer)                                                                                   \
    SCAssert([performer isCurrentPerformer], @"Error: Action must be performed on class' performer")

#define SCAssertImplementedBySubclass()                                                                                \
    SCAssert(NO, @"Error: %@ should be implemented by subclass.", NSStringFromSelector(_cmd))

// @phantom-linter on define
// @phantom-linter on nsassert
