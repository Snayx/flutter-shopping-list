#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "GoogleMaps.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  GMSServices.provideAPIKey("AIzaSyDWqKmB6qMJ1SXY9Fzh4gB0q2-MnIsTEyY");
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
