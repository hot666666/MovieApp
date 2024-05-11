//
//  Utils.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
