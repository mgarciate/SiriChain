//
//  sirichain_Tests.swift
//  sirichain-Tests
//
//  Created by mgarciate on 16/11/24.
//

import XCTest
@testable import sirichain_ios

final class sirichain_Tests: XCTestCase {
    let url = scrollSepoliaUrl
    var keystorePassword: String!
    var walletController: SiriChainWalletController!
    
    override func setUp() {
        _ = KeychainHelper.shared.saveKey(
            privateKey,
            service: KeychainHelper.servicePrivateKey,
            account: KeychainHelper.account
        )
        _ = KeychainHelper.shared.saveKey(
            "password",
            service: KeychainHelper.serviceKeystorePassword,
            account: KeychainHelper.account
        )
        walletController = SiriChainWalletController(clientUrl: url)
    }
    
    override class func tearDown() {
        _ = KeychainHelper.shared.deleteApiKey(
            service: KeychainHelper.servicePrivateKey,
            account: KeychainHelper.account
        )
        _ = KeychainHelper.shared.deleteApiKey(
            service: KeychainHelper.serviceKeystorePassword,
            account: KeychainHelper.account
        )
    }

    func testImportAccount() throws {
        XCTAssertNotNil(walletController.account)
        XCTAssertEqual(publicKey, walletController.account?.address.asString())
    }
    
    func testTransferEth() async throws {
        let txHash = try await walletController.transfer(to: Contact.dummyData[0].address, amount: 0.01)
        XCTAssertNotNil(txHash)
    }
    
    func testTransferERC20() async throws {
        let txHash = try await walletController.transfer(to: Contact.dummyData[0].address, amount: 10, token: NetworkToken.all[1])
        XCTAssertNotNil(txHash)
    }

    func testGasPrice() async throws {
        let gasPrice = try await walletController.getGasPrice()
        XCTAssertTrue(gasPrice > 0)
    }
}
