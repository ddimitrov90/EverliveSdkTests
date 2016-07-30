//
//  Paging.swift
//  EverliveSwift
//
//  Created by Dimitar Dimitrov on 3/22/16.
//  Copyright © 2016 ddimitrov. All rights reserved.
//

import Foundation

public class Paging {
    var skip: Int?
    var take: Int?
    
    public init(){
        
    }
    
    public init(skip: Int?, take:Int?){
        self.skip = skip
        self.take = take
    }
}