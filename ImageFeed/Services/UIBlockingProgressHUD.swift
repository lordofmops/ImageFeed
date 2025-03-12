//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Дарья Дробышева on 18.02.2025.
//
import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circlePulseMultiple
        ProgressHUD.colorHUD = .ypBlack
        ProgressHUD.colorAnimation = .lightGray
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
