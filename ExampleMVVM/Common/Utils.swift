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

func delaySeconds(secs: Double) async{
    try? await Task.sleep(nanoseconds: UInt64(1_000_000_000 * secs))
}
