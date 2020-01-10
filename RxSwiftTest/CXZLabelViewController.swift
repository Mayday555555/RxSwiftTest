//
//  CXZLabelViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CXZLabelViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
//        let observal = timer.map { String(format: "%0.1d", $0)
//        }
        timer.subscribe(onNext: { (value) in
            print(value)
            })
            .disposed(by: disposeBag)
        let observal = timer.map { (value) -> String in
            return String(format: "%0.1d", value)
        }
        observal.bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    

   

}
