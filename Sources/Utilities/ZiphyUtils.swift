//
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
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

import Foundation

/**
 * The result of an operation, either success or failure.
 */

public enum Result<T, E: Error> {
    case success(T)
    case failure(E)

    var error: E! {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }
}

/**
 * A task that can be cancelled.
 */

public protocol CancelableTask {
    func cancel()
}

/**
 * An opaque object that identifies as a single Ziphy network request
 */

@objc public protocol ZiphyRequestIdentifier {}

/**
 * An object that performs network requests to the Giphy API.
 */

@objc public protocol ZiphyURLRequester {
    
    func performZiphyRequest(_ request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> ZiphyRequestIdentifier


    func cancelZiphyRequest(withRequestIdentifier requestIdentifier: ZiphyRequestIdentifier)

}
