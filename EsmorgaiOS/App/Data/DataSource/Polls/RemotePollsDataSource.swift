//
//  RemotePollsDataSource.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 21/09/2026.
//

protocol RemotePollsDataSourceProtocol {
    func fetchPolls() async throws -> [RemotePoll]
    func sendVote(vote: VotePollRequest) async throws -> RemotePoll
}

class RemotePollsDataSource: RemotePollsDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func fetchPolls() async throws -> [RemotePoll] {
        do {
            let endpoint = PollsNetworkService.pollsList
            let pollListResponse: RemotePollList = try await networkRequest.request(networkService: endpoint)
            return pollListResponse.polls ?? []
        } catch let error {
            throw error
        }
    }
    
    func sendVote(vote: VotePollRequest) async throws -> RemotePoll {
        do {
            let endpoint = PollsNetworkService.sendVote(vote)
            let response: RemotePoll = try await networkRequest.request(networkService: endpoint)
            return response
        } catch let error {
            throw error
        }
    }
}
