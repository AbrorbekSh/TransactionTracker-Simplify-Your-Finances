import UIKit

enum CustomFontType {
    case semibold
    case bold
    case regular
    case medium
}

extension UIFont {
    static func customFont(type: CustomFontType, size: CGFloat) -> UIFont {
        switch type {
        case .semibold:
            return UIFont(name: "Montserrat-SemiBold", size: size)!
        case .bold:
            return UIFont(name: "Montserrat-Bold", size: size)!
        case .regular:
            return UIFont(name: "Montserrat-Regular", size: size)!
        case .medium:
            return UIFont(name: "Montserrat-Medium", size: size)!
        }
    }
}

//UIFont.customFont(type: .semibold, size: 15)

