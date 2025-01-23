# ZMCameraKit

## ZiylanMedyaCameraKit

### SPM: https://github.com/ziylanmedya/ZMCameraKit

### Info.plist
  - Queried URL Schemes -> snapchat
  - Privacy - Camera Usage Description
  - Privacy - Photo Library Usage Description
  - Privacy - Microphone Usage Description

### XCode 16 Update:
- Proje targeti seçilip Build Settings kısmında sol üstten `+` tıklanarak `Add-User Defined Setting` seçilmelidir. Açılan alana `STRIP_BITCODE_FROM_COPIED_FILES` yazılmalı ve tüm değerler `NO` olarak set edilmelidir.

## Gereksinimler

- iOS 13.0+
- Swift 5.9+
- Xcode 15.0+
- Geçerli API Token
- Geçerli Group Id
- Fiziksel cihaz (simulator sadece derleme için desteklenir)


## Nasıl Kullanılır?

Öncelikle ZMCKit'i uygulamanızda başlatın:

```swift
import ZMCKit

// AppDelegate'de veya uygulama yaşam döngüsünün başında
ZMCKit.initialize()
```

### Tekli Lens Deneyimi

```swift
  let singleLensView = ZMCKit.createSingleProductView(
    snapAPIToken: "api-token",
    partnerGroupId: "group-id",
    lensId: "lens-id"
  )
```

### Çoklu ürün deneyimi için:

```swift
  let multiLensView = ZMCKit.createMultiProductView(
    snapAPIToken: "api-token",
    partnerGroupId: "group-id"
  )
```

View hiyerarşisine ekleyin:

```swift
  view.addSubview(singleLensView)
  view.addSubview(multiLensView)
```

### Çekimleri Yönetme

Çekilen fotoğrafları yönetmek için `ZMCameraDelegate` protokolünü uygulayın:

```swift
extension YourViewController: ZMCameraDelegate {

    func cameraDidCapture(image: UIImage?) {
      // Çekilen fotoğrafı yönetin
    }

    func shouldShowDefaultPreview() -> Bool {
      // Önizlemeyi kendiniz yönetmek için false dönün
      return true
    }

    func willShowPreview(image: UIImage?) {
      // Önizleme gösterilmeden önce çağrılır
    }
}

// Delegate'i ayarlayın
multiLensView.delegate = self
singleLensView.delegate = self

```

### Anlık gösterilen lens bilgisine ulaşmak için:

```swift
ZMCKit.onLensChange { lensId in
    if let lensId = lensId {
        print("Current lens ID: \(lensId)")
    }
}
```

bu callback fonksiyonun ek olarak, 

```swift
if let currentLensId = ZMCKit.currentLensId {
    print("Active lens: \(currentLensId)")
}
```

şeklinde de anlık lens bilgisine ulaşabilirsiniz.

### Temizlik
Bu işlem için aşağıdaki iki fonksiyonu da kullanabilirsiniz: 
```swift
cameraView.cleanup()
cameraView.removeFromSuperview() // Bu işlem otomatik olarak cleanup fonksiyonunu da çağırır
```

