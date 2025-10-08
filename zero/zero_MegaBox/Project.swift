import ProjectDescription

let project = Project(
    name: "zero_MegaBox",
    targets: [
        .target(
            name: "zero_MegaBox",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.zero-MegaBox",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "zero_MegaBox/Sources",
                "zero_MegaBox/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "zero_MegaBoxTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.zero-MegaBoxTests",
            infoPlist: .default,
            buildableFolders: [
                "zero_MegaBox/Tests"
            ],
            dependencies: [.target(name: "zero_MegaBox")]
        ),
    ]
)
