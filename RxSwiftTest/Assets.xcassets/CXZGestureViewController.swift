//
//  CXZGestureViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CXZGestureViewController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: { (gesture) in
            let point = gesture.location(in: gesture.view)
            print("点击了（x:\(point.x) y:\(point.y)）")
        })
        .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
