//  Copyright Snap Inc. All rights reserved.
//  CameraKit

#import <UIKit/UIKit.h>

@protocol SCCameraKitLens;
@protocol SCCameraKitLensMediaPickerProvider;

NS_ASSUME_NONNULL_BEGIN

@protocol SCCameraKitLensMediaPickerAsset;
@protocol SCCameraKitLensMediaPickerProviderUIDelegate;
@protocol SCCameraKitLensMediaPickerProviderMediaApplicationDelegate;
@protocol SCCameraKitLensMediaPickerAsset;

NS_SWIFT_NAME(LensMediaPickerProviderAllowedMediaType)
typedef NS_OPTIONS(NSInteger, SCCameraKitLensMediaPickerProviderAllowedMediaType) {
    // The current lens has not provided any specific indication of the type of picker that should be shown.
    SCCameraKitLensMediaPickerProviderAllowedMediaTypeNoneSpecified = 0,

    // Images should be shown in the picker.
    SCCameraKitLensMediaPickerProviderAllowedMediaTypeImage = 1 << 0,

    // If LensMediaPickerProviderAllowedMediaTypeImage is specified, the provider should ONLY show images with a
    // person's face in them
    // If LensMediaPickerProviderAllowedMediaTypeImage is not specified, this option is ignored.
    SCCameraKitLensMediaPickerProviderAllowedMediaTypeImageCroppedToFace = 1 << 1,

    // Videos should be shown in the picker
    SCCameraKitLensMediaPickerProviderAllowedMediaTypeVideo = 1 << 2,
};

NS_SWIFT_NAME(LensMediaPickerProvider)
@protocol SCCameraKitLensMediaPickerProvider <NSObject>

/// A delegate that must be notified when loadAndApplyOriginalMediaFromAsset: finishes loading an original asset.
/// @warning: DO NOT set this delegate manually. CameraKit will set this property appropriately.
@property (weak, nonatomic) id<SCCameraKitLensMediaPickerProviderMediaApplicationDelegate> mediaApplicationDelegate;

/// A delegate that will be notified when picker-related UI should be shown or hidden.
@property (weak, nonatomic) id<SCCameraKitLensMediaPickerProviderUIDelegate> uiDelegate;

/// The number of assets that have been fetched and may be displayed by the picker UI.
@property (readonly, nonatomic, assign) NSInteger fetchedAssetCount;

/// Whether or not the data provider has more assets available to fetch.
@property (readonly, nonatomic, assign) BOOL hasMoreAssetsToFetch;

/// Fetches a new batch of assets.
/// @param batchSize How many items to fetch. A provider may return less than this if it exhausts available assets
/// without reaching the desired batch size
/// @param queue a dispatch queue to receive callbacks on
/// @param completion a completion block to be called when the fetch has completed
- (void)fetchNextAssetBatchOfSize:(NSInteger)batchSize
                            queue:(dispatch_queue_t)queue
                       completion:(void (^)(NSArray<id<SCCameraKitLensMediaPickerAsset>> *))completion
    NS_SWIFT_NAME(fetchNextAssetBatch(size:queue:completion:));

/// Retrieves a fetched asset at a given index.
/// @param index the index to fetch.
- (id<SCCameraKitLensMediaPickerAsset>)fetchedAssetAtIndex:(NSInteger)index NS_SWIFT_NAME(fetchedAsset(at:));

/// Loads the full resolution backing asset of a specified asset and applies it to lenses.
/// @param asset the asset to load and apply
/// @param completion a completion block called when application is complete
/// @note Implementors of this method MUST call the appropriate method on the uiDelegate when the loading is completed
/// in order for the lens to succesfully apply the media.
- (void)loadAndApplyOriginalMediaFromAsset:(id<SCCameraKitLensMediaPickerAsset>)asset
                                completion:(nullable void (^)(void))completion
    NS_SWIFT_NAME(loadAndApplyOriginalMedia(from:completion:));

/// Invalidates and resets internal state of the provider with a newly specified allowed media type option set.
/// @param assetType The asset types to allow in results.
- (void)reconfigureWithAllowedTypes:(SCCameraKitLensMediaPickerProviderAllowedMediaType)assetType;

@end

/// A default implementation of SCCameraKitLensMediaPickerProvider that uses the user's photos library.
NS_SWIFT_NAME(LensMediaPickerProviderPhotoLibrary)
@interface SCCameraKitLensMediaPickerProviderPhotoLibrary : NSObject <SCCameraKitLensMediaPickerProvider>

/// Initializes the photo library provider.
/// @param defaultAssetTypes a bitmask specifying which types of assets the picker will display when the lens does not
/// indicate interest in a specific type of asset. MUST not be LensMediaPickerProviderAllowedMediaTypeNoneSpecified.
- (instancetype)initWithDefaultAssetTypes:(SCCameraKitLensMediaPickerProviderAllowedMediaType)defaultAssetTypes;

/// Use designated init or convenience init
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_SWIFT_NAME(LensMediaPickerAssetType)
typedef NS_ENUM(NSInteger, SCCameraKitLensMediaPickerAssetType) {
    SCCameraKitLensMediaPickerAssetTypeImage,
    SCCameraKitLensMediaPickerAssetTypeVideo,
};

NS_SWIFT_NAME(LensMediaPickerProviderAsset)
/// An asset provided by the picker. May be backed by a PHAsset, or an app's own custom media type.
@protocol SCCameraKitLensMediaPickerAsset <NSObject>

/// A unique identifier for the asset.
@property (readonly, nonatomic, copy) NSString *identifier;

/// Whether the asset is an image or video.
@property (readonly, nonatomic, assign) SCCameraKitLensMediaPickerAssetType type;

/// If the asset is a video, the length of the video in seconds. Otherwise 0.
@property (readonly, nonatomic, assign) NSTimeInterval duration;

/// A thumbnail for the image or video. For images, this will be cropped to show any detected faces.
@property (readonly, nonatomic, strong) UIImage *previewImage;

@end

/// Metadata for a media asset
typedef struct {
    // If the asset is an image with a face present, a rect specifying the position of the face. Otherwise CGRectZero
    CGRect faceRect;
} SCCameraKitLensMediaPickerAssetMetadata;

NS_SWIFT_NAME(LensMediaPickerProviderUIDelegate)
/// Delegate responsible for handling UI events related to the provider, such as showing/hiding a picker.
@protocol SCCameraKitLensMediaPickerProviderUIDelegate <NSObject>

/// Requests media picker UI be displayed.
/// @param provider the provider sending the request
- (void)mediaPickerProviderRequestedUIPresentation:(id<SCCameraKitLensMediaPickerProvider>)provider;

/// Requests media picker UI be dismissed.
/// @param provider the provider sending the request
- (void)mediaPickerProviderRequestedUIDismissal:(id<SCCameraKitLensMediaPickerProvider>)provider;

@end

NS_SWIFT_NAME(LensMediaPickerProviderMediaApplicationDelegate)
/// Delegate responsible for applying media to a lens. This should not be implemented directly.
/// @note If you create a custom provider, you'll need to call the methods here from your provider. See notes on
/// provider.uiDelegate for more details.
@protocol SCCameraKitLensMediaPickerProviderMediaApplicationDelegate <NSObject>

/// Notifies lenses that the media picker provider has loaded the full resolution version of an asset and is ready for
/// it to be applied.
/// @param provider the provider sending the reequest
/// @param asset the asset provided by the provider
/// @param url the URL to a full-resolution image or video for lenses to apply
/// @param metadata any metadata associated with the asset
- (void)mediaPickerProvider:(id<SCCameraKitLensMediaPickerProvider>)provider
    requestedApplicationOfOriginalAssets:(id<SCCameraKitLensMediaPickerAsset>)asset
                                     url:(NSURL *)url
                                metadata:(SCCameraKitLensMediaPickerAssetMetadata)metadata;

@end

NS_ASSUME_NONNULL_END
