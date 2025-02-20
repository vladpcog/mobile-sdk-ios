import UIKit

class CameraModule: Module {
    let webDriveDelegate: WebDriveDelegate
    let viewPresenter: ViewPresenter
    let imagePicker = UIImagePickerController()
    init(webDriveDelegate: WebDriveDelegate, viewPresenter: ViewPresenter, moduleContainer: ModuleContainerDelegate) {
        self.webDriveDelegate = webDriveDelegate
        self.viewPresenter = viewPresenter
        super.init(name: "camera")
        functions.append(CaptureImageFunction(module: self, moduleContainer: moduleContainer))
    }
}
