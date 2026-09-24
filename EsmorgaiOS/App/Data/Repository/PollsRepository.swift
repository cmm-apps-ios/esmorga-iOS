//
//  PollsRepository.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 21/09/2026.
//

protocol PollsRepositoryProtocol {
    func fetchPolls() async throws -> [Poll]
    func sendVote(vote: VotePollRequest) async throws -> Poll
}

class PollsRepository: PollsRepositoryProtocol {
    
    private var remoteDataSource: RemotePollsDataSourceProtocol

    init(remoteDataSource: RemotePollsDataSourceProtocol = RemotePollsDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchPolls() async throws -> [Poll] {
        do {
            let polls = try await remoteDataSource.fetchPolls()
            let domainEvents = polls.compactMap { $0.toDomain() }
            return domainEvents
        } catch {
            throw error
        }
    }
    
    func sendVote(vote: VotePollRequest) async throws -> Poll {
        do {
            let poll = try await remoteDataSource.sendVote(vote: vote)
            return poll.toDomain()
        } catch {
            throw error
        }
    }
}
