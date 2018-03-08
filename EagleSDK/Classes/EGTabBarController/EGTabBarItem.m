#import "EGTabBarItem.h"
#import "EGTabBarBadge.h"
#import "EGTabBarCONST.h"

@interface EGTabBarItem ()

@property (nonatomic, weak) EGTabBarBadge *tabBarBadge;

@end

@implementation EGTabBarItem

- (void)dealloc {
    
    [self.tabBarItem removeObserver:self forKeyPath:@"badgeValue"];
    [self.tabBarItem removeObserver:self forKeyPath:@"title"];
    [self.tabBarItem removeObserver:self forKeyPath:@"image"];
    [self.tabBarItem removeObserver:self forKeyPath:@"selectedImage"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGSize size = self.bounds.size;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image        = self.tabBarItem.image;
        imageView.contentMode  = UIViewContentModeCenter;
        imageView.frame        = CGRectMake(0, 0, size.width, size.height * self.itemImageRatio);
        [self addSubview:imageView];
        
        UILabel *titleLabel      = [[UILabel alloc] init];
        titleLabel.font          = self.itemTitleFont;
        titleLabel.textColor     = self.itemTitleColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat titleY           = size.height * self.itemImageRatio + (self.itemImageRatio == 1.0f ? 100.0f : -5.0f);
        titleLabel.frame         = CGRectMake(0, titleY, size.width, size.height - titleY);
        [self addSubview:titleLabel];
        
        EGTabBarBadge *tabBarBadge = [[EGTabBarBadge alloc] init];
        [self addSubview:tabBarBadge];
        
        _imageView   = imageView;
        _titleLabel  = titleLabel;
        _tabBarBadge = tabBarBadge;
    }
    return self;
}

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio {
    if (self = [super init]) {
        self.itemImageRatio = itemImageRatio;
    }
    return self;
}

- (void)updateViewContent {
    if (self.isSelected) {
        self.imageView.image      = self.tabBarItem.selectedImage;
        self.titleLabel.textColor = self.selectedItemTitleColor;
    } else {
        self.imageView.image      = self.tabBarItem.image;
        self.titleLabel.textColor = self.itemTitleColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size           = self.bounds.size;
    self.imageView.frame  = CGRectMake(0, 0, size.width, size.height * self.itemImageRatio);
    CGFloat titleY        = size.height * self.itemImageRatio + (self.itemImageRatio == 1.0f ? 100.0f : -5.0f);
    self.titleLabel.frame = CGRectMake(0, titleY, size.width, size.height - titleY);
}

#pragma mark -

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    [self updateViewContent];
}

- (void)setTabBarItemCount:(NSInteger)tabBarItemCount {
    _tabBarItemCount = tabBarItemCount;
    
    self.tabBarBadge.tabBarItemCount = tabBarItemCount;
}

- (void)setItemImageRatio:(CGFloat)itemImageRatio {
    _itemImageRatio = itemImageRatio;
    
    [self setNeedsLayout];
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    _itemTitleFont = itemTitleFont;
    
    self.titleLabel.font = itemTitleFont;
}

- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    _itemTitleColor = itemTitleColor;
}

- (void)setSelectedItemTitleColor:(UIColor *)selectedItemTitleColor {
    _selectedItemTitleColor = selectedItemTitleColor;
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    
    _badgeTitleFont = badgeTitleFont;
    
    self.tabBarBadge.badgeTitleFont = badgeTitleFont;
}

#pragma mark -


- (void)setTabBarItem:(UITabBarItem *)tabBarItem {
    
    _tabBarItem = tabBarItem;
    
    [tabBarItem addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"title" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"image" options:0 context:nil];
    [tabBarItem addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EGNotificationTabBarItemChanged object:nil];
    
    [self updateViewContent];
    
    self.titleLabel.text = self.tabBarItem.title;
    self.tabBarBadge.badgeValue = self.tabBarItem.badgeValue;
}

#pragma mark - Reset TabBarItem

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageX = 0.f;
    CGFloat imageY = 0.f;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * self.itemImageRatio;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleX = 0.f;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleY = contentRect.size.height * self.itemImageRatio + (self.itemImageRatio == 1.0f ? 100.0f : -5.0f);
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
