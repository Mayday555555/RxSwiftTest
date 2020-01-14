//
//  CXZDatePickerViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CXZDatePickerViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timerPicker: UIDatePicker!
    @IBOutlet weak var startBtn: UIButton!
    let formatter:DateFormatter!  = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()
    
    var leftTime = BehaviorRelay(value: TimeInterval(60))
    var countDownStopped = BehaviorRelay(value: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.rx.value.map { (date) -> String in
            return "当前选中的时间为\(self.formatter.string(from: date))"
        }
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
        
        
        startBtn.rx.tap.subscribe(onNext: {
            self.startCountDown()
        })
        .disposed(by: disposeBag)
        
        
        DispatchQueue.main.async {
            self.timerPicker.rx.countDownDuration.bind(to: self.leftTime).disposed(by: self.disposeBag)
            self.leftTime.bind(to: self.timerPicker.rx.countDownDuration).disposed(by: self.disposeBag)
        }
        
        Observable.combineLatest(self.leftTime.asObservable(), self.countDownStopped.asObservable()) { (leftvalue, countDowStopValue) -> String in
            if countDowStopValue {
                return "开始"
            } else {
                return "倒计时开始 还有\(leftvalue)秒"
            }
        }.bind(to: startBtn.rx.title())
        .disposed(by: disposeBag)
        
        countDownStopped.asDriver().drive(startBtn.rx.isEnabled).disposed(by: disposeBag)
        countDownStopped.asDriver().drive(timerPicker.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func startCountDown() {
        self.countDownStopped.accept(false)
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .takeUntil(self.countDownStopped.filter({$0}))
            .subscribe(onNext: { (value) in
                self.leftTime.accept(self.leftTime.value - 1)
                if self.leftTime.value == 0 {
                    self.countDownStopped.accept(true)
                    self.leftTime.accept(60)
                }
            })
        .disposed(by: disposeBag)
    }
    

}
