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

extension Reactive where Base: UIImagePickerController {
    public var pickerDelegate = DelegateProxy
    
//    static func createWithParent(parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = {x in}) -> Observable<UIImagePickerController> {
//        return Observable.create { (observer) -> Disposable in
//            let imagePicker = UIImagePickerController()
//
//            let dismissDisposle = imagePicker.rx
//        }
//    }
}
