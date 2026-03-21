import Foundation
import AVFoundation

@MainActor
final class PronunciationService: NSObject, ObservableObject {
    @Published private(set) var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func play(
        text: String,
        languageName: String? = nil,
        destinationName: String? = nil
    ) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: trimmedText)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = resolvedVoice(
            languageName: languageName,
            destinationName: destinationName
        )

        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func stop() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    private func resolvedVoice(
        languageName: String?,
        destinationName: String?
    ) -> AVSpeechSynthesisVoice? {
        guard let identifier = voiceIdentifier(
            languageName: languageName,
            destinationName: destinationName
        ) else {
            return nil
        }

        return AVSpeechSynthesisVoice(language: identifier)
    }

    private func voiceIdentifier(
        languageName: String?,
        destinationName: String?
    ) -> String? {
        if let languageName {
            switch languageName {
            case "Spanish":
                return "es-ES"
            case "French":
                return "fr-FR"
            case "Greek":
                return "el-GR"
            case "Italian":
                return "it-IT"
            case "Finnish":
                return "fi-FI"
            case "Danish":
                return "da-DK"
            case "Portuguese":
                return "pt-PT"
            default:
                break
            }
        }

        guard let destinationName else { return nil }

        switch destinationName {
        case "Barcelona":
            return "es-ES"
        case "Paris":
            return "fr-FR"
        case "Athens":
            return "el-GR"
        case "Rome":
            return "it-IT"
        case "Helsinki":
            return "fi-FI"
        case "Copenhagen":
            return "da-DK"
        case "Lisbon":
            return "pt-PT"
        default:
            return nil
        }
    }
}

extension PronunciationService: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            isSpeaking = false
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            isSpeaking = false
        }
    }
}
