#  Risk iOS package
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Risk.svg)](https://img.shields.io/cocoapods/v/Risk)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/checkout/checkout-risk-sdk-ios?label=spm)
[![Platform](https://img.shields.io/cocoapods/p/Risk.svg?style=flat)]()
![license](https://img.shields.io/github/license/checkout/checkout-risk-sdk-ios.svg)

The package helps collect device data for merchants with direct integration (standalone) with the package and those using [Checkout's Frames iOS package](https://github.com/checkout/frames-ios).

## Table of contents
- [Risk iOS package](#risk-ios-package)
  - [Table of contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Documentation](#documentation)
    - [Usage guide](#usage-guide)
    - [Public API](#public-api)
    - [Additional Resources](#additional-resources)
  - [Demo projects](#demo-projects)
  - [Changelog](#changelog)
  - [Contributing](#contributing)
  - [License](#license)


## Requirements
- iOS 13.0+
- Xcode 12.4+
- Swift 5.3+

## Documentation
### Usage guide
  1. Add `Risk` as a package dependency - _see [Installation guide](https://github.com/checkout/checkout-risk-sdk-ios/blob/main/.github/partial-readmes/Installation.md) on how to add our SDK in your iOS app via SPM or Cocoapods._
  2. Obtain a public API key from [Checkout Dashboard](https://dashboard.checkout.com/developers/keys).
  3. Initialise the package with the `getInstance` method passing in the required configuration (public API key and environment), then publish the device data with the `publishData` method, see example below.
```swift
// Example usage of package
let yourConfig = RiskConfig(publicKey: "pk_qa_xxx", environment: RiskEnvironment.qa)
            
Risk.getInstance(config: yourConfig) { riskInstance in
    riskInstance?.publishData() { response in
        print(response.deviceSessionId)
    }
}
 ```

### Public API
The package exposes two methods:
1. `getInstance` - This is a method that returns a singleton instance of Risk. When the method is called, preliminary checks are made to Checkout's internal API(s) that retrieves the public keys used to initialise the package used in collecting device data, if the checks fail or the merchant is disabled, nil will be returned, else, if the checks are successful, the `Risk` instance is returned to the consumer of the package which can now be used to publish the data with the `publishData` method.

    <details>
    <summary>Arguments</summary>

    ```swift
    public struct RiskConfig {
        public let publicKey: String
        public let environment: RiskEnvironment
        public let framesMode: Bool
        
        public init(publicKey: String, environment: RiskEnvironment, framesMode: Bool = false) {
            self.publicKey = publicKey
            self.environment = environment
            self.framesMode = framesMode
        }
    }

    public enum RiskEnvironment {
        case qa
        case sandbox
        case prod
    }
    ```
    </details>

    <details>
    <summary>Responses</summary>

    ```swift
    public class Risk {
        ...

        public func publishData(...) ... {
                ...
        }
    }
    ```
    </details>


2. `publishData` - This is used to publish and persist the device data.

    <details>
    <summary>Arguments</summary>

    ```swift
    public func publishData(cardToken: String? = nil, completion: @escaping (Result<PublishRiskData, RiskError>) -> Void) {
            ...
    }
    ```
    </details>

    <details>
    <summary>Responses</summary>

    ```swift
    public struct PublishRiskData {
        public let deviceSessionId: String
    }

    public enum RiskError: Error, Equatable {
        case description(String)
        
        var localizedDescription: String {
            switch self {
            case .description(let errorMessage):
                return errorMessage
            }
        }
    }
    ```
    </details>

### Additional Resources
<!-- TODO: Add website documentation link here - [Risk iOS SDK documentation](https://docs.checkout.com/risk/overview) -->
- [Frames iOS SDK documentation](https://www.checkout.com/docs/developer-resources/sdks/frames-ios-sdk)

## Demo projects
Our sample application showcases our prebuilt UIs and how our SDK works. You can run this locally once you clone the repository (whether directly via git or with suggested integration methods).

Our demo apps also test the supported integration methods (SPM, Cocoapods), so if you're having any problems there, they should offer a working example. You will find them in the root of the repository, inside respective folders:
- iOSExampleRiskCocoapods - (Cocoapods distribution)
- iOSExampleRiskSPM - (SPM distribution)
 
## Changelog
Find our CHANGELOG.md [here](https://github.com/checkout/checkout-risk-sdk-ios/blob/main/.github/CHANGELOG.md).

## Contributing
Find our guide to start contributing [here](https://github.com/checkout/checkout-risk-sdk-ios/blob/main/.github/CONTRIBUTING.md).

## License
Risk iOS is released under the MIT license. [See LICENSE](https://github.com/checkout/checkout-risk-sdk-ios/blob/main/LICENSE) for details.
