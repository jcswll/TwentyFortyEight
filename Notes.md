Translating `TFEGameController` to Swift: method name disparity between platforms is a problem. `viewWillAppear()` from `NSViewController` vs. `viewWillAppear(_:)` from `UIViewController`. These must be `override` when compiled for their particular platforms, and _cannot_ be when not, so:

    override func viewWillAppear()
    {
        self.viewWillAppear(false)
    }
    
    func viewWillAppear(animated: Bool)
    {
        // Do something
    }

Compiles on OS X but not on iOS, and:

    override func viewWillAppear()
    {
        self.viewWillAppear(false)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // Do something
    }

compiles on neither.

This ugly but serviceable-in-ObjC option:

    #if os(OSX)
    override func viewWillAppear()
    #elseif os(iOS)
    override func viewWillAppear(animated: Bool)
    #endif
    {
        // Do something
    }
  
doesn't work because this isn't a preprocessor. The bits inside the branches have to be complete, syntactically valid Swift language elements.

One solution is providing method parity in the parent class:

    #if os(OSX)

    import Cocoa

    class TFEViewController : NSViewController
    {    
        override func viewWillAppear()
        {
            self.viewWillAppear(false)
        }
    
        func viewWillAppear(animated: Bool)
        {
            return
        }
    }

    #else
    
    import UIKit

    class TFEViewController : UIViewController {}
    
    #endif
    
The Swift version of `initWithNibName:bundle:` is even worse. It's failable on `NSViewController` but not on `UIViewController`. The same trick as above:

    #if os(OSX)

    import Cocoa

    class TFEViewController : NSViewController
    {    
        init(nibName name: String?, bundle bundle: NSBundle?)
        {
            super.init(nibName: name, bundle: bundle)!
        }
        //...
    }

    #else
    //...
    
Now means that "'required' initializer 'init(coder:)' must be provided by subclass of 'NSViewController'" (this was also required in ``TFEGameController`` itself, of course).

:table-flipping-emoticon:

I've resorted to this inside `TFEGameController`'s `init()`:

    #if os(OSX)
    super.init(nibName: "MainView", bundle: nil)!
    #elseif os(iOS)
    super.init(nibName: "MainView", bundle: nil)
    #endif
    
---

`TFEBoard`'s constructor taking the controller that builds it meant that the controller's `board` property had to become an IUO:

    // TFEGameController
    init()
    {
        self.scene = //...
        self.board = TFEBoard(controller: self, scene: self.scene)
        
        super.init...
    }
    
The references to `self` before calling up to `super` are invalid.

One way to resolve this would be to loosen up the board communication with the controller via callbacks.


---

Changing `TFEBoard` to a `struct` created a small problem in the game controller's Keyboard extension.

First, since the struct cannot be exposed at all to ObjC, I rewrote the extension in Swift.

More importantly, since the property is `private(set) var board`, it could not be "mutated" from the extension. (The mutation is necessary because moving nodes means reassigning the `grid`. Perhaps this would be done differently if the project had started in Swift.) The controller therefore now calls its own method, `userDidInput(_: TFENodeDirection)` defined in the main class body, from the extension. The board is visible for mutation inside that method, so `self.board.moveNodes(inDirection:)` can be called.

(This solution would also have fixed the first problem of the board not being visible at all in ObjC.)

This seems like a step backwards in organization from ObjC (a consequence of the lack of headers).

---

Subclassing SKSpriteNode was a headache. (Aside from the usual stupidity with `init(coder:)`) The initializer rules mean that `init(value:)` is forced to call `init(texture:color:size:)`, which is the only DI for SKSpriteNode. `init(texture:)` is a convenience initializer. So I'm _forced_ to supply a color rather than letting the superclass use its own default. I don't even know yet what the effect is.

Before I found the solution, there was some wrestling with an error about a constant property apparently not being settable inside a convenience initializer.

`textureForValue:` would be translated according to new Swift naming guidelines as `texture(forValue:)`, but since parameter names are not part of the function signature, that makes the natural `let texture = texture(forValue: value)` produce "error: variable used within its own initial value". The compiler can't figure out that the second `texture` is a function invocation for some reason.

---

Some weirdness when the `Tile`s protocol was introduced. The engine functions became generic; nodes inside them are types only as `Tile`s. This changed the way that equality worked for some reason.

`Tile` conforms to `Equatable`, as did/does `TFENode` (via `Comparable`). The `==` comparison in the sliding function called `==(_:TFENode,_:TFENode)` as expected. But when `Tile` was added, `SKSpriteNode.isEqual(_:)` was called instead. This appears to be dynamic dispatch through the protocol's `Self` (which is `TFENode`). Overriding `isEqual(_:)` in `TFENode` resolved it.
