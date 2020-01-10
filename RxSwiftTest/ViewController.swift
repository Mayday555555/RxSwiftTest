//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2019/12/11.
//  Copyright © 2019 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//https://www.jianshu.com/p/a83eba5e7b8c
//https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_ecosystem.html
class ViewController: UIViewController {
    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var labelUserNameUnValid: UILabel!
    @IBOutlet weak var tabView: UITableView!
    typealias JSON = Any
    var disposeBag = DisposeBag()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.testFunctionalCode()
        //        self.closureFun()
        //        self.testAnyObserver()
        //        self.testBinder()
        //        self.testOperateCode()
        //        self.testRetry()
        //        self.testRetryWhen()
        //        self.testOperateCode()
        self.testRxData()
        
    }
    
    private func testRxData() {
        let vcIds = ["ImagePick",  "CXZLabel"]
        tabView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let items = Observable.just([SectionModel(model: "", items: [DataModel(name: "imagePicker"), DataModel(name: "UILabel的使用")])])
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DataModel>>(configureCell: {dataSource,tableView,indexPath,element -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text  = element.vcname
            return cell
        })
        items.bind(to: tabView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tabView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        tabView.tableFooterView = UIView()
        tabView.rx.itemSelected.subscribe(onNext: { (index) in
            self.tabView.deselectRow(at: index, animated: true)
            self.presentVC(id: vcIds[index.row])
        })
            .disposed(by: disposeBag)
    }
    
    private func presentVC(id: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: id)
        self.present(vc, animated: true, completion: nil)
    }
    
    ///函数式编程
    private func testFunctionalCode() {
        let students = [Student(name: "李红",grade: 3, className: 1, sex: .female, score: 85),
                        Student(name: "李峰",grade: 3, className: 3, sex: .male, score: 65),
                        Student(name: "杜红",grade: 3, className: 1, sex: .female, score: 99),
                        Student(name: "陈红",grade: 3, className: 2, sex: .female, score: 66),
                        Student(name: "江红",grade: 3, className: 2, sex: .male, score: 56),
                        Student(name: "马红",grade: 3, className: 2, sex: .female, score: 98),
                        Student(name: "刘红",grade: 3, className: 3, sex: .male, score: 89),
                        Student(name: "牛红",grade: 3, className: 3, sex: .female, score: 45),
                        Student(name: "赵红",grade: 3, className: 3, sex: .male, score: 73)]
        
        let gradeThreeTwoStudent = students.filter { (student) -> Bool in
            return student.grade == 3 && student.className == 2
        }
        print(gradeThreeTwoStudent)
        
        gradeThreeTwoStudent.filter { (student) -> Bool in
            return student.sex == SexType.male
        }.forEach { (student) in
            student.singASong(name: "小苹果")
        }
        
        gradeThreeTwoStudent.filter { (stu) -> Bool in
            return stu.score > 90
        }.map { (stu) -> Parent in
            return stu.parent!
        }.forEach { (parent) in
            parent.recevieReward()
        }
    }
    
    //创建可监听序列
    func createObervalList() {
        let numbers:Observable<Int> = Observable.create { oberver -> Disposable in
            oberver.onNext(1)
            oberver.onNext(2)
            oberver.onCompleted()
            return Disposables.create()
        }
        
        print(numbers)
    }
    
    ///封装闭包回调
    func closureFun() {
        let json: Observable<JSON> = Observable.create { (obsever) -> Disposable in
            let task = URLSession.shared.dataTask(with: URL(string: "http://ppt.szwdcloud.com/?info=0&furl=http://szwd.oss-cn-qingdao.aliyuncs.com/files/f1f7e562bbb84730ad2fa6d6c48a2bff.pptx")!) { (data, response, error) in
                guard error == nil else {
                    obsever.onError(error!)
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    obsever.onError(error!)
                    return
                }
                
                obsever.onNext(jsonObject)
                obsever.onCompleted()
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        
        json.subscribe(onNext: { (json) in
            print("取得json\(json)")
        }, onError: { (error) in
            print("error\(error.localizedDescription)")
        }, onCompleted: {
            print("任务成功完成")
        }) { 
            print("DisposeBag")
        }
        .disposed(by: disposeBag)
    }
    
    //观察者
    func testAnyObserver() {
        //        URLSession.shared.rx.data(request: URLRequest(url: URL(string: "https://ppt.szwdcloud.com/?info=0&furl=http://szwd.oss-cn-qingdao.aliyuncs.com/files/f1f7e562bbb84730ad2fa6d6c48a2bff.pptx")!)).subscribe(onNext: { (data) in
        //            print("取得json\(data)")
        //        }, onError: { (error) in
        //            print("error\(error.localizedDescription)")
        //        }, onCompleted: {
        //            print("任务成功完成")
        //        }) {
        //            print("Dispose")
        //        }.disposed(by: disposeBag)
        
        //        let observer: AnyObserver<Data> = AnyObserver {(event) in
        //            switch event {
        //            case .next(let data):
        //                print("Data Task Success with count: \(data.count)")
        //            case .error(let error):
        //                print("Data Task Error: \(error)")
        //            case .completed:
        //                print("完成")
        //            }
        //        }
        //        URLSession.shared.rx.data(request: URLRequest(url: URL(string: "https://ppt.szwdcloud.com/?info=0&furl=http://szwd.oss-cn-qingdao.aliyuncs.com/files/f1f7e562bbb84730ad2fa6d6c48a2bff.pptx")!)).subscribe(observer).disposed(by: disposeBag)
        
    }
    
    
    func testBinder() {
        let userNameValid = textFieldUserName.rx.text.map{$0?.count ?? 0 >= 5}.share(replay: 1)
        userNameValid.bind(to: labelUserNameUnValid.rx.isHidden).disposed(by: disposeBag)
        
        
        let observer: Binder<Bool> = Binder(labelUserNameUnValid) {(view,isHidden) in
            view.isHidden = isHidden
        }
        userNameValid.bind(to: observer).disposed(by: disposeBag)
    }
    
    ///操作符
    func testOperateCode() {
        //filter
        Observable.of(1, 3, 20, 15, 30, 50).filter {$0 > 10}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        Observable.of(1,2,3,4,5,6,7).map {$0 * 10}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<Int>()
        Observable.zip(subject1, subject2) { (str, intValue) -> String in
            return "\(intValue)-\(str)"
        }.subscribe { (str) in
            print(str)
        }.disposed(by: disposeBag)
        
        subject1.onNext("A")
        subject2.onNext(1)
        
        subject1.onNext("B")
        subject2.onNext(2)
        
        subject1.onNext("C")
        subject2.onNext(3)
        
        subject1.onNext("D")
        subject2.onNext(4)
        
        
        
        let json1: Observable<JSON> = Observable.create { (obsever) -> Disposable in
            let task = URLSession.shared.dataTask(with: URL(string: "https://ppt.szwdcloud.com/?info=0&furl=http://szwd.oss-cn-qingdao.aliyuncs.com/files/f1f7e562bbb84730ad2fa6d6c48a2bff.pptx")!) { (data, response, error) in
                guard error == nil else {
                    obsever.onError(error!)
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    obsever.onError(error!)
                    return
                }
                
                obsever.onNext(jsonObject)
                obsever.onCompleted()
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        
        let json2: Observable<JSON> = Observable.create { (obsever) -> Disposable in
            let task = URLSession.shared.dataTask(with: URL(string: "https://ppt.szwdcloud.com/?info=0&furl=http://szwd.oss-cn-qingdao.aliyuncs.com/files/f1f7e562bbb84730ad2fa6d6c48a2bff.pptx")!) { (data, response, error) in
                guard error == nil else {
                    obsever.onError(error!)
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    obsever.onError(error!)
                    return
                }
                
                obsever.onNext(jsonObject)
                obsever.onCompleted()
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        
        Observable.zip(json1, json2) { (object1, object2) -> (object1: Any, object2: Any) in
            return (object1, object2)
        }.subscribe { (object) in
            print(object)
        }.disposed(by: disposeBag)
    }
    
    /// PublishSubject
    func testPublishSubject() {
        let subject = AsyncSubject<String>()
        
        subject.onNext("111")
        subject.onNext("222")
        
        let sub1 = subject.subscribe(onNext: { (str) in
            print("sub1: \(str)")
        })
    }
    
    /// take until
    func testTakeUntil() {
        let userNameValid = textFieldUserName.rx.text.map{$0?.count ?? 0 >= 5}.share(replay: 1)
        _ = userNameValid.takeUntil(self.rx.deallocated).bind(to: labelUserNameUnValid.rx.isHidden)
    }
    
    //调度器
    func testSchedulers() {
        let json: Observable<JSON> = Observable.create { (obsever) -> Disposable in
            let task = URLSession.shared.dataTask(with: URL(string: "http://ppt.szwdcloud.com/?info=0&furl=http://szwd.oss-cn-qingdao.aliyuncs.com/files/f1f7e562bbb84730ad2fa6d6c48a2bff.pptx")!) { (data, response, error) in
                guard error == nil else {
                    obsever.onError(error!)
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    obsever.onError(error!)
                    return
                }
                
                obsever.onNext(jsonObject)
                obsever.onCompleted()
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        json.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)).observeOn(MainScheduler.instance).subscribe(onNext: { (data) in
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
    }
    
    func testRetry() {
        let json: Observable<JSON> = Observable.create { (obsever) -> Disposable in
            let task = URLSession.shared.dataTask(with: URL(string: "http://ppt.szwdcloud.com/?info=0&furl=http://szwd.oss-cn-qingdao.aliyuncs.com/files/f1f7e562bbb84730ad2fa6d6c48a2bff.pptx")!) { (data, response, error) in
                guard error == nil else {
                    obsever.onError(error!)
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    obsever.onError(error!)
                    return
                }
                
                obsever.onNext(jsonObject)
                obsever.onCompleted()
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        json.retry(3).subscribe(onNext: { (data) in
            
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
    }
    
    func testRetryWhen() {
        let json: Observable<JSON> = Observable.create { (obsever) -> Disposable in
            let task = URLSession.shared.dataTask(with: URL(string: "http://ppt.szwdcloud.com/?info=0&furl=http://szwd.oss-cn-qingdao.aliyuncs.com/files/f1f7e562bbb84730ad2fa6d6c48a2bff.pptx")!) { (data, response, error) in
                guard error == nil else {
                    obsever.onError(error!)
                    return
                }
                
                guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    obsever.onError(error!)
                    return
                }
                
                obsever.onNext(jsonObject)
                obsever.onCompleted()
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        //        json.retryWhen({ (rxError) -> Observable<Int> in
        //            return Observable.timer(5, scheduler: MainScheduler.instance)
        //        }).subscribe(onNext: { (data) in
        //
        //        }, onError: { (error) in
        //            print(error.localizedDescription)
        //        }, onCompleted: {
        //
        //        }) {
        //
        //        }.disposed(by: disposeBag)
        
        json.retryWhen({ (rxError) -> Observable<Int> in
            
            //                   return Observable.timer(5, scheduler: MainScheduler.instance)
            return rxError.flatMap { (error) -> Observable<Int> in
                self.count += 1
                guard self.count < 5 else {
                    return Observable.error(error)
                }
                
                return Observable<Int>.timer(5, scheduler: MainScheduler.instance)
            }
        }).subscribe(onNext: { (data) in
            
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: disposeBag)
    }
    
    
    
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
