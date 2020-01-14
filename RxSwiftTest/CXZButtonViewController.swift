//
//  CXZButtonViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CXZButtonViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var sw: UISwitch!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.rx.tap.subscribe(onNext: { _ in
            print("button被点击了")
        })
            .disposed(by: disposeBag)
        
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.map { "\($0)"}
            .bind(to: button.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        let timer1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.map { (value) -> UIImage in
            return UIImage(named: value % 2 == 0 ?"navBack1":"navBack3")!
        }
        .bind(to: button.rx.image(for: .normal))
        .disposed(by: disposeBag)
        
        btn1.isSelected = true
        
        //将按钮放入数组中，并进行强制解包
        let buttons = [btn1, btn2, btn3].map { (btn) -> UIButton in
            return btn!
        }
        let observal = buttons.map { btn in btn.rx.tap.map {return btn} }
        let selectBtn = Observable.from(observal).merge()
        
        for btn in buttons {
            selectBtn.map{$0 == btn}
                .bind(to: btn.rx.isSelected)
                .disposed(by: disposeBag)
        }
        
        sw.rx.isOn.bind(to: btn1.rx.isEnabled).disposed(by: disposeBag)
        sw.rx.isOn.asObservable().subscribe(onNext: { (isOn) in
            self.btn2.isEnabled = isOn
        })
        .disposed(by: disposeBag)
    }
    
    
    
    
}
