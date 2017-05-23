import PackageDescription

let package = Package(
    name: "hello",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/vapor/postgresql-provider.git", majorVersion: 2, minor: 0)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

