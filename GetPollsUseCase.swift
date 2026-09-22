import Foundation

typealias GetPollsUseCaseResult = Result<[Poll], Error>
typealias GetPollsUseCaseAlias = BaseUseCase<EmptyInput, GetPollsUseCaseResult>

class GetPollsUseCase: GetPollsUseCaseAlias {
    
    private var pollsRepository: PollsRepositoryProtocol
    
    init(pollsRepository: PollsRepositoryProtocol = PollsRepository()) {
        self.pollsRepository = pollsRepository
    }
    
    override func job(input: EmptyInput) async -> GetPollsUseCaseResult {
        do {
            let polls = try await pollsRepository.fetchPolls()
            return .success(polls)
        } catch {
            return .failure(error)
        }
    }
}
