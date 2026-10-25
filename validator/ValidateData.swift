import Foundation

/// Command-line validation entry point for the bundled JSON catalog.
///
/// Compile this file together with the canonical models and DataStore service;
/// it intentionally uses the exact app decoder and DatasetValidator.
@main
struct ValidateData {
    static func main() throws {
        // Optional first argument: the data folder (the open catalog passes `v1`).
        let dataPath = CommandLine.arguments.dropFirst().first ?? "Pathly/Data"
        let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(dataPath, isDirectory: true)
        let decoder = PathlyDateCoding.decoder

        func decode<Value: Decodable>(_ type: Value.Type, _ name: String) throws -> Value {
            let data = try Data(contentsOf: root.appendingPathComponent(name))
            return try decoder.decode(type, from: data)
        }

        let dataset = try PathlyDataset(
            opportunities: decode([Opportunity].self, "opportunities.json"),
            places: decode([Place].self, "places.json"),
            organizations: decode([Organization].self, "organizations.json"),
            opportunityLocations: decode([OpportunityLocation].self, "opportunity_locations.json")
        )
        let issues = DatasetValidator.validate(dataset)
        let errors = issues.filter { $0.severity == .error }

        print(
            "Decoded \(dataset.opportunities.count) opportunities, "
            + "\(dataset.places.count) places, \(dataset.organizations.count) organizations, "
            + "and \(dataset.opportunityLocations.count) links."
        )
        for issue in issues {
            print("\(issue.severity.rawValue): \(issue.description)")
        }
        guard errors.isEmpty else {
            // exit() flushes the issue list above; a thrown error would crash before it's printed in CI logs.
            print(ValidationFailure(errorCount: errors.count).errorDescription ?? "")
            exit(1)
        }
        print("Validation completed with zero structural errors.")
    }
}

private struct ValidationFailure: LocalizedError {
    let errorCount: Int

    var errorDescription: String? {
        "Dataset validation found \(errorCount) structural error(s)."
    }
}
