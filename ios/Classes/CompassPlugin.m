#import "CompassPlugin.h"
#if __has_include(<compass/compass-Swift.h>)
#import <compass/compass-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "compass-Swift.h"
#endif

@implementation CompassPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCompassPlugin registerWithRegistrar:registrar];
}
@end
