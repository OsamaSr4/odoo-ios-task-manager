import SwiftUI

enum ToastPosition {
    case top
    case bottom
    case center
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case custom(alignment: Alignment, offset: CGSize)
    
    static func defaultPosition(for device: DeviceType) -> ToastPosition {
        switch device {
        case .iPhone:
            return .top
        case .iPad:
            return .topLeft
        }
    }
    
    func alignment(for device: DeviceType) -> Alignment {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .center:
            return .center
        case .topLeft:
            return .topLeading
        case .topRight:
            return .topTrailing
        case .bottomLeft:
            return .bottomLeading
        case .bottomRight:
            return .bottomTrailing
        case .custom(let alignment, _):
            return alignment
        }
    }
    
    func offset(for device: DeviceType) -> CGSize {
        switch self {
        case .top:
            return CGSize(width: 0, height: device == .iPhone ? 60 : 80)
        case .bottom:
            return CGSize(width: 0, height: device == .iPhone ? -60 : -80)
        case .center:
            return .zero
        case .topLeft:
            return CGSize(width: 20, height: device == .iPhone ? 60 : 80)
        case .topRight:
            return CGSize(width: -20, height: device == .iPhone ? 60 : 80)
        case .bottomLeft:
            return CGSize(width: 20, height: device == .iPhone ? -60 : -80)
        case .bottomRight:
            return CGSize(width: -20, height: device == .iPhone ? -60 : -80)
        case .custom(_, let offset):
            return offset
        }
    }
    
    func availablePositions(for device: DeviceType) -> [ToastPosition] {
        switch device {
        case .iPhone:
            return [.top, .bottom, .center]
        case .iPad:
            return [.top, .bottom, .center, .topLeft, .topRight, .bottomLeft, .bottomRight]
        }
    }
}

enum DeviceType {
    case iPhone
    case iPad
    
    static var current: DeviceType {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        } else {
            return .iPhone
        }
    }
}
