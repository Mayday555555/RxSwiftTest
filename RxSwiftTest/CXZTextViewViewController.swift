//
//  CXZTextViewViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CXZTextViewViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.rx.didBeginEditing
            .subscribe(onNext: {
                print("开始编辑")
            })
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(onNext: {
                print("结束编辑")
            })
            .disposed(by: disposeBag)
        
        textView.rx.didChange
        .subscribe(onNext: {
            print("内容变化")
        })
        .disposed(by: disposeBag)
        
        textView.rx.didChangeSelection
        .subscribe(onNext: {
            print("选择的内容变化")
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
