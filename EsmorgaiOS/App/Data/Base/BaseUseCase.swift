//
//  BaseUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 6/8/24.
//

import Foundation

class BaseUseCase <I, R> {

    final func execute() async -> R {
        return await job()
    }

    final func execute(input: I) async -> R {
        return await job(input: input)
    }

    public func job() async -> R {
        fatalError("Use case is an abstract class, you should implemt your own")
    }

    public func job(input: I) async -> R {
        fatalError("Use case is an abstract class, you should implemt your own")
    }
}
