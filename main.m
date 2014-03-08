#include <Cocoa/Cocoa.h>
#include <objc/runtime.h>

Class AppDelClass;
Class ViewClass;

struct AppDel {
    id window;
};

BOOL AppDel_didFinishLaunching(id self, SEL _cmd, id notification) {
    struct AppDel * appDel = (struct AppDel *)self;

    appDel->window = objc_msgSend(objc_getClass("NSWindow"), sel_getUid("alloc"));

    appDel->window = objc_msgSend(appDel->window,
        sel_getUid("initWithContentRect:styleMask:backing:defer:"),
        (NSRect){0,0,200,200},
        NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask,
        NSBackingStoreRetained,
        NO);

    id view = objc_msgSend(objc_getClass("View"), sel_getUid("alloc"));
    view = objc_msgSend(view, sel_getUid("initWithFrame:"), (struct CGRect) { 0, 0, 200, 200 });

    objc_msgSend(appDel->window, sel_getUid("setContentView:"), view);
    objc_msgSend(appDel->window, sel_getUid("becomeFirstResponder"));
    objc_msgSend(appDel->window, sel_getUid("makeKeyAndOrderFront:"), self);

    return YES;
}

void View_drawRect(id self, SEL _cmd, CGRect rect) {
    id red      = objc_msgSend(objc_getClass("NSColor"), sel_getUid("blueColor")); 
    objc_msgSend(red, sel_getUid("set"));

    NSRectFill(NSMakeRect(0, 0, 200, 200));
}

void initAppDel() {
    AppDelClass = objc_allocateClassPair((Class)objc_getClass("NSObject"), "MyAppDelegate", 0);
    class_addMethod(AppDelClass, sel_getUid("applicationDidFinishLaunching:"), (IMP)AppDel_didFinishLaunching, "i@:@");
    objc_registerClassPair(AppDelClass);

    ViewClass = objc_allocateClassPair((Class)objc_getClass("NSView"), "View", 0);
    class_addMethod(ViewClass, sel_getUid("drawRect:"), (IMP)View_drawRect, "v@:");
    objc_registerClassPair(ViewClass);

    objc_msgSend(objc_getClass("NSApplication"), sel_getUid("sharedApplication"));

    assert(NSApp);

    id appDelObj = objc_msgSend(objc_getClass("MyAppDelegate"), sel_getUid("alloc"));
    appDelObj = objc_msgSend(appDelObj, sel_getUid("init"));

    objc_msgSend(NSApp, sel_getUid("setDelegate:"), appDelObj);
    objc_msgSend(NSApp, sel_getUid("run"));

}

int main(int argc, char** argv) {
    initAppDel();
    return EXIT_SUCCESS;
}
