//
//  ImagePickViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/2.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImagePickViewController: UIViewController {
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnPhoto.rx.tap.flatMapLatest {[weak self] _  in
            return UIImagePickerController.rx.createWithParent(parent: self, animated: true) { (picker) in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = false
            }
            .flatMap { (picker) -> Observable<[UIImagePickerController.InfoKey: AnyObject]> in
                return picker.rx.didFinishPickingMediaWithInfo
            }
        }
        .map { (info) -> UIImage in
            return info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
        
        btnEdit.rx.tap.flatMapLatest {[weak self] _  in
            return UIImagePickerController.rx.createWithParent(parent: self, animated: true) { (picker) in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
            }
            .flatMap { (picker) -> Observable<[UIImagePickerController.InfoKey: AnyObject]> in
                return picker.rx.didFinishPickingMediaWithInfo
            }
        }
        .map { (info) -> UIImage in
            return info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
        
        btnCamera.rx.tap.flatMapLatest {[weak self] _  in
            return UIImagePickerController.rx.createWithParent(parent: self, animated: true) { (picker) in
                picker.sourceType = .camera
                picker.allowsEditing = false
            }
            .flatMap { (picker) -> Observable<[UIImagePickerController.InfoKey: AnyObject]> in
                return picker.rx.didFinishPickingMediaWithInfo
            }
        }
        .map { (info) -> UIImage in
            return info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
    }
    

    

}
