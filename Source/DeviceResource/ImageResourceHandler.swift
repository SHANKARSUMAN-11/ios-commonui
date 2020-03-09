//
//  ImageResourceHandler.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 20/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation
import Photos

@objc public enum ImageSource: Int {
    case Camera
    case Gallery
}

public protocol ImageResourceHandlerDelegate {
    func accessDenied(resource: ImageSource)
    func present(controller: UIViewController?)
    func dismiss()
    func processImage(image:UIImage?,resource: [PHAssetResource]?,error: Error?)
}

public class ImageResourceHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: ImageResourceHandlerDelegate?
    private var imagePickerDelegate: ImagePickerDelegate?
    private let imagePicker = UIImagePickerController()
    
    public override init() {
        super.init()
    }
    
    public convenience init(delegate: ImageResourceHandlerDelegate) {
        self.init()
        self.delegate = delegate
        self.imagePickerDelegate = ImagePickerDelegate(parent: self)
    }
    
    public func showImageAccessActionSheet(from view: UIView, with options: [ImageSource : String] = [.Camera:"Camera",.Gallery:"Camera Roll"]) {
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        options.forEach { (resource) in
            switch resource.key {
            case .Camera:
                actionSheetController.addAction(UIAlertAction(title: resource.value, style: .default, handler: { (alert:UIAlertAction!) -> Void in
                    DispatchQueue.main.async {
                        self.checkCameraAuthorizationAndProceed()
                    }
                }))
            case .Gallery:
                actionSheetController.addAction(UIAlertAction(title: resource.value, style: .default, handler: { (alert:UIAlertAction!) -> Void in
                    DispatchQueue.main.async {
                        self.checkPhotosAuthorizationAndProceed(image: UIImage(), isOpenGallery: true)
                    }
                }))
            }
        }
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = view.bounds
        }
        self.delegate?.present(controller: actionSheetController)
    }
    
    internal func checkCameraAuthorizationAndProceed() {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .notDetermined,.restricted:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (_) in
                DispatchQueue.main.async {
                    self.checkCameraAuthorizationAndProceed()
                }
            })
        case .denied:
            self.delegate?.accessDenied(resource: .Camera)
        case .authorized:
            self.camera()
        }
    }
    
    internal func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self.imagePickerDelegate
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            self.delegate?.present(controller: imagePicker)
        }
    }
    
    internal func checkPhotosAuthorizationAndProceed(image: UIImage,isOpenGallery: Bool) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined,.restricted:
            PHPhotoLibrary.requestAuthorization({ (_) in
                DispatchQueue.main.async {
                    self.checkPhotosAuthorizationAndProceed(image: image,isOpenGallery: isOpenGallery)
                }
            })
        case .denied:
            self.delegate?.accessDenied(resource: .Gallery)
        case .authorized:
            if isOpenGallery{
                self.photoLibrary()
            } else {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    internal func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self.imagePickerDelegate
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            self.delegate?.present(controller: imagePicker)
        }
    }
    
    @objc internal func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard let error = error else {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.fetchLimit = 1
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            if let asset = fetchResult.firstObject  {
                let resources = PHAssetResource.assetResources(for: asset)
                self.delegate?.processImage(image: image, resource: resources, error: nil)
            } else {
                self.delegate?.processImage(image: image, resource: nil, error: nil)
            }
            return
        }
        self.delegate?.processImage(image: nil, resource: nil, error: error)
    }
}

private class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private weak var imageResourceHandler: ImageResourceHandler?
    
    override init() {
        super.init()
    }
    
    init(parent: ImageResourceHandler) {
        super.init()
        self.imageResourceHandler = parent
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if picker.sourceType == .camera {
                self.imageResourceHandler?.checkPhotosAuthorizationAndProceed(image: pickedImage,isOpenGallery: false)
            } else if let referenceUrl = info[.referenceURL] as? URL,
                let asset = PHAsset.fetchAssets(withALAssetURLs: [referenceUrl], options: nil).firstObject {
                let resources = PHAssetResource.assetResources(for: asset)
                self.imageResourceHandler?.delegate?.processImage(image: pickedImage, resource: resources, error: nil)
            }
        }
        self.imageResourceHandler?.delegate?.dismiss()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imageResourceHandler?.delegate?.dismiss()
    }
}
