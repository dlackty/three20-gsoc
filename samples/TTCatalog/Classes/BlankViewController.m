#import "BlankViewController.h"

@implementation BlankViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
    self.title = @"Three20 Catalog";
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
  CGRect appFrame = [UIScreen mainScreen].applicationFrame;
  self.view = [[[UIView alloc] initWithFrame:appFrame] autorelease];;
  self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 30)];
  label.center = self.view.center;
  label.backgroundColor = [UIColor clearColor];
  
  label.textAlignment = UITextAlignmentCenter;
  label.textColor = [UIColor darkTextColor];
  label.text = @"Click the menu to browse the catalog of Three20";
  label.textColor = TTSTYLEVAR(textColor);
  
  [self.view addSubview:label];
  
  [label release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return TTIsSupportedOrientation(interfaceOrientation);
}


@end

