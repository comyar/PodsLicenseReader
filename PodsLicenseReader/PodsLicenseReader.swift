//
//  PodsLicenseReader.swift
//  PodsLicenseReader
//
//  Copyright (c) 2015 Comyar Zaheri. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//


// MARK:- Imports

import Foundation


// MARK:- License

/**
Represents a single Cocoa Pods license.
*/
public class License {
    
    // MARK: Properties
    
    /**
    The name of the Cocoa Pod.
    */
    public let name: String
    
    /**
    The text of the license.
    */
    public let text: String
    
    private let empty: Bool
    
    // MARK: Creating a License
    
    private convenience init() {
        self.init(name: nil, text: nil, empty: true)
    }
    
    private convenience init(name: String, text: String) {
        self.init(name: name, text: text, empty: false)
    }
    
    private init(name: String?, text: String?, empty: Bool) {
        self.name = empty ? "" : name!
        self.text = empty ? "" : text!
        self.empty = empty
    }
}


// MARK:- PodsLicenseReader

/**
A PodsLicenseReader allows for the reading of Cocoa Pods licenses.
*/
public class PodsLicenseReader {
    
    private let root: NSDictionary
    private var licenses: [License]?
    
    // MARK: Creating a Pods License Reader
    
    /**
    Initializes a new PodsLicenseReader using the default filename 
    'Pods-acknowledgements.plist'.
    */
    public convenience init() {
        self.init(path: NSBundle.mainBundle().pathForResource("Pods-acknowledgements", ofType: "plist"))
    }

    /**
    Initializes a new PodsLicenseReader.
    
    - parameter path: Path to the plist file to read from.
    */
    public init(path: String?) {
        if let _ = path, root = NSDictionary(contentsOfFile: path!) {
            self.root = root
        } else {
            self.root = NSDictionary()
            print("Failed to read licenses for path: \(path)")
        }
    }
    
    // MARK: Using a Pods License Reader
    
    /**
    Returns all the licenses
    
    - returns: An array of licenses
    */
    public func getLicenses() -> [License] {
        if let l = licenses {
            return l
        }
        
        let ps: AnyObject? = root["PreferenceSpecifiers"]
        if let ps = ps where ps is [AnyObject] {
            let specifiers = ps as! [AnyObject]
            licenses = specifiers[1..<specifiers.count-1].map({ (s: AnyObject) -> License in
                if let title = s["Title"] as! String?, text = s["FooterText"] as! String? {
                        return License(name: title, text: text)
                } else {
                    return License()
                }
            }).filter({ (l: License) -> Bool in
                return !l.empty
            })
        } else {
            licenses = []
        }
        
        return licenses!
    }
}
