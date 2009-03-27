#import "Three20/TTTableFieldCell.h"
#import "Three20/TTTableField.h"
#import "Three20/TTStyleView.h"
#import "Three20/TTErrorView.h"
#import "Three20/TTNavigationCenter.h"
#import "Three20/TTURLCache.h"
#import "Three20/TTAppearance.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

static CGFloat kHPadding = 10;
static CGFloat kVPadding = 10;
static CGFloat kMargin = 10;
static CGFloat kSpacing = 8;

static CGFloat kKeySpacing = 12;
static CGFloat kKeyWidth = 75;
static CGFloat kMaxLabelHeight = 2000;

static CGFloat kTextFieldTitleWidth = 100;
static CGFloat kTableViewFieldCellHeight = 180;

static CGFloat kDefaultIconSize = 50;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTTableFieldCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  return TOOLBAR_HEIGHT;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _field = nil;
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:_label];
	}
	return self;
}

- (void)dealloc {
  [_field release];
  [_label release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];

  _label.frame = CGRectInset(self.contentView.bounds, kHPadding, 0);
}

-(void)didMoveToSuperview {
  [super didMoveToSuperview];
  if (self.superview && [(UITableView*)self.superview style] == UITableViewStylePlain) {
    _label.backgroundColor = self.superview.backgroundColor;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (id)object {
  return _field;
}

- (void)setObject:(id)object {
  if (_field != object) {
    [_field release];
    _field = [object retain];
  
    _label.text = _field.text;
    
    if (_field.url) {
      if ([[TTNavigationCenter defaultCenter] urlIsSupported:_field.url]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      } else {
        self.accessoryType = UITableViewCellAccessoryNone;
      }
      self.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
      self.accessoryType = UITableViewCellAccessoryNone;
      self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if ([object isKindOfClass:[TTButtonTableField class]]) {
      _label.font = [UIFont boldSystemFontOfSize:15];
      _label.textColor = [TTAppearance appearance].linkTextColor;
      _label.textAlignment = UITextAlignmentCenter;
      self.accessoryType = UITableViewCellAccessoryNone;
      self.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else if ([object isKindOfClass:[TTLinkTableField class]]) {
      _label.font = [UIFont boldSystemFontOfSize:16];
      _label.textColor = [TTAppearance appearance].linkTextColor;
      _label.textAlignment = UITextAlignmentLeft;
    } else if ([object isKindOfClass:[TTSummaryTableField class]]) {
      _label.font = [UIFont systemFontOfSize:17];
      _label.textColor = [TTAppearance appearance].tableSubTextColor;
      _label.textAlignment = UITextAlignmentCenter;
    } else {
      _label.font = [UIFont boldSystemFontOfSize:17];
      _label.textColor = [UIColor blackColor];
      _label.textAlignment = UITextAlignmentLeft;
    }
  }  
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTTextTableFieldCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  CGFloat maxWidth = tableView.width - (kHPadding*2 + kMargin*2);
  UIFont* font = nil;
  if ([item isKindOfClass:[TTGrayTextTableField class]]) {
    font = [UIFont systemFontOfSize:14];
  } else {
    font = [UIFont boldSystemFontOfSize:15];
  }

  TTTitledTableField* field = item;

  CGSize size = [field.text sizeWithFont:font
    constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
  if (size.height > kMaxLabelHeight) {
    size.height = kMaxLabelHeight;
  }

  return size.height + kVPadding*2;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _label.frame = CGRectInset(self.contentView.bounds, kHPadding, kVPadding);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];
  
    _label.text = _field.text;

    _label.lineBreakMode = UILineBreakModeWordWrap;
    _label.numberOfLines = 0;

    if ([object isKindOfClass:[TTGrayTextTableField class]]) {
      _label.font = [UIFont systemFontOfSize:14];
      _label.textColor = [TTAppearance appearance].tableSubTextColor;
      _label.textAlignment = UITextAlignmentCenter;
    } else {
      _label.font = [UIFont boldSystemFontOfSize:15];
      _label.textColor = [UIColor blackColor];
      _label.textAlignment = UITextAlignmentLeft;
    }

    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTTitledTableFieldCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  CGFloat maxWidth = tableView.width - (kKeyWidth + kKeySpacing + kHPadding*2 + kMargin*2);
  TTTitledTableField* field = item;

  CGSize size = [field.text sizeWithFont:[UIFont boldSystemFontOfSize:15]
    constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
    lineBreakMode:UILineBreakModeWordWrap];
  
  return size.height + kVPadding*2;

}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont boldSystemFontOfSize:13];
    _titleLabel.textColor = [TTAppearance appearance].linkTextColor;
    _titleLabel.highlightedTextColor = [UIColor whiteColor];
    _titleLabel.textAlignment = UITextAlignmentRight;
    _titleLabel.contentMode = UIViewContentModeTop;
    [self.contentView addSubview:_titleLabel];

    _label.contentMode = UIViewContentModeTop;
	}
	return self;
}

- (void)dealloc {
  [_titleLabel release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];

  CGSize titleSize = [@"M" sizeWithFont:[UIFont boldSystemFontOfSize:13]];
  _titleLabel.frame = CGRectMake(kHPadding, kVPadding, kKeyWidth, titleSize.height);

  CGFloat valueWidth = self.contentView.width - (kHPadding*2 + kKeyWidth + kKeySpacing);
  CGFloat innerHeight = self.contentView.height - kVPadding*2;
  _label.frame = CGRectMake(kHPadding + kKeyWidth + kKeySpacing, kVPadding,
    valueWidth, innerHeight);
}

-(void)didMoveToSuperview {
  [super didMoveToSuperview];
  if (self.superview && [(UITableView*)self.superview style] == UITableViewStylePlain) {
    _titleLabel.backgroundColor = self.superview.backgroundColor;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];
  
    TTTitledTableField* field = object;
    _titleLabel.text = field.title;
    _label.text = field.text;
  
    _label.font = [UIFont boldSystemFontOfSize:15];
    _label.textColor = [UIColor blackColor];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.lineBreakMode = UILineBreakModeWordWrap;
    _label.numberOfLines = 0;

    if (field.url) {
      if ([[TTNavigationCenter defaultCenter] urlIsSupported:field.url]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      } else {
        self.accessoryType = UITableViewCellAccessoryNone;
      }
      self.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
      self.accessoryType = UITableViewCellAccessoryNone;
      self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  }  
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTSubtextTableFieldCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  CGFloat maxWidth = tableView.width - kHPadding*2;
  TTSubtextTableField* field = item;

  CGSize textSize = [field.text sizeWithFont:[UIFont boldSystemFontOfSize:15]
    constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
    lineBreakMode:UILineBreakModeWordWrap];
  CGSize subtextSize = [field.subtext sizeWithFont:[UIFont systemFontOfSize:14]
    constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
  
  return kVPadding*2 + textSize.height + subtextSize.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _subtextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subtextLabel.font = [UIFont systemFontOfSize:14];
    _subtextLabel.textColor = [TTAppearance appearance].tableSubTextColor;
    _subtextLabel.highlightedTextColor = [UIColor whiteColor];
    _subtextLabel.textAlignment = UITextAlignmentLeft;
    _subtextLabel.contentMode = UIViewContentModeTop;
    _subtextLabel.lineBreakMode = UILineBreakModeWordWrap;
    _subtextLabel.numberOfLines = 0;
    [self.contentView addSubview:_subtextLabel];
	}
	return self;
}

- (void)dealloc {
  [_subtextLabel release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];

  [_label sizeToFit];
  _label.left = kHPadding;
  _label.top = kVPadding;

  CGFloat maxWidth = self.contentView.width - kHPadding*2;
  CGSize subtextSize = [_subtextLabel.text sizeWithFont:_subtextLabel.font
    constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:_subtextLabel.lineBreakMode];
  _subtextLabel.frame = CGRectMake(kHPadding, _label.bottom, subtextSize.width, subtextSize.height);
}

-(void)didMoveToSuperview {
  [super didMoveToSuperview];
  if (self.superview && [(UITableView*)self.superview style] == UITableViewStylePlain) {
    _subtextLabel.backgroundColor = self.superview.backgroundColor;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];
  
    TTSubtextTableField* field = object;
    _label.text = field.text;
    _label.font = [UIFont boldSystemFontOfSize:15];
    _label.textColor = [UIColor blackColor];
    _label.adjustsFontSizeToFitWidth = YES;

    _subtextLabel.text = field.subtext;

    if (field.url) {
      if ([[TTNavigationCenter defaultCenter] urlIsSupported:field.url]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      } else {
        self.accessoryType = UITableViewCellAccessoryNone;
      }
      self.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
      self.accessoryType = UITableViewCellAccessoryNone;
      self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  }  
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTMoreButtonTableFieldCell

@synthesize animating = _animating;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  TTMoreButtonTableField* field = item;
  
  CGFloat maxWidth = tableView.width - kHPadding*2;

  CGSize textSize = [field.text sizeWithFont:[UIFont boldSystemFontOfSize:17]
    constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
  CGSize subtitleSize = field.subtitle
    ? [field.subtitle sizeWithFont:[UIFont systemFontOfSize:14]
      constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap]
    : CGSizeMake(0, 0);
  
  return kVPadding*2 + textSize.height + subtitleSize.height;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _spinnerView = nil;
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subtitleLabel.font = [UIFont systemFontOfSize:14];
    _subtitleLabel.textColor = [TTAppearance appearance].tableSubTextColor;
    _subtitleLabel.highlightedTextColor = [UIColor whiteColor];
    _subtitleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self.contentView addSubview:_subtitleLabel];

    self.accessoryType = UITableViewCellAccessoryNone;
  }
  return self;
}

- (void)dealloc {
  [_spinnerView release];
  [_subtitleLabel release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [_label sizeToFit];
  [_subtitleLabel sizeToFit];
  
  CGFloat titleHeight = _label.height + _subtitleLabel.height;
  CGFloat titleWidth = _label.width > _subtitleLabel.width
    ? _label.width
    : _subtitleLabel.width;
  
  _spinnerView.top = floor(self.contentView.height/2 - _spinnerView.height/2);
  _label.top = floor(self.contentView.height/2 - titleHeight/2);
  _subtitleLabel.top = _label.bottom;
  
  _label.left = _label.top*2;
  _subtitleLabel.left = _label.top*2;
  _spinnerView.left = _label.left + titleWidth + kSpacing;
}

-(void)didMoveToSuperview {
  [super didMoveToSuperview];
  if (self.superview && [(UITableView*)self.superview style] == UITableViewStylePlain) {
    _subtitleLabel.backgroundColor = self.superview.backgroundColor;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];

    TTMoreButtonTableField* field = object;

    _label.text = field.text;
    _label.font = [UIFont boldSystemFontOfSize:17];
    _label.textColor = [TTAppearance appearance].moreLinkTextColor;

    if (field.subtitle) {
      _subtitleLabel.text = field.subtitle;
      _subtitleLabel.hidden = NO;
    } else {
      _subtitleLabel.hidden = YES;
    }

    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.animating = field.isLoading;
  }  
}

- (void)setAnimating:(BOOL)isAnimating {
  _animating = isAnimating;
  
  if (_animating) {
    if (!_spinnerView) {
      _spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
        UIActivityIndicatorViewStyleGray];
      [self.contentView addSubview:_spinnerView];
    }

    [_spinnerView startAnimating];
  } else {
    [_spinnerView stopAnimating];
  }
  [self setNeedsLayout];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTIconTableFieldCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  TTImageTableField* field = item;

  UIImage* image = field.image ? [[TTURLCache sharedCache] imageForURL:field.image] : nil;
  
  CGFloat iconWidth = image
    ? image.size.width + kKeySpacing
    : (field.image ? kDefaultIconSize + kKeySpacing : 0);
  CGFloat iconHeight = image
    ? image.size.height
    : (field.image ? kDefaultIconSize : 0);
    
  CGFloat maxWidth = tableView.width - (iconWidth + kHPadding*2 + kMargin*2);

  CGSize textSize = [field.text sizeWithFont:[UIFont boldSystemFontOfSize:15]
    constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
    lineBreakMode:UILineBreakModeWordWrap];

  CGFloat contentHeight = textSize.height > iconHeight ? textSize.height : iconHeight;
  return contentHeight + kVPadding*2;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _iconView = [[TTStyleView alloc] initWithFrame:CGRectZero];
    _iconView.borderRadius = 8;
    _iconView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_iconView];
	}
	return self;
}

- (void)dealloc {
  [_iconView release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];

  TTImageTableField* field = self.object;
  UIImage* image = field.image
    ? [[TTURLCache sharedCache] imageForURL:field.image]
    : nil;
  if (!image) {
    image = field.defaultImage;
  }
  if (_iconView.backgroundImageURL) {
    CGFloat iconWidth = image
      ? image.size.width
      : (field.image ? kDefaultIconSize : 0);
    CGFloat iconHeight = image
      ? image.size.height
      : (field.image ? kDefaultIconSize : 0);

    _iconView.frame = CGRectMake(kHPadding, floor(self.height/2 - iconHeight/2),
      iconWidth, iconHeight);

    CGFloat innerWidth = self.contentView.width - (kHPadding*2 + iconWidth + kKeySpacing);
    CGFloat innerHeight = self.contentView.height - kVPadding*2;
    _label.frame = CGRectMake(kHPadding + iconWidth + kKeySpacing, kVPadding,
      innerWidth, innerHeight);
  } else {
    _label.frame = CGRectInset(self.contentView.bounds, kHPadding, kVPadding);
    _iconView.frame = CGRectZero;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];
  
    TTImageTableField* field = object;
    _iconView.backgroundImageDefault = field.defaultImage;
    _iconView.backgroundImageURL = field.image;
  }  
}
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTImageTableFieldCell

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];

  TTImageTableField* field = self.object;
  UIImage* image = field.image ? [[TTURLCache sharedCache] imageForURL:field.image] : nil;
  
  CGFloat iconWidth = image
    ? image.size.width
    : (field.image ? kDefaultIconSize : 0);
  CGFloat iconHeight = image
    ? image.size.height
    : (field.image ? kDefaultIconSize : 0);
  
  if (_iconView.backgroundImageURL) {
    CGFloat innerWidth = self.contentView.width - (kHPadding*2 + iconWidth + kKeySpacing);
    CGFloat innerHeight = self.contentView.height - kVPadding*2;
    _label.frame = CGRectMake(kHPadding, kVPadding, innerWidth, innerHeight);

    _iconView.frame = CGRectMake(_label.right + kKeySpacing,
      floor(self.height/2 - iconHeight/2), iconWidth, iconHeight);
  } else {
    _label.frame = CGRectInset(self.contentView.bounds, kHPadding, kVPadding);
    _iconView.frame = CGRectZero;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];
  
    _label.font = [UIFont boldSystemFontOfSize:15];
    _label.textAlignment = UITextAlignmentCenter;
    self.accessoryType = UITableViewCellAccessoryNone;
  }  
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTActivityTableFieldCell

@synthesize animating = _animating;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  TTActivityTableField* field = item;
  if (field.sizeToFit) {
    if (tableView.style == UITableViewStyleGrouped) {
      return (tableView.height - TABLE_GROUPED_PADDING*2) - tableView.tableHeaderView.height;
    } else {
      return tableView.height - tableView.tableHeaderView.height;
    }
  } else {
    return [super tableView:tableView rowHeightForItem:item];
  }
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _spinnerView = nil;
  }
  return self;
}

- (void)dealloc {
  [_spinnerView release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [_label sizeToFit];

  CGFloat totalWidth = _label.width + kSpacing + _spinnerView.width;
  _spinnerView.left = floor(self.contentView.width/2 - totalWidth/2);
  _spinnerView.top = floor(self.contentView.height/2 - _spinnerView.height/2);

  _label.left = _spinnerView.right + kSpacing;
  _label.top = floor(self.contentView.height/2 - _label.height/2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];

    TTActivityTableField* field = object;

    _label.text = field.text;
    _label.font = [UIFont systemFontOfSize:17];
    _label.textColor = [TTAppearance appearance].tableActivityTextColor;
    _label.highlightedTextColor = [UIColor whiteColor];
    _label.lineBreakMode = UILineBreakModeTailTruncation;
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.animating = YES;
  }  
}

- (void)setAnimating:(BOOL)isAnimating {
  _animating = isAnimating;
  
  if (_animating) {
    if (!_spinnerView) {
      _spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
        UIActivityIndicatorViewStyleGray];
      [self.contentView addSubview:_spinnerView];
    }

    [_spinnerView startAnimating];
  } else {
    [_spinnerView stopAnimating];
  }
  [self setNeedsLayout];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTErrorTableFieldCell

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  TTStatusTableField* field = item;
  if (field.sizeToFit) {
    return tableView.height - tableView.tableHeaderView.height;
  } else {
  }

  return [super tableView:tableView rowHeightForItem:item];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _field = nil;
    
    _errorView = [[TTErrorView alloc] initWithFrame:CGRectZero];
    [self addSubview:_errorView];

    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)dealloc {
  [_field release];
  [_errorView release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _errorView.frame = self.bounds;
  [_errorView setNeedsLayout];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (id)object {
  return _field;
}

- (void)setObject:(id)object {
  if (_field != object) {
    [_field release];
    _field = [object retain];
    
    TTErrorTableField* emptyItem = object;
    _errorView.image = emptyItem.image;
    _errorView.title = emptyItem.text;
    _errorView.subtitle = emptyItem.subtitle;
  }  
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTTextFieldTableFieldCell

@synthesize textField = _textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_textField addTarget:self action:@selector(valueChanged)
      forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_textField];

    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)dealloc {
  [_textField release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [_label sizeToFit];
  _label.width = kTextFieldTitleWidth;
  
  _textField.frame = CGRectOffset(CGRectInset(self.contentView.bounds, 3, 0), 0, 1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];

    TTTextFieldTableField* field = object;
    _label.text = [NSString stringWithFormat:@"  %@", field.title];

    _textField.text = field.text;
    _textField.placeholder = field.placeholder;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.returnKeyType = field.returnKeyType;
    _textField.keyboardType = field.keyboardType;
    _textField.autocapitalizationType = field.autocapitalizationType;
    _textField.autocorrectionType = field.autocorrectionType;
    _textField.clearButtonMode = field.clearButtonMode;
    _textField.secureTextEntry = field.secureTextEntry;
    _textField.leftView = _label;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.delegate = self;
  }  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIControlEvents

- (void)valueChanged {
  TTTextFieldTableField* field = self.object;
  field.text = _textField.text;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  TTTextFieldTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
    return [field.delegate textFieldShouldBeginEditing:textField];
  } else {
    return YES;
  }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  UITableView* tableView = (UITableView*)[self firstParentOfClass:[UITableView class]];
  NSIndexPath* indexPath = [tableView indexPathForCell:self];
  [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle
    animated:YES];

  TTTextFieldTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
    [field.delegate textFieldDidBeginEditing:textField];
  }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  TTTextFieldTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
    return [field.delegate textFieldShouldEndEditing:textField];
  } else {
    return YES;
  }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  TTTextFieldTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
    [field.delegate textFieldDidEndEditing:textField];
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
  TTTextFieldTableField* field = self.object;
  SEL sel = @selector(textField:shouldChangeCharactersInRange:replacementString:);
  if ([field.delegate respondsToSelector:sel]) {
    return [field.delegate textField:textField shouldChangeCharactersInRange:range
      replacementString:string];
  } else {
    return YES;
  }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
  TTTextFieldTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
    return [field.delegate textFieldShouldClear:textField];
  } else {
    return YES;
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  TTTextFieldTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
    return [field.delegate textFieldShouldReturn:textField];
  } else {
    return YES;
  }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTTextViewTableFieldCell

@synthesize textView = _textView;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForItem:(id)item {
  return kTableViewFieldCellHeight;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _field = nil;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.scrollsToTop = NO;
    [self.contentView addSubview:_textView];

    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)dealloc {
  [_field release];
  [_textView release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _textView.frame = CGRectInset(self.contentView.bounds, 5, 5);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (id)object {
  return _field;
}

- (void)setObject:(id)object {
  if (_field != object) {
    [_field release];
    _field = [object retain];

    TTTextFieldTableField* field = self.object;
    _textView.text = field.text;
  }  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  TTTextViewTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
    return [field.delegate textViewShouldBeginEditing:textView];
  } else {
    return YES;
  }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  TTTextViewTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
    return [field.delegate textViewShouldEndEditing:textView];
  } else {
    return YES;
  }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  UITableView* tableView = (UITableView*)[self firstParentOfClass:[UITableView class]];
  NSIndexPath* indexPath = [tableView indexPathForCell:self];
  [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle
    animated:YES];
  
  TTTextViewTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
    [field.delegate textViewDidBeginEditing:textView];
  }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  TTTextViewTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
    [field.delegate textViewDidEndEditing:textView];
  }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
    replacementText:(NSString *)text {
  TTTextViewTableField* field = self.object;
  SEL sel = @selector(textView:shouldChangeTextInRange:replacementText:);
  if ([field.delegate respondsToSelector:sel]) {
    return [field.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
  } else {
    return YES;
  }
}

- (void)textViewDidChange:(UITextView *)textView {
  TTTextViewTableField* field = self.object;
  field.text = textView.text;
  
  if ([field.delegate respondsToSelector:@selector(textViewDidChange:)]) {
    [field.delegate textViewDidChange:textView];
  }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
  TTTextViewTableField* field = self.object;
  if ([field.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
    [field.delegate textViewDidChangeSelection:textView];
  }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTSwitchTableFieldCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
    _switch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_switch addTarget:self action:@selector(valueChanged)
      forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switch];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)dealloc {
  [_switch release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [_switch sizeToFit];
  _switch.left = self.contentView.width - (kHPadding + _switch.width);
  _switch.top = kVPadding;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewCell

- (void)setObject:(id)object {
  if (_field != object) {
    [super setObject:object];

    _label.font = [UIFont boldSystemFontOfSize:15];

    TTSwitchTableField* field = self.object;
    _switch.on = field.on;
  }  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIControlEvents

- (void)valueChanged {
  TTSwitchTableField* field = self.object;
  field.on = _switch.on;
}

@end
