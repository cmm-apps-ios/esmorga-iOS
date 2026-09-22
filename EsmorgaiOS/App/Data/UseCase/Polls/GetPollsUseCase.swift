//
//  GetPollsUseCase.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 21/09/2026.
//

import Foundation

typealias GetPollsUseCaseResult = Result<[Poll], Error>
typealias GetPollsUseCaseAlias = BaseUseCase<Void, GetPollsUseCaseResult>

class GetPollsUseCase: GetPollsUseCaseAlias {

    private var pollsRepository: PollsRepositoryProtocol

    init(pollsRepository: PollsRepositoryProtocol = PollsRepository()) {
        self.pollsRepository = pollsRepository
    }

    override func job(input: Void) async -> GetPollsUseCaseResult {
        do {
            let polls = try await pollsRepository.fetchPolls()
            return .success(polls)
        } catch {
            return .failure(error)
        }
    }
}
