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
import UIKit

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

func disMissViewController(_ viewcontroller: UIViewController, animated: Bool) {
    if viewcontroller.isBeingDismissed || viewcontroller.isBeingPresented {
        disMissViewController(viewcontroller, animated: animated)
    }
    
    if viewcontroller.presentingViewController != nil {
        viewcontroller.dismiss(animated: animated, completion: nil)
    }
}

extension Reactive where Base: UIImagePickerController {
    
    
    
    public var pickerDelegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate> {
        return RxImagePickerDelegateProxy.proxy(for: base)
    }
    
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
        return pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))).map ({ (a)  in
            return try self.castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
        })
    }
    
    public var didCancel: Observable<()> {
        return pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:))).map { _ in
            ()
        }
    }
    
    fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T{
        guard  let returnObject = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnObject
    }
    
    static func createWithParent(parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = {x in}) -> Observable<UIImagePickerController> {
        return Observable.create { (observer) -> Disposable in
            let imagePicker = UIImagePickerController()

            let dismissDisposle = Observable.merge(
                imagePicker.rx.didFinishPickingMediaWithInfo.map({ _ in}),
                imagePicker.rx.didCancel
            ).subscribe(onNext: { (_) in
                observer.on(.completed)
            })
            
            do {
                try configureImagePicker(imagePicker)
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
            
            guard let parent = parent else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            parent.present(imagePicker, animated: animated) {
                
            }
            observer.onNext(imagePicker)
            
            return Disposables.create(dismissDisposle, Disposables.create {
                disMissViewController(imagePicker, animated: true)
            })
        }
    }
}
