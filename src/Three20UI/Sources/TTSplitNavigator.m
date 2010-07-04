//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifdef __IPHONE_3_2

#import "TTSplitNavigator.h"

// UI
#import "Three20UI/TTNavigator.h"

// UI (private)
#import "Three20UI/TTSplitNavigatorWindow.h"

// UINavigator
#import "Three20UINavigator/TTURLMap.h"
#import "Three20UINavigator/TTURLAction.h"
#import "Three20UINavigator/TTGlobalNavigatorMetrics.h"

// UINavigator (private)
#import "Three20UINavigator/private/TTBaseNavigatorInternal.h"

// UICommon
#import "Three20UICommon/UIViewControllerAdditions.h"

// Core
#import "Three20Core/TTDebug.h"
#import "Three20Core/TTCorePreprocessorMacros.h"

static TTSplitNavigator *gSplitNavigator = nil;

@implementation TTSplitNavigator

@synthesize window = _window;
@synthesize URLMap = _URLMap;

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTSplitNavigator*)splitNavigator {
  if (nil == gSplitNavigator) {
    gSplitNavigator = [[TTSplitNavigator alloc] init];
  }
  return gSplitNavigator;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL) isActive {
	return nil != gSplitNavigator;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
  if (self = [super init]) {
    _URLMap = [[TTURLMap alloc] init];
    _navigators = [[NSArray alloc] initWithObjects:
                   [[[TTNavigator alloc] initWithURLMap:_URLMap] autorelease],
                   [[[TTNavigator alloc] initWithURLMap:_URLMap] autorelease],
                   nil];
		
		for (TTNavigator* navigator in _navigators) {
			navigator.window = self.window;
		}
		
  }
	
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
  TT_RELEASE_SAFELY(_navigators);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UISplitViewControllerDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) splitViewController: (UISplitViewController*)svc
      willHideViewController: (UIViewController*)aViewController
           withBarButtonItem: (UIBarButtonItem*)barButtonItem
        forPopoverController: (UIPopoverController*)pc {
	
  NSString* title = self.leftNavigator.rootViewController.title;
	
  // No title means this button isn't going to display at all. Consider setting popoverButtonTitle
  // if you can't guarantee that your navigation view will have a title.
  barButtonItem.title = title;
	
  UIViewController* viewController = self.rightNavigator.rootViewController;
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navController = (UINavigationController*)viewController;
    if ([navController.viewControllers count] == 1) {
      [navController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
    }
		
  } else {
    // Not implemented
    TTDASSERT(NO);
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) splitViewController: (UISplitViewController*)svc
      willShowViewController: (UIViewController*)aViewController
   invalidatingBarButtonItem: (UIBarButtonItem*)barButtonItem {
  UIViewController* viewController = self.rightNavigator.rootViewController;
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navController = (UINavigationController*)viewController;
    [navController.navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
		
  } else {
    // Not implemented
    TTDASSERT(NO);
  }
	
  TT_RELEASE_SAFELY(_popoverController);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public methods


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (UIWindow*) window {
  if (nil == _window) {
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    if (nil != keyWindow) {
      _window = [keyWindow retain];
			
    } else {
      _window = [[TTSplitNavigatorWindow alloc] initWithFrame:TTScreenBounds()];
      [_window makeKeyAndVisible];
    }
  }
  return _window;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (UISplitViewController*) rootViewController {
  if (nil ==  _rootViewController) {
		_rootViewController = [[UISplitViewController alloc] init]; 
		_rootViewController.delegate = self;
  }
	
  return _rootViewController;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (TTNavigator*) leftNavigator {
	return [_navigators objectAtIndex:0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (TTNavigator*) rightNavigator {
	return [_navigators objectAtIndex:1];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @public
 */
- (void) restoreViewControllersWithDefaultURLs:(NSArray*)urls {
	if (![self.leftNavigator restoreViewControllers]) {
		[self.leftNavigator openURLAction:[TTURLAction actionWithURLPath:[urls objectAtIndex:0]]];
	}
	
	if (![self.rightNavigator restoreViewControllers]) {
		[self.rightNavigator openURLAction:[TTURLAction actionWithURLPath:[urls objectAtIndex:1]]];
	}
	
	TTNavigator *left = self.leftNavigator;
	UIViewController *leftViewController = left.rootViewController;
	
	NSArray *viewControllers = [NSArray arrayWithObjects:self.leftNavigator.rootViewController,
															self.rightNavigator.rootViewController,nil];
	
  self.rootViewController.viewControllers = viewControllers;
	
  [self.window addSubview:self.rootViewController.view];
}

@end

#endif
