#import "FlutterCompassPlugin.h"
#import <flutter_compass_v2/flutter_compass_v2-Swift.h>

@implementation FlutterCompassPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterCompassPlugin registerWithRegistrar:registrar];
}
@end
