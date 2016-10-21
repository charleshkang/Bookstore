# ProlificLibrary
View all books from the Prolific Library! Project was built using Swift 2.3, following the MVC design pattern.

![alt tag](https://github.com/charleshkang/ProlificLibrary/blob/master/prolificlibrary_demo.gif)

## Implementation
I chose MVC as the design pattern for this project because it's what I'm most used to, and through careful abstraction, can lead to a well-coded project. I used GCD to make my fetching code asynchronous, and because they are public functions, this leads to reusability in future projects. I implemented error handling in my `BookStatus` file, and took advantage of `guard`s early exit feature to ensure any errors from the backend were handled.

I chose to make the UI in Interface Builder because I like seeing the app's flow and design easily. I did not make individual storyboard files, as this was a simple 3 screen app that, in my opinion, would not be necessary.

Through my use of extensions, I've allowed my view controllers to stay neat.

I followed the Prolific Interactive style guide as closely as possible. Making sure each type has its own file, and assigning proper access control to type declarations and functions. I used a combination of `if let`, `guard`, and `nil coalescing` to safely unwrap optionals, only using `!` with IBOutlets and properties I have completely sure will have a value.

## Pods
- SwiftyJSON (handle JSON data better and more easily)
- Alamofire (to make networking simpler, and used in conjunction with SwiftyJSON)
- TextFieldEffects (to make a better UX for the input form)

## Requirements
- Xcode 7.3.1
- iOS 9.0(because of the use of stack views)

## Installation
- Install [Cocoapods](http://guides.cocoapods.org/using/getting-started.html#installation).
- cd to directory and use `pod init` to create a Podfile

```swift
open Podfile
```
- Add the following to Podfile
  ```swift
  source 'https://github.com/CocoaPods/Specs.git'
  platform :ios, '9.0'
  use_frameworks!

  pod 'Alamofire', '~> 3.0’
  pod 'SwiftyJSON', '2.4.0'
  pod 'TextFieldEffects', ‘1.2.0’
  ```
- Save and install pods
```swift
pod install
```
- Open ProlificLibrary.xcworkspace

## Features
- See all books from the Prolific Library in a table view
- Press the '+' button to add a new book in a modal view
- Press the trash button to delete all books
- Press on any book to see details, as well as check out a book
- Asynchronous handling of data fetching, as to not block the UI from making updates
- Share the book on Twitter or Facebook using the Social framework. You will need to be signed into Facebook or Twitter for sharing to work.

## Future Improvements and Features
- Unit Tests
- Implement handling when title and author fields are inputted as `" " `
