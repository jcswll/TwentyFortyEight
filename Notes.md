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