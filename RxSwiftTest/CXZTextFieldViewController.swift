//
//  CXZTextFieldViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CXZTextFieldViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var labelNum: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tf1.rx.text.bind(to: tf2.rx.text).disposed(by: disposeBag)
        //        tf1.rx.text.map {$0?.count ?? 0 > 6}
        //            .bind(to: btn.rx.isEnabled)
        //            .disposed(by: disposeBag)
        
        Observable.combineLatest(tf1.rx.text.orEmpty, tf2.rx.text.orEmpty) { (text1, text2) -> String in
            return "tf1: \(text1);tf2: \(text2)"
        }
        .bind(to: labelValue.rx.text)
        .disposed(by: disposeBag)
        
        //driver
        let textInput = tf1.rx.text.orEmpty.asDriver().throttle(0.3)
        //throttle
        //指定了两秒钟，所以在0.3以内，只接收了第一条和最新的数据。
        //适用于：输入框搜索限制发送请求。
        //取出用户输入稳定后的内容
        
        //driver
        //不会产生 error 事件
        //一定在 MainScheduler 监听（主线程监听）
        //共享附加作用
        textInput.drive(tf2.rx.text).disposed(by: disposeBag)
        textInput.map {$0.count > 6}.drive(btn.rx.isEnabled).disposed(by: disposeBag)
        
        
        tf1.rx.text.subscribe(onNext: { (text) in
            self.labelNum.text = "当前输入了\(text?.count ?? 0)个字"
        })
            .disposed(by: disposeBag)
        
        //回车事件
        tf1.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: {[weak self] in
                self?.tf2.becomeFirstResponder()
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
