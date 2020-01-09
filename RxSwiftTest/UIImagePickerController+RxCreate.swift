//
//  UIImagePickerController+RxCreate.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/2.
//  Copyright © 2020 xuanze. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>, DelegateProxyType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public init (imagePicker: UIImagePickerController) {
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { (parent) -> RxImagePickerDelegateProxy in
            return RxImagePickerDelegateProxy(imagePicker: parent)
        }
    }
    
    public static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    
}

extension Reactive where Base: UIImagePickerController {
    
    public var pickerDelegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate> {
        return RxImagePickerDelegateProxy.proxy(for: base)
    }
    
//    public var didFinishPickingMediaWithInfo: Observable<[String: AnyObject]> {
//        return pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))).map { (<#[Any]#>) -> Result in
//            return
//        }
//    }
    
    fileprivate func castOrThrow<T>(_ resultType: T.Type， _ object: Any) throws -> T{
         
    }
    
//    static func createWithParent(parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = {x in}) -> Observable<UIImagePickerController> {
//        return Observable.create { (observer) -> Disposable in
//            let imagePicker = UIImagePickerController()
//
//            let dismissDisposle = imagePicker.rx
//        }
//    }
}
