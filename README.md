# Concord iOS App

Prototype app that uses [SMARTMarkers][sm] and its dependencies to aggregate FHIR data from Apple Health app for submission to a FHIR server

Most EHR data today is in FHIR 1.0, SMART Markers framework transforms this data to FHIR R4 for submission to a provided Endpoint.

# Installation

`git clone --recursive https://github.com/raheelsayeed/concord-ios`

### 1. Dependencies

- [Add SMARTMarkers][sm-install] to the build directory with its submodules
- __Make sure these files are the project directory in Xcode__
    1. `ResearchKit.xcodeproj`
    2. `SMARTMarkers.xcodeproj`
    3. `SwiftSMART.xcodeproj`
- Compile all the above submodule builds against the target device (iPhone in this case) 

### 2. Configuring the iOS Simulator to add sample FHIR data in its Health App

- Follow instructions [here](https://developer.apple.com/documentation/healthkit/samples/accessing_sample_data_in_the_simulator)
- All data is fake, synthetic, provided by Apple

### 3. Build and Run Concord!

### [more sample apps][samples]

# License: MIT


[sm]: https://github.com/smartmarkers/smartmarkers-ios
[sm-install]: https://github.com/SMARTMarkers/smartmarkers-ios/blob/master/Installation.md
[samples]: https://github.com/SMARTMarkers/easipro-patient-ios
