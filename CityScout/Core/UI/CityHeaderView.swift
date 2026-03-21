import SwiftUI

struct CityHeaderView: View {
    let destinationName: String

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            VStack(alignment: .leading, spacing: 4) {
                Text(destinationName)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color.accentColor)
                        .accessibilityHidden(true)

                    Text("You're exploring")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let localTime = localTimeText(for: context.date) {
                    Text("Local time: \(localTime)")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel(for: context.date))
            .accessibilityHint("Shows the current destination and local time.")
        }
    }

    private var timeZone: TimeZone? {
        switch destinationName {
        case "Barcelona":
            return TimeZone(identifier: "Europe/Madrid")
        case "Paris":
            return TimeZone(identifier: "Europe/Paris")
        case "Athens":
            return TimeZone(identifier: "Europe/Athens")
        case "Rome":
            return TimeZone(identifier: "Europe/Rome")
        case "Helsinki":
            return TimeZone(identifier: "Europe/Helsinki")
        case "Copenhagen":
            return TimeZone(identifier: "Europe/Copenhagen")
        case "Lisbon":
            return TimeZone(identifier: "Europe/Lisbon")
        default:
            return nil
        }
    }

    private func localTimeText(for date: Date) -> String? {
        guard let timeZone else { return nil }

        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func accessibilityLabel(for date: Date) -> String {
        if let localTime = localTimeText(for: date) {
            return "Current destination: \(destinationName). Local time: \(localTime.replacingOccurrences(of: ":", with: " "))."
        }

        return "Current destination: \(destinationName)."
    }
}

#Preview {
    CityHeaderView(destinationName: "Paris")
        .padding()
}
