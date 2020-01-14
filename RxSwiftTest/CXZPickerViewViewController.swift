//
//  CXZPickerViewViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class CXZPickerViewViewController: UIViewController {
    
    @IBOutlet weak var pickerview1: UIPickerView!
    @IBOutlet weak var pickerview2: UIPickerView!
    let disposeBag = DisposeBag()
    let adapter1 = RxPickerViewStringAdapter<[String]>(components: [], numberOfComponents: { (_, _, _) -> Int in
        return 1
    }, numberOfRowsInComponent: { (_, _, items, _) -> Int in
        return items.count
    }) { (_, _, items, row, _) -> String? in
        return items[row]
    }
    
    let adapter2 = RxPickerViewStringAdapter<[[String]]>(components: [], numberOfComponents: { (_, _, components) -> Int in
        return components.count
    }, numberOfRowsInComponent: { (_, _, components, component) -> Int in
        return components[component].count
    }) { (_, _, components, row, component) -> String? in
        return components[component][row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.just(["1", "2", "3"]).bind(to: pickerview1.rx.items(adapter: adapter1)).disposed(by: disposeBag)
        Observable.just([["1", "2", "3"], ["A", "B", "C"]]).bind(to: pickerview2.rx.items(adapter: adapter2)).disposed(by: disposeBag)
    }
    

    

}
