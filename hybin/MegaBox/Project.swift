import ProjectDescription

let project = Project(
    name: "MegaBox",
    targets: [
        .target(
            name: "MegaBox",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.MegaBox",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "MegaBox/Sources",
                "MegaBox/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "MegaBoxTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.MegaBoxTests",
            infoPlist: .default,
            buildableFolders: [
                "MegaBox/Tests"
            ],
            dependencies: [.target(name: "MegaBox")]
        ),
    ]
)
