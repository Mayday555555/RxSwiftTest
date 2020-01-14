//
//  CXZCollectionViewController.swift
//  RxSwiftTest
//
//  Created by xuanze on 2020/1/10.
//  Copyright © 2020 xuanze. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class CXZCollectionViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    private var cellId = "MovieCell"
    private var titleViewId = "MoviewTitleView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let items = Observable.just([SectionModel(model: "国内电影", items: ["少年的你" , "地久天长" ,"流浪地球" ,"哪吒" ,"四个春天"]),
                                     SectionModel(model: "国外电影", items: ["复仇者联盟4" , "波西米亚狂想曲" ,"绿皮书" ,"双子杀手" ,"小丑"])])
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 50)
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 40)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MoviewTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: titleViewId)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: {[weak self] (dataSource, collectionView, indexPath, element) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self?.cellId ?? "", for: indexPath) as? MovieCell
            cell?.labelTitle.text = element
            return cell!
        }, configureSupplementaryView: {[weak self] (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self?.titleViewId ?? "", for: indexPath) as? MoviewTitleView
            view?.labelTitle.text = dataSource[indexPath.section].model
            return view!
        })
        
        items.bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(String.self).subscribe(onNext: { (item) in
                print("最喜欢《\(item)》")
            })
            .disposed(by: disposeBag)
        
    }
}

extension CXZCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
}

class MovieCell: UICollectionViewCell {
    var labelTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        labelTitle = UILabel()
        labelTitle.font = UIFont.systemFont(ofSize: 10)
        labelTitle.textColor = UIColor.black
        labelTitle.textAlignment = .center
        self.contentView.addSubview(labelTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelTitle.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MoviewTitleView: UICollectionReusableView {
    
    var labelTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        labelTitle.font = UIFont.systemFont(ofSize: 15)
        labelTitle.textColor = UIColor.orange
        labelTitle.textAlignment = .center
        self.addSubview(labelTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelTitle.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
