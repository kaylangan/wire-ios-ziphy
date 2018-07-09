//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import XCTest
@testable import Ziphy

class ZiphyRequestGeneratorTests: XCTestCase {

    var generator: ZiphyRequestGenerator!

    override func setUp() {
        super.setUp()
        generator = ZiphyRequestGenerator(host: "localhost")
    }

    override func tearDown() {
        generator = nil
        super.tearDown()
    }

    func testThatItGeneratesSearchRequestWithEscaping() {
        // GIVEN
        let searchTerm = "ryan gosling"

        // WHEN
        let request = generator.makeSearchRequest(term: searchTerm, resultsLimit: 10, offset: 5)

        // THEN
        verifyURL(request, expected: "https://localhost/v1/gifs/search?limit=10&offset=5&q=ryan%20gosling")
    }

    func testThatItGeneratesTrendingRequest() {
        let request = generator.makeTrendingImagesRequest(resultsLimit: 10, offset: 5)
        verifyURL(request, expected: "https://localhost/v1/gifs/trending?limit=10&offset=5")
    }

    func testThatItGeneratesRandomRequest() {
        let request = generator.makeRandomImageRequest()
        verifyURL(request, expected: "https://localhost/v1/gifs/random")
    }

    func testThatItGeneratesFetchRequestForSingleImage() {
        // GIVEN
        let ids = ["xT4uQulxzV39haRFjG"]

        // WHEN
        let request = generator.makeImageFetchRequest(identifiers: ids)

        // THEN
        verifyURL(request, expected: "https://localhost/v1/gifs?ids=xT4uQulxzV39haRFjG")
    }

    func testThatItGeneratesFetchRequestForMultipleImage() {
        // GIVEN
        let ids = ["xT4uQulxzV39haRFjG,3og0IPxMM0erATueVW"]

        // WHEN
        let request = generator.makeImageFetchRequest(identifiers: ids)

        // THEN
        verifyURL(request, expected: "https://localhost/v1/gifs?ids=xT4uQulxzV39haRFjG,3og0IPxMM0erATueVW")
    }

    // MARK: - Utilities

    private func verifyURL(_ potentialResult: Result<URLRequest, ZiphyError>, expected: String) {
        switch potentialResult {
        case .success(let request):
            guard let url = request.url else {
                XCTFail("The generated requests did not contain a URL.")
                return
            }

            XCTAssertEqual(url.absoluteString, expected)

        case .failure(let error):
            XCTFail("URL generation failed with error: \(error)")
        }
    }

}
