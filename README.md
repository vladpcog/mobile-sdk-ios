[![GitHub license](https://img.shields.io/github/license/Geotab/mobile-sdk-ios)](https://github.com/Geotab/mobile-sdk-ios/blob/main/LICENSE) [![GitHub docs](https://img.shields.io/badge/docs-passing-brightgreen)](https://geotab.github.io/mobile-sdk-ios/Classes/DriveViewController.html) [![GitHub swift](https://img.shields.io/badge/swift-4%20%7C%204.2%20%7C%205-brightgreen)](https://swift.org/) [![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/Geotab/mobile-sdk-ios?label=release)](https://github.com/Geotab/mobile-sdk-ios/tags)

# Mobile SDK iOS

## How to start 

### Installation

Geotab Mobile SDK is a Swift Package. Refer to Apple document for how to add the SDK to your project: https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app

Using the Mobile SDK with SwiftUI is not recommended. 


**Add Background mode capabilities**

In your app's "Signing and Capabilities" section, add "Background mode" section and check the "Audio, Airplay and Picture in Picture" and "Location updates" options. 


**Info.plist**

The following keys must be added to your app's Info.plist:

- "Privacy - Location Always Usage Description"
- "Privacy - Location Always and When In Use Usage Description"
- "Privacy - Location When In Use Usage Description"
- "Privacy - Camera Usage Description"
- "Privacy - Photo Library Usage Description"
- "Privacy - Face ID Usage Description"
- "Privacy - Bluetooth Always Usage Description"
- "Privacy - Motion Usage Description"

### What is DriveViewController

DriveViewController is the starting point of integrating Geotab Drive SDK. It's the container of the Geotab Drive Web app equipped with native APIs for accessing Geotab Drive web app's data.

### Initialization

Inside your `main` controller, define a property that holds the instance of DriveViewController

```swift
private var driveVC: DriveViewController!
```

If your drivers should login from a specific Geotab server, then you should set the serverAddress first:

```swift
DriveSdkConfig.serverAddress = "<server-name>.geotab.com"
```

Note: Do not prefix with "https://". SDK prefixes "https://" by default.


You should also set up a listener for `LastServerAddress` update:

```swift
driveVC.setLastServerAddressUpdatedCallback { server in
    let store = UserDefaults.standard
    store.setValue(server, forKey: MainViewController.GEOTAB_DRIVE_LAST_SERVER_KEY)
    DriveSdkConfig.serverAddress = server
}
```

Whenever `LastServerAddress` is changed. it should be saved in persistent storage. At the next launch of your app, you should read the value from your persistent storage and set it to `DriveSdkConfig.serverAddress` before executing any Drive SDK APIs.

Initialize the instance during `viewDidLoad()` of your `main` controller

```swift
driveVC = DriveViewController(modules: [])
```

### Login

GeotabDriveSDK allow integrators use their own authentication and user management. All the SDK needs to know to log into Geotab Drive is user's credential. 

Tell DriveViewController about the user credential as follows:

```swift
driveVC.setSession(credentialResult: CredentialResult, isCoDriver: <set to true if it's a co-driver login>)
```

where credentials is a type of: 

```swift
public struct GeotabCredentials: Codable {
    
    var userName: String
    var database: String
    var sessionID: String
    
    public init(userName: String, database: String, sessionID: String){
        self.userName = userName
        self.database = database
        self.sessionID = sessionID
    }
}
```

See `GeotabCredentials.swift`.



### Present the DriveViewController

Once user credentials are given, present the driveVC to user. DriveViewController will automatically validate the session and continue through the normal Drive workflow.

```swift
self.present(driveVC, animated: true)
```

### Session expire/Invalid/No-session and co-driver Login

To get notified when a user session is expired. Set a listener callback as follows:

```swift
driveVC.setLoginRequiredCallback { (status, errorMessage) in
    ... ...
}
```

Set a callback to listen for session changes. That includes: no session, invalid session, session expired, co-driver login is requested.

- Parameters:
   - callback: `LoginRequiredCallbackType`
           - status: `""` `"LoginRequired"`, `"AddCoDriver"`.
           - errorMessage: Error happened during login process and error info is given in `errorMessage`.

There are three defined values and variance of different error messages that could be passed in the callback.

- "", empty string, indicates no login required or login is successful, or the login is in progress. At this state, implementor should presents the DriveViewControlleFragment.
- "LoginRequired": indicates the login UI is going to show a login form(No valid user is available or the current activeSession is expired/invalid). At this stateimplementor presents its own login screen.
- "AddCoDriver": indicates that a co-driver login is requested. At this state, implementor presents its own co-driver login screen.
- Any error message, any other error messages. At this state, implementor presents its own login screen.

After receiving such session expired callback call. Integrator usually dismisses the presented `DriveViewController` and present user with its Login screen.

### Other important callbacks

There are couple of other callbacks you that can be useful for managing and watching DriveViewController.

- `DriveViewController::setDriverActionNecessaryCallback`: driverActionNecessary is a list of events that occur in our app where the application owner needs to bring the Drive app activity UI to the foreground. Example: "Your vehicle has been selected by another driver. You now need to select a vehicle".

- `DriveViewController::setPageNavigationCallback`: pageNavigation event indicates any navigation changes by the driver in Geotab Drive.

- `DriveViewController::setLastServerAddressUpdatedCallback`: Drive tells the integrator which server address is used after a user successful login. This server address must be used for future logins of other users of the same company. Integrators can save the received `server` address to a persistant storage and when the app restarts next time, update the `DriveSdkConfig.serverAddress` with the saved one. This will let SDK know which Geotab server to use.

See more details in the [API document](https://geotab.github.io/mobile-sdk-ios/Classes/DriveViewController.html).


### Overwrite Default Background color, font color and icon

To override default background color in the network error page, create a property in Info.plist with the name "NetworkErrorScreenBckColor" of type String and add a hex value for the color
To override default font color in the network error page, create a property in Info.plist with the name "NetworkErrorScreenFontColor" of type String and add a hex value for the color
To override default font color in the network error page, create a property in Info.plist with the name "NetworkErrorScreenIcon" of type String and add the name of the image. The image must also be added to the project.


## Drive APIs

All drive APIs are accessible directly under an instance of `DriveViewController` or `MyGeotabbViewController`. See more details in the [API document](https://geotab.github.io/mobile-sdk-ios/).

## License

GeotabDriveSDK is available under the MIT license. See the LICENSE file for more info.
