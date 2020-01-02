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

        btnPhoto.rx.tap
        .flatMapLatest { [weak self] _ in
            return UIImagePickerController.rx.createWithParent(self) { picker in
                picker.sourceType = .camera
                picker.allowsEditing = false
            }
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            .take(1)
        }
        .map { info in
            return info[.originalImage] as? UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
    }
    

    

}
