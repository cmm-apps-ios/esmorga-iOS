//
//  SendVotePollUseCase.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 24/09/2026.
//

import Foundation

typealias SendVotePollUseCaseResult = Result<Poll, Error>
typealias SendVotePollUseCaseAlias = BaseUseCase<VotePollRequest, SendVotePollUseCaseResult>

class SendVotePollUseCase: SendVotePollUseCaseAlias {

    private var pollsRepository: PollsRepositoryProtocol

    init(pollsRepository: PollsRepositoryProtocol = PollsRepository()) {
        self.pollsRepository = pollsRepository
    }

    override func job(input: VotePollRequest) async -> SendVotePollUseCaseResult {
        do {
            let poll = try await pollsRepository.sendVote(vote: input)
            return .success(poll)
        } catch {
            return .failure(error)
        }
    }
}
