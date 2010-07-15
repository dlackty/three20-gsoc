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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTNavigator;
@class TTURLMap;
@class TTURLAction;
@protocol TTNavigatorDelegate;

/**
 * As a split naviagtor for iPad, TTSplitNaviagtor contains two TTNavigator for right and left sides of the split view.
 */

@interface TTSplitNavigator : NSObject <UISplitViewControllerDelegate> {
  id<TTNavigatorDelegate> _delegate;
	
	UIWindow*								_window;
	UISplitViewController*  _rootViewController;
	
	NSArray*								_navigators;
	
	TTURLMap*								_URLMap;
	
	UIPopoverController*		_popoverController;
}

/**
 * Provide an access to global navigator
 */
+ (TTSplitNavigator*)splitNavigator;

/**
 * Provide an access to global navigator
 */
+ (BOOL)isActive;

/*
 * Try to view controllers hierarchy for both navigators. If not possible, then open with default urls  
 */
- (void) restoreViewControllersWithDefaultURLs:(NSArray*)urls;

/**
 * Load and display the view controller with a pattern that matches the URL.
 *
 * Each apply* method on the TTURLAction object returns self, allowing you to chain methods
 * when initializing the object. This allows for a flexible method that requires a shifting set
 * of parameters that have specific defaults.
 * 
 * different from the openURLAction of TTNavigator, the following one will check the split navigation target,
 * and then forward the URLAction to the target navigtor.
 */
- (UIViewController*)openURLAction:(TTURLAction*)URLAction;

/**
 * The window which contains the view controller hiearchy.
 *
 * By default retrieves the keyWindow. If there is no keyWindow, creates a new
 * TTSplitNavigatorWindow.
 */
@property (nonatomic, assign) UIWindow* window;

/**
 * The splitView controller at the root of the view controller hierarchy.
 */
@property(nonatomic,retain) TTURLMap* URLMap;

/**
 * The splitView controller at the root of the view controller hierarchy.
 */
@property(nonatomic,readonly) UISplitViewController* rootViewController;

/**
 * The navigator for the left view controller
 */
@property(nonatomic,readonly) TTNavigator* leftNavigator;

/**
 * The navigator for the right view controller
 */
@property(nonatomic,readonly) TTNavigator* rightNavigator;


@end

#endif
