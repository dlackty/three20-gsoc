#import "AppDelegate.h"
#import "CatalogController.h"
#import "PhotoTest1Controller.h"
#import "PhotoTest2Controller.h"
#import "ImageTest1Controller.h"
#import "TableImageTestController.h"
#import "YouTubeTestController.h"
#import "TableItemTestController.h"
#import "TableControlsTestController.h"
#import "TableTestController.h"
#import "TableWithShadowController.h"
#import "SearchTestController.h"
#import "MessageTestController.h"
#import "ActivityTestController.h"
#import "ScrollViewTestController.h"
#import "LauncherViewTestController.h"
#import "StyledTextTestController.h"
#import "StyledTextTableTestController.h"
#import "StyleTestController.h"
#import "ButtonTestController.h"
#import "TabBarTestController.h"
#import "BlankViewController.h"

@implementation AppDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication*)application {
  TTURLMap *map;
  
  // Basic setup
	if (TTIsPad()) {
		TTSplitNavigator *splitNavigator = [TTSplitNavigator splitNavigator];
    map = splitNavigator.URLMap;
    splitNavigator.popoverTitle = @"Catalog";
	} else {
		TTNavigator *navigator = [TTNavigator navigator];
    map = navigator.URLMap;
    navigator.supportsShakeToReload = YES;
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	}
  
  // URLMapping
  if (TTIsPad()) {
    [map from:@"*" toEmptyHistoryViewController:[TTWebController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://catalog" toEmptyHistoryViewController:[CatalogController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://photoTest1" toEmptyHistoryViewController:[PhotoTest1Controller class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://photoTest2" toEmptyHistoryViewController:[PhotoTest2Controller class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://imageTest1" toEmptyHistoryViewController:[ImageTest1Controller class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tableTest" toEmptyHistoryViewController:[TableTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tableItemTest" toEmptyHistoryViewController:[TableItemTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tableControlsTest" toEmptyHistoryViewController:[TableControlsTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://styledTextTableTest" toEmptyHistoryViewController:[StyledTextTableTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tableWithShadow" toEmptyHistoryViewController:[TableWithShadowController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://composerTest" toEmptyHistoryViewController:[MessageTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://searchTest" toEmptyHistoryViewController:[SearchTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://activityTest" toEmptyHistoryViewController:[ActivityTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://styleTest" toEmptyHistoryViewController:[StyleTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://styledTextTest" toEmptyHistoryViewController:[StyledTextTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://buttonTest" toEmptyHistoryViewController:[ButtonTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tabBarTest" toEmptyHistoryViewController:[TabBarTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://youTubeTest" toEmptyHistoryViewController:[YouTubeTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://imageTest2" toEmptyHistoryViewController:[TableImageTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://scrollViewTest" toEmptyHistoryViewController:[ScrollViewTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://launcherTest" toEmptyHistoryViewController:[LauncherViewTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://blank" toEmptyHistoryViewController:[BlankViewController class] inSplitView:TTSplitNavigationTargetRight];
  } else {
    [map from:@"*" toViewController:[TTWebController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://catalog" toViewController:[CatalogController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://photoTest1" toViewController:[PhotoTest1Controller class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://photoTest2" toViewController:[PhotoTest2Controller class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://imageTest1" toViewController:[ImageTest1Controller class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tableTest" toViewController:[TableTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tableItemTest" toViewController:[TableItemTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tableControlsTest" toViewController:[TableControlsTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://styledTextTableTest" toViewController:[StyledTextTableTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tableWithShadow" toViewController:[TableWithShadowController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://composerTest" toViewController:[MessageTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://searchTest" toViewController:[SearchTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://activityTest" toViewController:[ActivityTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://styleTest" toViewController:[StyleTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://styledTextTest" toViewController:[StyledTextTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://buttonTest" toViewController:[ButtonTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://tabBarTest" toViewController:[TabBarTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://youTubeTest" toViewController:[YouTubeTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://imageTest2" toViewController:[TableImageTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://scrollViewTest" toViewController:[ScrollViewTestController class] inSplitView:TTSplitNavigationTargetRight];
    [map from:@"tt://launcherTest" toViewController:[LauncherViewTestController class] inSplitView:TTSplitNavigationTargetRight];
  }

  // Restore ViewControllers
	if (TTIsPad()) {
		[[TTSplitNavigator splitNavigator] restoreViewControllersWithDefaultURLs: [NSArray arrayWithObjects: @"tt://catalog", @"tt://blank", nil]];
	} else {
    TTNavigator *navigator = [TTNavigator navigator];
		if (![navigator restoreViewControllers]) {
			[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://catalog"]];
		}
	}
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  return YES;
}

@end
