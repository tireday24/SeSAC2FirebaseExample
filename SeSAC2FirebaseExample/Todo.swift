//
//  Todo.swift
//  SeSAC2FirebaseExample
//
//  Created by 권민서 on 2022/10/13.
//

import UIKit
import RealmSwift

class Todo: Object {
    @Persisted var title: String
    @Persisted var importance: Int
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    //배열 형태를 다루고 싶을 때 리스트 사용 
    @Persisted var detail: List<DetailTodo>
    
    @Persisted var memo: Memo? //EmbeddedObject는 항상 Optional
    
    convenience init(title: String, importance: Int) {
        self.init()
        self.title = title
        self.importance = importance
    }
}

//세부 할 일
class DetailTodo: Object {
    @Persisted var detailTitle: String
    @Persisted var favorite: Bool
    @Persisted var deadline: Date
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(detailTitle: String, favorite: Bool, deadline: Date) {
        self.init()
        self.detailTitle = detailTitle
        self.favorite = favorite
        self.deadline = deadline
    }
}

class Memo: EmbeddedObject {
    @Persisted var content: String
    @Persisted var date: Date
    
//    init(content: String, date: Date) {
//        self.content = content
//        self.date = date
//    }
}
