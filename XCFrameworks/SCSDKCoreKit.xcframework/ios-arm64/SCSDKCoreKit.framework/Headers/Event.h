
#import <SCSDKCoreKit/picoproto.h>

/**
 * message ServerEventBatch
 */
PICOPROTO_DOUBLE(ServerEventBatch_server_upload_ts, 1);
PICOPROTO_VARINT(ServerEventBatch_max_sequence_id_on_instance, 3);
PICOPROTO_REPEATED_EMBEDDED_MESSAGE(ServerEventBatch_server_events, 4);

/**
 * message BitmojiKitSearchTerm
 */
PICOPROTO_VARINT(BitmojiKitSearchTerm_category, 1); // enum BitmojiKitSearchCategory
PICOPROTO_STRING(BitmojiKitSearchTerm_value, 2);

typedef enum {
    BitmojiKitPermissionUpdateStatusUnknownBitmojiKitPermissionUpdateStatus = 0,
    BitmojiKitPermissionUpdateStatusBitmojiPermissionOn = 1,
    BitmojiKitPermissionUpdateStatusBitmojiPermissionOff = 2,
    BitmojiKitPermissionUpdateStatusBitmojiReauthError = 3,
} BitmojiKitPermissionUpdateStatus;

typedef enum {
    BitmojiKitSearchBarConfigurationSearchBarVisible = 0,
    BitmojiKitSearchBarConfigurationSearchBarHidden = 1,
} BitmojiKitSearchBarConfiguration;

typedef enum {
    BitmojiKitSearchCategoryUnknownBitmojiKitSearchCategory = 0,
    BitmojiKitSearchCategoryText = 1,
    BitmojiKitSearchCategoryAutocomplete = 2,
    BitmojiKitSearchCategoryProgrammedPills = 3,
    BitmojiKitSearchCategorySeedSearch = 4,
} BitmojiKitSearchCategory;

typedef enum {
    BitmojiKitShareCategoryUnknownBitmojiKitShareCategory = 0,
    BitmojiKitShareCategoryPopular = 1,
    BitmojiKitShareCategorySearch = 2,
} BitmojiKitShareCategory;

typedef enum {
    BitmojiKitStickerPickerViewUnknownBitmojiKitPickerView = 0,
    BitmojiKitStickerPickerViewStickerPicker = 1,
    BitmojiKitStickerPickerViewCreateAvatar = 2,
    BitmojiKitStickerPickerViewLinkAccount = 3,
    BitmojiKitStickerPickerViewNotAuthorized = 4,
    BitmojiKitStickerPickerViewErrorView = 5,
} BitmojiKitStickerPickerView;

typedef enum {
    BitmojiKitTagSelectorConfigurationTagSelectorVisible = 0,
    BitmojiKitTagSelectorConfigurationTagSelectorHidden = 1,
} BitmojiKitTagSelectorConfiguration;

typedef enum {
    KitTypeUnknownKitType = 0,
    KitTypeBitmojiKit = 1,
    KitTypeCameraKit = 2,
    KitTypeCreativeKit = 3,
    KitTypeLoginKit = 4,
    KitTypeStoryKit = 5,
    KitTypeShopKit = 6,
} KitType;

typedef enum { SnapKitAuthFeaturesProfileLink = 0 } SnapKitAuthFeatures;

typedef enum {
    KitDeepLinkSourceTypeKitAppOpenNone = 0,
    KitDeepLinkSourceTypeKitAppOpenLoginKit = 1,
} KitDeepLinkSourceType;

/**
 * message ServerEventData
 */
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_creative_kit_share_start, 28);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_creative_kit_share_complete, 29);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_sticker_picker_open, 30);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_sticker_picker_close, 31);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_share, 32);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_search, 33);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_snapchat_link_tap, 34);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_snapchat_link_success, 35);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_create_avatar_tap, 36);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_login_kit_auth_start, 37);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_login_kit_auth_complete, 38);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_permission_update, 39);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_sticker_picker_mount, 73);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_kit_heartbeat, 76);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_bitmoji_kit_preview_icon_change, 77);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_creative_kit_share_button_visible, 133);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_skate_event, 232);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_kit_app_application_open, 442);
PICOPROTO_EMBEDDED_MESSAGE(ServerEventData_kit_app_application_close, 443);

/**
 * message ServerEvent
 */
PICOPROTO_STRING(ServerEvent_event_name, 1);
PICOPROTO_STRING(ServerEvent_request_id, 2);
PICOPROTO_DOUBLE(ServerEvent_server_ts, 3);
PICOPROTO_STRING(ServerEvent_user_id, 4);
PICOPROTO_STRING(ServerEvent_user_agent, 5);
PICOPROTO_STRING(ServerEvent_country, 6);
PICOPROTO_STRING(ServerEvent_city, 7);
PICOPROTO_STRING(ServerEvent_region, 8);
PICOPROTO_STRING(ServerEvent_event_id, 9);
PICOPROTO_STRING(ServerEvent_instance_id, 10);
PICOPROTO_VARINT(ServerEvent_sequence_id, 11);
PICOPROTO_STRING(ServerEvent_os_type, 12);
PICOPROTO_STRING(ServerEvent_os_version, 13);
PICOPROTO_STRING(ServerEvent_app_version, 14);
PICOPROTO_STRING(ServerEvent_app_build, 15);
PICOPROTO_EMBEDDED_MESSAGE(ServerEvent_event_data, 100);

/**
 * message KitEventBase
 */
PICOPROTO_STRING(KitEventBase_oauth_client_id, 1);
PICOPROTO_STRING(KitEventBase_locale, 2);
PICOPROTO_STRING(KitEventBase_kit_user_agent, 3);
PICOPROTO_STRING(KitEventBase_ip_address, 4);
PICOPROTO_STRING(KitEventBase_os_minor_version, 5);
PICOPROTO_VARINT(KitEventBase_kit_variant, 6); // enum KitType
PICOPROTO_STRING(KitEventBase_kit_variant_version, 7);
PICOPROTO_VARINT(KitEventBase_kit_client_timestamp_millis, 8);
PICOPROTO_VARINT(KitEventBase_client_sequence_id, 9);
PICOPROTO_VARINT(KitEventBase_max_client_sequence_id_on_instance, 10);
PICOPROTO_STRING(KitEventBase_target_architecture, 11);
PICOPROTO_VARINT(KitEventBase_running_with_debugger_attached, 12);
PICOPROTO_VARINT(KitEventBase_running_in_tests, 13);
PICOPROTO_VARINT(KitEventBase_running_in_simulator, 14);
PICOPROTO_VARINT(KitEventBase_is_app_prerelease, 15);
PICOPROTO_VARINT(KitEventBase_kit_plugin_type, 16);

/**
 * message BitmojiKitCreateAvatarTap
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitCreateAvatarTap_bitmoji_kit_event_base, 1);

/**
 * message BitmojiKitEventBase
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitEventBase_kit_event_base, 1);
PICOPROTO_STRING(BitmojiKitEventBase_sticker_picker_session_id, 2);

/**
 * message BitmojiKitPermissionUpdate
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitPermissionUpdate_bitmoji_kit_event_base, 1);
PICOPROTO_VARINT(BitmojiKitPermissionUpdate_status, 2); // enum BitmojiKitPermissionUpdateStatus

/**
 * message BitmojiKitPreviewIconChange
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitPreviewIconChange_bitmoji_kit_event_base, 1);
PICOPROTO_STRING(BitmojiKitPreviewIconChange_preview_sticker_id, 2);

/**
 * message BitmojiKitSearch
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitSearch_bitmoji_kit_event_base, 1);
PICOPROTO_REPEATED_EMBEDDED_MESSAGE(BitmojiKitSearch_search_terms, 2);

/**
 * message BitmojiKitShare
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitShare_bitmoji_kit_event_base, 1);
PICOPROTO_STRING(BitmojiKitShare_sticker_id, 3);
PICOPROTO_VARINT(BitmojiKitShare_share_category, 4);  // enum BitmojiKitShareCategory
PICOPROTO_VARINT(BitmojiKitShare_search_category, 5); // enum BitmojiKitSearchCategory

/**
 * message BitmojiKitSnapchatLinkSuccess
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitSnapchatLinkSuccess_bitmoji_kit_event_base, 1);

/**
 * message BitmojiKitSnapchatLinkTap
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitSnapchatLinkTap_bitmoji_kit_event_base, 1);

/**
 * message BitmojiKitStickerPickerClose
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitStickerPickerClose_bitmoji_kit_event_base, 1);
PICOPROTO_VARINT(BitmojiKitStickerPickerClose_sticker_picker_session_duration_millis, 2);

/**
 * message BitmojiKitStickerPickerMount
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitStickerPickerMount_bitmoji_kit_event_base, 1);

/**
 * message BitmojiKitStickerPickerOpen
 */
PICOPROTO_EMBEDDED_MESSAGE(BitmojiKitStickerPickerOpen_bitmoji_kit_event_base, 1);
PICOPROTO_VARINT(BitmojiKitStickerPickerOpen_sticker_picker_view, 2);        // enum BitmojiKitStickerPickerView
PICOPROTO_VARINT(BitmojiKitStickerPickerOpen_search_bar_configuration, 3);   // enum BitmojiKitSearchBarConfiguration
PICOPROTO_VARINT(BitmojiKitStickerPickerOpen_tag_selector_configuration, 4); // enum BitmojiKitTagSelectorConfiguration
PICOPROTO_STRING(BitmojiKitStickerPickerOpen_preview_icon_sticker_id, 5);

/**
 * message CreativeKitEventBase
 */
PICOPROTO_EMBEDDED_MESSAGE(CreativeKitEventBase_kit_event_base, 1);
PICOPROTO_STRING(CreativeKitEventBase_source_url, 2);
PICOPROTO_STRING(CreativeKitEventBase_attachment_url, 3);

/**
 * message CreativeKitShareButtonVisible
 */
PICOPROTO_EMBEDDED_MESSAGE(CreativeKitShareButtonVisible_creative_kit_event_base, 1);

/**
 * message CreativeKitShareComplete
 */
PICOPROTO_EMBEDDED_MESSAGE(CreativeKitShareComplete_creative_kit_event_base, 1);
PICOPROTO_VARINT(CreativeKitShareComplete_is_success, 2);

/**
 * message CreativeKitShareStart
 */
PICOPROTO_EMBEDDED_MESSAGE(CreativeKitShareStart_creative_kit_event_base, 1);

/**
 * message KitHeartbeat
 */
PICOPROTO_EMBEDDED_MESSAGE(KitHeartbeat_kit_event_base, 1);
PICOPROTO_STRING(KitHeartbeat_installation_id, 2);

/**
 * message LoginKitAuthComplete
 */
PICOPROTO_EMBEDDED_MESSAGE(LoginKitAuthComplete_log_kit_event_base, 1);
PICOPROTO_VARINT(LoginKitAuthComplete_is_success, 2);

/**
 * message LoginKitAuthStart
 */
PICOPROTO_EMBEDDED_MESSAGE(LoginKitAuthStart_log_kit_event_base, 1);
PICOPROTO_STRING(LoginKitAuthStart_features_requested, 2);

/**
 * message LoginKitEventBase
 */
PICOPROTO_EMBEDDED_MESSAGE(LoginKitEventBase_kit_event_base, 1);

/**
 * message KitAppApplicationEvent
 */
PICOPROTO_STRING(KitAppApplicationEvent_kit_app_id, 1);
PICOPROTO_STRING(KitAppApplicationEvent_oauth_client_id, 2);
PICOPROTO_STRING(KitAppApplicationEvent_native_game_install_id, 3);
PICOPROTO_VARINT(KitAppApplicationEvent_first_open_since_install, 4);
PICOPROTO_STRING(KitAppApplicationEvent_kit_app_version, 5);

/**
 * message KitAppApplicationOpen
 */
PICOPROTO_EMBEDDED_MESSAGE(KitAppApplicationOpen_kit_app_application_event, 1);
PICOPROTO_VARINT(KitAppApplicationOpen_kit_app_open_ts, 2);
PICOPROTO_STRING(KitAppApplicationOpen_deep_link_url, 3);
PICOPROTO_VARINT(KitAppApplicationOpen_deep_link_source_type, 4); // enum KitDeepLinkSourceType

/**
 * message KitAppApplicationClose
 */
PICOPROTO_EMBEDDED_MESSAGE(KitAppApplicationClose_kit_app_application_event, 1);
PICOPROTO_VARINT(KitAppApplicationClose_kit_app_open_ts, 2);
PICOPROTO_VARINT(KitAppApplicationClose_kit_app_close_ts, 3);
