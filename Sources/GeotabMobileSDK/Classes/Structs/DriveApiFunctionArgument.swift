// Copyright © 2021 Geotab Inc. All rights reserved.

import Foundation

struct DriveApiFunctionArgument: Codable {
    let callerId: String
    let error: String? // javascript given error, when js failed providing result, it provides error
    let result: String?
}
