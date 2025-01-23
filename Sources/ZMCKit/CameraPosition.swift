public enum ZMCameraPosition {
    case front
    case back
    
    internal var avPosition: AVCaptureDevice.Position {
        switch self {
        case .front:
            return .front
        case .back:
            return .back
        }
    }
} 