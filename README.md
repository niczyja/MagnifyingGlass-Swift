
# MagnifyingGlass

A magnifying glass view for iOS platform written in Swift. Easily create and customize magnifying glass effect (with optional crosshair) on given view. Available as a Swift package.

![Magnifying Glass](http://niczyja.pl/projekty/shots/MagnifyingGlass.gif)

Image credit: "Crouching Tiger, Hidden Dragon" by Philippe Vieux-Jeanton is marked with CC0 1.0

## Usage/Examples

Instantiate `MagnifyingGlassView` in any view or view controller by using convenience initializer:

```swift
let magnifyingGlass = MagnifyingGlassView(offset: CGPoint = CGPoint.zero,
                                          radius: CGFloat = 50.0,
                                          scale: CGFloat = 2.0,
                                          borderColor: UIColor = UIColor.lightGray,
                                          borderWidth: CGFloat = 3.0,
                                          showsCrosshair: Bool = true,
                                          crosshairColor: UIColor = UIColor.lightGray,
                                          crosshairWidth: CGFloat = 0.5)
```

All arguments have default values so you can use only ones that you need. You can also directly access any of these parameters at any time of the view lifecycle.

When you're ready to show magnifying glass just give it the view that you'd like to magnify and specify magnication location:

```swift
magnifyingGlass.magnifiedView = view
magnifyingGlass.magnify(at: location) // location: CGPoint
```

When you want to hide magnifying glass set `magnifiedView` to `nil`:

```swift
magnifyingGlass.magnifiedView = nil
```

Here's more complete example use of `MagnifyingGlassView` in view controller where glass follows touch point:

```swift
import UIKit
import MagnifyingGlass

class ViewController: UIViewController {
    
    let magnifyingGlass = MagnifyingGlassView(offset: CGPoint(x: 50.0, y: -50.0), radius: 50.0, scale: 2.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isMultipleTouchEnabled = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: view)
        
        magnifyingGlass.magnifiedView = view
        magnifyingGlass.magnify(at: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: view)

        magnifyingGlass.magnify(at: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        magnifyingGlass.magnifiedView = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        magnifyingGlass.magnifiedView = nil
    }
    
}
```
## License

[MIT](https://github.com/niczyja/MagnifyingGlass-Swift/blob/main/LICENSE)

  
