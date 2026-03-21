import Foundation

struct PlanAPIService {
    struct ItineraryRequest: Codable {
        let destination: String
        let prompt: String
        let preferences: [String]
        let savedPlaces: [String]

        enum CodingKeys: String, CodingKey {
            case destination
            case prompt
            case preferences
            case savedPlaces = "saved_places"
        }
    }

    struct ItineraryBlock: Codable {
        let title: String
        let activities: [String]
    }

    struct ItineraryResponse: Codable {
        let destination: String
        let morning: ItineraryBlock
        let afternoon: ItineraryBlock
        let evening: ItineraryBlock
        let notes: [String]
    }

    enum ServiceError: LocalizedError {
        case invalidBaseURL
        case invalidResponse
        case serverError(statusCode: Int)
        case requestFailed
        case decodingFailed

        var errorDescription: String? {
            switch self {
            case .invalidBaseURL:
                return "The planner service URL is invalid."
            case .invalidResponse:
                return "The planner service returned an unexpected response."
            case .serverError(let statusCode):
                return "The planner service returned an error (\(statusCode))."
            case .requestFailed:
                return "The planner request could not be completed."
            case .decodingFailed:
                return "The planner response could not be read."
            }
        }
    }

    // The iOS Simulator can use http://127.0.0.1:8000 when the FastAPI backend runs on the host Mac.
    private let baseURLString = "http://127.0.0.1:8000"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func generateItinerary(
        destination: String,
        prompt: String,
        preferences: [String],
        savedPlaces: [String]
    ) async throws -> ItineraryResponse {
        guard let url = URL(string: "\(baseURLString)/plan-itinerary") else {
            throw ServiceError.invalidBaseURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 20
        request.httpBody = try JSONEncoder().encode(
            ItineraryRequest(
                destination: destination,
                prompt: prompt,
                preferences: preferences,
                savedPlaces: savedPlaces
            )
        )

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw ServiceError.requestFailed
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        guard 200 ..< 300 ~= httpResponse.statusCode else {
            throw ServiceError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(ItineraryResponse.self, from: data)
        } catch {
            throw ServiceError.decodingFailed
        }
    }
}
