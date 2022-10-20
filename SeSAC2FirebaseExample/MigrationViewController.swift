//
//  MigrationViewController.swift
//  SeSAC2FirebaseExample
//
//  Created by 권민서 on 2022/10/13.
//

import UIKit
import RealmSwift

class MigrationViewController: UIViewController {
    
    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. fileURL
        print("FileURL: \((localRealm.configuration.fileURL!))")
        
        //2. ScemeVersion
        do {
            let version = try schemaVersionAtURL(localRealm.configuration.fileURL!)
            print("Scema Version: \(version)")
        }catch {
            print(error)
        }
        
        //3. Test
//        for i in 1...100 {
//            let task = Todo(title: "고래밥의 할일 \(i)", importance: Int.random(in: 1...5))
//            try! localRealm.write {
//                localRealm.add(task)
//            }
//        }
        
        //4. DetailTodo
//        for i in 1...10 {
//            let task = DetailTodo(detailTitle: "양파\(i)개 사기", favorite: true, deadline: Date())
//
//            try! localRealm.write {
//                localRealm.add(task)
//            }
//        }
        
        //특정 Todo 테이블에 DetaiolToDo 추가
//        guard let task = localRealm.objects(Todo.self).filter("title = '고래밥의 할일 7'").first else { return }
//
//        let detail = DetailTodo(detailTitle: "프랭크 5개 먹기", favorite: false, deadline: Date())
//
//        try! localRealm.write {
//            //detail이라는 프로퍼티에 접근
//            task.detail.append(detail)
//        }
        
        //특정 Todo 테이블에 DetailTodo 여러개 추가
//        guard let task = localRealm.objects(Todo.self).filter("title = '고래밥의 할일 3'").first else { return }
//
//        let detail = DetailTodo(detailTitle: "깡깡한 아이스크림 \(Int.random(in: 1...5))개 먹기", favorite: false, deadline: Date())
//
//        for _ in 1...10 {
//            try! localRealm.write {
//                //detail이라는 프로퍼티에 접근
//                task.detail.append(detail)
//            }
//        }
        
        //특정 Todo 테이블 삭제
//        guard let task = localRealm.objects(Todo.self).filter("title = '고래밥의 할일 7'").first else { return }
//
//        try! localRealm.write {
//            //task.detail.removeAll() 과 동일하다
//            localRealm.delete(task.detail)
//            localRealm.delete(task)
//        }
        
        //특정 Todo에 메모 추가
        guard let task = localRealm.objects(Todo.self).filter("title = '고래밥의 할일 6'").first else { return }

        let memo = Memo()
        memo.content = "이렇게 메모 내용을 추가해봅니다"
        memo.date = Date()

        try! localRealm.write {
            task.memo = memo
        }
    }

}
