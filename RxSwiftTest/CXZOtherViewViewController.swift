//
//  CXZOtherViewViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CXZOtherViewViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var sw: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segment.rx.selectedSegmentIndex.asObservable()
            .subscribe(onNext: {
            print("选择了第\($0)个")
        })
            .disposed(by: disposeBag)
        
        sw.rx.isOn
            .bind(to: activityView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        slider.rx.value.asObservable()
            .subscribe(onNext: {
            print("slider当前值\($0)")
        })
            .disposed(by: disposeBag)
        
        stepper.rx.value.asObservable()
            .subscribe(onNext: {
            print("stepper当前值\($0)")
        })
            .disposed(by: disposeBag)
        
        stepper.rx.value.asObservable()
            .map({Float($0)})
            .bind(to: slider.rx.value)
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
