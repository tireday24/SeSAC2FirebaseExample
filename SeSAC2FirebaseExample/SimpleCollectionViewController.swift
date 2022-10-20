//
//  SimpleCollectionViewController.swift
//  SeSAC2FirebaseExample
//
//  Created by 권민서 on 2022/10/18.
//

import UIKit
import RealmSwift

class SimpleCollectionViewController: UICollectionViewController {

    var tasks: Results<Todo>!
    let localRealm = try! Realm()
    
    var cellResgistration: UICollectionView.CellRegistration<UICollectionViewListCell, Todo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let tv = UITableView()
        //tv.dataSource = self //self  클래스의 인스턴스
        //tv.delegate = self // 프로토콜을 타입으로 가지고 있음 프로토콜을 채택했기 때문에 값을 전달 할 수 있었던 것이다
        
        tasks = localRealm.objects(Todo.self)
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration) //UICollectionViewCompostionalLayout
        collectionView.collectionViewLayout = layout
        //UICollectionViewLayout
        
        cellResgistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration()//UIListConfiguration
            content.image = itemIdentifier.importance < 2 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.detail.count)개의 세부항목"
            
            cell.contentConfiguration = content//UIContentConfiguration 프로토콜을 활용하여서 넣을 수 있었다
            
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = tasks[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellResgistration, for: indexPath, item: item)
        
        //타입자체를 프로토콜로 선언 클레스 구조체 제약에서 벗어나게 된다
//        var test: fruit = apple()
//        test = banana() //타입이 맞지 않아서 못 넣음
//        test = melon()
        
        return cell
    }
}
//
//protocol fruit {
//
//}
//
//class food {
//
//}
//
//class apple: food, fruit {
//
//}
//
//class banana: food, fruit{
//
//}
//
//enum strawberry: fruit {
//
//}
//
//struct melon: fruit {
//
//}

