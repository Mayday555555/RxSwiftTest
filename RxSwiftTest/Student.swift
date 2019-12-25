//
//  Student.swift
//  RxSwiftTest
//
//  Created by xuanze on 2019/12/17.
//  Copyright © 2019 xuanze. All rights reserved.
//

enum SexType {
    case male
    case female
}

import UIKit

class Student: NSObject {
    var name = ""
    var grade = 0
    var className = 0
    var sex: SexType?
    var score = 0
    var parent: Parent?
    
    func singASong(name: String) {
        print("\(self.name)唱一首\(name)")
    }
    
    init(name: String, grade: Int, className: Int, sex: SexType, score: Int) {
        self.name = name
        self.grade = grade
        self.className = className
        self.sex = sex
        self.score = score
        self.parent = Parent(childName: self.name)
    }
}

class Parent: NSObject {
    var childrenName = ""
    init(childName: String) {
        self.childrenName = childName
    }
    func recevieReward() {
        print("\(self.childrenName)父母领奖")
    }
}
