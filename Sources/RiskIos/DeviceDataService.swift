//
//  DeviceDataService.swift
//  RiskIos
//  Sources
//
//  Created by Precious Ossai on 30/10/2023.
//

import Foundation

public struct FingerprintIntegration: Decodable, Equatable {
    let enabled: Bool
    let publicKey: String?
}

public struct DeviceDataConfiguration: Decodable, Equatable {
    let fingerprintIntegration: FingerprintIntegration
}

class DeviceDataService {
    public let config: RiskSdkInternalConfig
    public let apiService: ApiServiceProtocol
    
    public init(config: RiskSdkInternalConfig, apiService: ApiServiceProtocol = ApiService()) {
        self.config = config
        self.apiService = apiService
    }
    
    public func getConfiguration(completion: @escaping (DeviceDataConfiguration) -> Void) {
        let endpoint = "\(config.deviceDataEndpoint)/configuration?integrationType=\(config.integrationType)"
        let authToken = config.merchantPublicKey

        apiService.getJSONFromAPIWithAuthorization(endpoint: endpoint, authToken: authToken, responseType: DeviceDataConfiguration.self) {
            result in
            switch result {
            case .success(let configuration):
                completion(configuration)
            case .failure:
                completion(DeviceDataConfiguration(fingerprintIntegration: FingerprintIntegration(enabled: false, publicKey: nil)))
            }
        }
    }

}
