//
//  DataModel.swift
//  Penn Study
//
//  Created by Brandon Barros on 12/2/19.
//  Copyright © 2019 Brandon Barros. All rights reserved.
//
/*struct MyData {
    let users: [User?]
    var classes: [Class?]
    var groups: [Group?]
}

struct ClassTest: Codable {
    let name: String
    var description: String
}


struct User {
    let pennKey: String
    var name: String?
    var classes: [Class?]
    var groups: [Group?]
}

struct Class {
    let name: String
    var description: String?
    var groups: [Group?]
}


struct Group {
    let c: Class
    var members: [User?]
}*/



struct MyData: Codable {
    var classes: [Class]
    var users: [User]
}

struct Class: Codable {
    let name: String
    let description: String
    var professor: String
}

struct User: Codable {
    let password: String
}


