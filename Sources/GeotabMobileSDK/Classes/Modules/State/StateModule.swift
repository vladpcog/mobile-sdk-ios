// Copyright © 2021 Geotab Inc. All rights reserved.

class StateModule: Module {
    let webDriveDelegate: WebDriveDelegate
    init(webDriveDelegate: WebDriveDelegate) {
        self.webDriveDelegate = webDriveDelegate
        super.init(name: "state")
        functions.append(DeviceFunction(module: self))
    }
}
