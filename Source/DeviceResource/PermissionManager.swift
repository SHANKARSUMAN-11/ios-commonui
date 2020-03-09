//
//  PermissionManager.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 21/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation

public protocol PermissionManagerDelegate {
    func audioPermissionResult(_ result: PermissionStatus)
    func locationPermissionResult(_ result: PermissionStatus)
    func cameraPermissionResult(_ result: PermissionStatus)
}

public extension PermissionManagerDelegate {
    func audioPermissionResult(_ result: PermissionStatus) {}
    func locationPermissionResult(_ result: PermissionStatus) {}
    func cameraPermissionResult(_ result: PermissionStatus) {}
}

@objc public enum PermissionType: Int {
    case Microphone
    case Location
    case Camera
}

@objc public enum PermissionStatus: Int {
    case Granted
    case Denied
}

@objc public enum LocationAccessLevel: Int {
    case WhenInUse
    case Always
}

public class PermissionManager: NSObject, CLLocationManagerDelegate {
    
    var delegate: PermissionManagerDelegate?
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    private var accessLevel: LocationAccessLevel?
    
    public init(delegate: PermissionManagerDelegate) {
        self.delegate = delegate
    }
    
    public func checkPermission(for resource: PermissionType, with accessLevel: LocationAccessLevel = .WhenInUse) {
        switch resource {
        case .Microphone:
            self.checkAudioPermission()
        case .Location:
            self.checkLocationPermission(type: accessLevel)
        case .Camera:
            self.checkCameraPermission()
        }
    }
    
    private func checkAudioPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            delegate?.audioPermissionResult(.Granted)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.checkAudioPermission()
                }
            }
        default:
            delegate?.audioPermissionResult(.Denied)
        }
    }
    
    private func checkCameraPermission() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
        case .authorized:
            delegate?.cameraPermissionResult(.Granted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (_) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.checkCameraPermission()
                }
            }
        case .denied, .restricted:
            delegate?.cameraPermissionResult(.Denied)
        }
    }
    
    private func checkLocationPermission(type: LocationAccessLevel) {
        guard CLLocationManager.locationServicesEnabled() else {
            delegate?.locationPermissionResult(.Denied)
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            delegate?.locationPermissionResult(.Denied)
        case .notDetermined:
            requestLocationPermission(type: type)
        case .authorizedWhenInUse where type == .WhenInUse:
            delegate?.locationPermissionResult(.Granted)
        case .authorizedAlways where type == .Always:
            delegate?.locationPermissionResult(.Granted)
        default:
            requestLocationPermission(type: type)
        }
    }
    
    private func requestLocationPermission(type: LocationAccessLevel) {
        accessLevel = type
        switch type {
        case .WhenInUse:
            locationManager.requestWhenInUseAuthorization()
        case .Always:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    //MARK: - CLLocationManagerDelegate -
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission(type: accessLevel ?? .WhenInUse)
    }
    
}
