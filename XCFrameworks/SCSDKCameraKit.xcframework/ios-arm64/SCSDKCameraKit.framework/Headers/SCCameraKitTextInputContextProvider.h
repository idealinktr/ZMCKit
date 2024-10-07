//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(TextInputKeyboardAccessoryProvider)
/// Protocol for representing a text input view on-screen for lenses that request it.
@protocol SCCameraKitTextInputKeyboardAccessoryProvider <NSObject>

/// The view to show on top of the keyboard.
@property (strong, nonatomic, readonly) UIView *accessoryView;

/// The text view associated with the input being provided.
@property (strong, nonatomic, readonly) UITextView *textView;

/// Placeholder text to show in the text view before the user has input any text. May be empty.
@property (copy, nonatomic, nullable) NSString *placeholderText;

/// The maximum height the accessoryView can grow to. This will be considered when setting the safe area for the lens.
@property (assign, nonatomic, readonly) CGFloat maximumHeight;

@end

NS_SWIFT_NAME(TextInputContextProvider)
/// Protocol to provide keyboard input data to lenses.
@protocol SCCameraKitTextInputContextProvider <NSObject>

/// A parent view in which to embed a text view. Unless reconfigured by providing a keyboardAccessoryProvider, this text
/// view will not be visible to the user.
@property (weak, nonatomic, readonly) UIView *parentView;

/// Object which describes a user-visible input view for text input. Typically, this is a styled text view that appears
/// above the keyboard interface.
@property (strong, nonatomic, readonly, nullable) id<SCCameraKitTextInputKeyboardAccessoryProvider>
    keyboardAccessoryProvider;

@end

NS_ASSUME_NONNULL_END
