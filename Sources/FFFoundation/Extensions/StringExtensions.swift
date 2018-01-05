//
//  StringExtensions.swift
//  FFFoundation
//
//  Created by Florian Friedrich on 20/11/15.
//  Copyright 2015 Florian Friedrich
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if os(iOS) || os(tvOS) || os(macOS)
    import class Foundation.NSAttributedString
    import struct CoreGraphics.CGFloat
    import struct CoreGraphics.CGSize
    
    public extension String {
        public func size(forWidth width: CGFloat, attributes: NSAttributedString.AttributesDictionary? = nil) -> CGSize {
            return NSAttributedString(string: self, attributes: attributes).size(forWidth: width)
        }
        
        public func height(forWidth width: CGFloat, attributes: NSAttributedString.AttributesDictionary? = nil) -> CGFloat {
            return size(forWidth: width, attributes: attributes).height
        }
    }
#endif
