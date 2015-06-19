//
//  CinemaPickerView.m
//  VVKCinema
//
//  Created by AdrenalineHvata on 6/19/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "CinemaPickerView.h"


#define cinemaPickerViewDefaultTextColor [UIColor blackColor]
#define cinemaPickerViewSelectionTextColor [UIColor blueColor]

static const CGFloat cinemaPickerViewItemWidth = 80.0;
static const CGFloat cinemaPickerViewComponentHeight = 30.0;
static const CGFloat cinemaPickerViewComponentTitleHeight = 20.0;
static const CGFloat cinemaPickerComponentMargin = 15.0;

static const CGFloat cinemaPickerViewTitleFontSize = 13.0;
static NSString *const cinemaPickerViewTitleFontName = @"HelveticaNeue";

static const CGFloat cinemaPickerViewCollectionTextFontSize = 16.0;
static NSString *const cinemaPickerViewCollectionTextFontName = @"HelveticaNeue";
static NSString *const cinemaPickerViewCollectionSelectedTextFontName = @"HelveticaNeue-Bold";

static NSString *const cinemaPickerViewCollectionCellIdentifier = @"CollectionCell";

static struct DatasourceResponds {
    unsigned int datasourceTitle:1;
    unsigned int datasourceComponentHeight:1;
    unsigned int datasourceItemWidth:1;
} datasourceResponds;

static struct DelegateResponds {
    unsigned int delegateDidSelect;
} delegateResponds;

static UIColor *selectionColor;

#pragma mark - CinemaPickerViewCell class
@interface CinemaPickerViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *label;

@end

@implementation CinemaPickerViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self mg_initialize];
    }
    return self;
}

- (void)mg_initialize
{
    _label = [[UILabel alloc] initWithFrame:(CGRect){5.0, 0, self.frame.size.width-10.0, self.frame.size.height}];
    _label.font = [UIFont fontWithName :cinemaPickerViewCollectionTextFontName size:cinemaPickerViewCollectionTextFontSize];
    _label.textColor = cinemaPickerViewDefaultTextColor;
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

@end


#pragma mark - CinemaPickerComponentView Delegate protocol
@protocol CinemaPickerComponentViewDelegate <NSObject>

@optional
- (void)pickerComponentView:(CinemaPickerComponentView *)componentView didSelectItem:(NSUInteger)item;

@end

#pragma mark - CinemaPickerComponent class
@interface CinemaPickerComponentView : UIView <UICollectionViewDataSource, UICollectionViewDelegate> {
@private
    UILabel *label_;
}

@property (readonly) NSInteger selectedItemIndex;

@property (weak, nonatomic) id<CinemaPickerComponentViewDelegate> delegate;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSMutableArray *itemsText;
@property CGFloat componentHeight;
@property CGFloat itemWidth;
@property NSUInteger numberOfItems;

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated;

@end

@implementation CinemaPickerComponentView {
    NSUInteger oldSelected_;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemsText = [NSMutableArray new];
        _selectedItemIndex = 0;
    }
    return self;
}

- (void)design
{
    CGFloat componentViewHeight = 0.0;
    
    //Consider the title if exists
    if (datasourceResponds.datasourceTitle) {
        label_ = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, cinemaPickerViewComponentTitleHeight}];
        label_.font = [UIFont fontWithName:cinemaPickerViewTitleFontName size:cinemaPickerViewTitleFontSize];
        label_.textColor = selectionColor;
        label_.textAlignment = NSTextAlignmentCenter;
        label_.text = _title;
        [self addSubview:label_];
        
        componentViewHeight += label_.frame.size.height;
    }
    
    //Create the collectionView
    CGRect collectionViewRect = (CGRect){0.0, componentViewHeight, self.frame.size.width, _componentHeight};
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:layout];
    [self mg_configureDefaultCollectionView];
    
    [self addSubview:_collectionView];
    componentViewHeight += _collectionView.frame.size.height;
    
    //Set the frame of the componentView
    self.frame = (CGRect){0, 0, self.frame.size.width, componentViewHeight};
}

- (void)mg_configureDefaultCollectionView
{
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    CGFloat sideInset = self.bounds.size.width/2.0-_itemWidth/2.0;
    
    _collectionView.contentInset = (UIEdgeInsets){0, sideInset, 0, sideInset};
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CinemaPickerViewCell class] forCellWithReuseIdentifier:cinemaPickerViewCollectionCellIdentifier];
}

/////////////////////////////////////////////////////
//      COLLECTION VIEW DELEGATE/DATASOURCE        //
/////////////////////////////////////////////////////

#pragma mark - UICollectionView Delegate/Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _numberOfItems;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_itemWidth, _componentHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CinemaPickerViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cinemaPickerViewCollectionCellIdentifier forIndexPath:indexPath];
    collectionViewCell.label.text = _itemsText[indexPath.row];
    collectionViewCell.label.font = [UIFont fontWithName:((indexPath.row == _selectedItemIndex) ? cinemaPickerViewCollectionSelectedTextFontName : cinemaPickerViewCollectionTextFontName) size:cinemaPickerViewCollectionTextFontSize];
    collectionViewCell.label.textColor = (indexPath.row == _selectedItemIndex) ? selectionColor : cinemaPickerViewDefaultTextColor;
    
    return collectionViewCell;
}

/////////////////////////////////////////////////////
//         SCROLLVIEW TO MANAGE SELECTION          //
/////////////////////////////////////////////////////

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isDragging]) {
        //Center value
        [self mg_centerValueForScrollView:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //Center value
    [self mg_centerValueForScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

#pragma mark - Private methods scrollView selection
//Center the value in the bar selector
- (void)mg_centerValueForScrollView:(UIScrollView *)scrollView {
    
    //Actual Offset
    CGFloat offset = scrollView.contentOffset.x + scrollView.contentInset.left;
    
    CGFloat mod = offset - (int)(offset/_itemWidth)*_itemWidth;
    
    CGFloat newOffset = (mod <= _itemWidth/2.0) ? offset-mod : offset+(_itemWidth-mod);
    
    NSUInteger itemIndex = (int)(newOffset/_itemWidth);
    
    //Center the cell
    itemIndex = (itemIndex < _numberOfItems) ? itemIndex : _numberOfItems-1;
    
    newOffset -= scrollView.contentInset.left;
    
    [scrollView setContentOffset:CGPointMake(newOffset, 0.0) animated:YES];
    
    [self mg_selectItem:itemIndex];
}

- (void)mg_selectItem:(NSUInteger)item
{
    oldSelected_ = _selectedItemIndex;
    _selectedItemIndex = item;
    
    [_collectionView reloadItemsAtIndexPaths:[_collectionView indexPathsForVisibleItems]];
    
    if ([self.delegate respondsToSelector:@selector(pickerComponentView:didSelectItem:)]) {
        [self.delegate pickerComponentView:self didSelectItem:_selectedItemIndex];
    }
}

#pragma mark - Public methods scrollView selection
- (void)selectItem:(NSUInteger)item animated:(BOOL)animated
{
    CGFloat newOffset = -_collectionView.contentInset.left + _itemWidth*item;
    [_collectionView setContentOffset:CGPointMake(newOffset, 0.0) animated:animated];
    
    [self mg_selectItem:item];
}

@end


#pragma mark - MGFashionPickerView class
@interface CinemaPickerView () <CinemaPickerComponentViewDelegate>

@end

@implementation CinemaPickerView {
    NSMutableArray *arrayComponent_;
    UIScrollView *scrollView_;
}


/////////////////////////////////////////////////////
//           ASPECT AND MAIN FUNCTIONS             //
/////////////////////////////////////////////////////

#pragma mark - Class and overriding methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self mg_setDefaultValue];
    }
    return self;
}

- (void)setDatasource:(id<CinemaPickerViewDatasource>)datasource
{
    if (_datasource != datasource) {
        _datasource = datasource;
        
        datasourceResponds.datasourceTitle = [_datasource respondsToSelector:@selector(pickerView:titleForComponent:)];
        datasourceResponds.datasourceItemWidth = [_datasource respondsToSelector:@selector(pickerView:itemsWidthForComponent:)];
        datasourceResponds.datasourceComponentHeight = [_datasource respondsToSelector:@selector(pickerView:heightForComponent:)];
    }
}

- (void)setDelegate:(id<CinemaPickerViewDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        
        delegateResponds.delegateDidSelect = [self.delegate respondsToSelector:@selector(pickerView:didSelectItem:forComponent:)];
    }
}

#pragma mark - Private methods
- (void)mg_setDefaultValue
{
    //Empty ATM
}

- (void)mg_createComponents
{
    //Get the selection color
    if ([self.datasource respondsToSelector:@selector(selectionColorForPickerView:)]) {
        selectionColor = [self.datasource selectionColorForPickerView:self];
    } else {
        selectionColor = cinemaPickerViewSelectionTextColor;
    }
    
    //Get the number of components
    NSUInteger numberOfComponent = [self.datasource numberOfComponentsForPickerView:self];
    
    //ScrollView content size height
    CGFloat actualContentSizeHeight = 0.0;
    
    //Configure each component
    arrayComponent_ = [NSMutableArray arrayWithCapacity:numberOfComponent];
    
    for (NSUInteger i = 0; i < numberOfComponent; i++) {
        @autoreleasepool {
            CinemaPickerComponentView *pickerComponent = [[CinemaPickerComponentView alloc] initWithFrame:(CGRect){0, 0, scrollView_.frame.size.width, 0}];;
            pickerComponent.numberOfItems = [self.datasource pickerView:self numberOfItemsForComponent:i];
            pickerComponent.componentHeight = (datasourceResponds.datasourceComponentHeight) ? [self.datasource pickerView:self heightForComponent:i] : cinemaPickerViewComponentHeight;
            pickerComponent.itemWidth = (datasourceResponds.datasourceItemWidth) ? [self.datasource pickerView:self itemsWidthForComponent:i] : cinemaPickerViewItemWidth;
            pickerComponent.title = (datasourceResponds.datasourceTitle) ? [self.datasource pickerView:self titleForComponent:i] : nil;
            pickerComponent.delegate = self;
            
            for (NSUInteger o = 0; o < pickerComponent.numberOfItems; o++) {
                [pickerComponent.itemsText addObject:[self.datasource pickerView:self textForItem:o forComponent:i]];
            }
            
            [pickerComponent design];
            
            [scrollView_ addSubview:pickerComponent];
            arrayComponent_[i] = pickerComponent;
            pickerComponent.frame = (CGRect){0, actualContentSizeHeight, pickerComponent.frame.size.width, pickerComponent.frame.size.height};
            
            actualContentSizeHeight += pickerComponent.frame.size.height + ((i == numberOfComponent-1) ? .0 : cinemaPickerComponentMargin);
        }
    }
    
    //Call the did select
    for (NSUInteger i = 0; i < numberOfComponent; i++) {
        if (delegateResponds.delegateDidSelect) {
            [self.delegate pickerView:self didSelectItem:0 forComponent:i];
        }
    }
    
    //Set the scrollView content size
    scrollView_.contentSize = (CGSize){scrollView_.frame.size.width, actualContentSizeHeight};
}

- (void)mg_resetData
{
    [scrollView_ removeFromSuperview];
    
    scrollView_ = nil;
    arrayComponent_ = nil;
    selectionColor = nil;
}

- (void)mg_constructPicker
{
    scrollView_ = [[UIScrollView alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, self.frame.size.height}];
    [self mg_configureMainScrollView];
    [self addSubview:scrollView_];
    
    //Get all datas from the datasource before constructing the view
    [self mg_createComponents];
}

- (void)mg_configureMainScrollView
{
    scrollView_.bounces = NO;
}

#pragma mark - Public methods
- (void)reloadData
{
    [self mg_resetData];
    [self mg_constructPicker];
}

- (UIScrollView *)mainVerticalScrollView
{
    return scrollView_;
}

- (void)setItem:(NSUInteger)item forComponent:(NSUInteger)component animated:(BOOL)animated
{
    CinemaPickerComponentView *componentView = arrayComponent_[component];
    [componentView selectItem:item animated:animated];
}

#pragma mark - MGFashionPickerComponentView Delegate
- (void)pickerComponentView:(CinemaPickerComponentView *)componentView didSelectItem:(NSUInteger)item
{
    NSUInteger component = [arrayComponent_ indexOfObject:componentView];
    
    if (delegateResponds.delegateDidSelect) {
        [self.delegate pickerView:self didSelectItem:item forComponent:component];
    }
}

#warning - Implement backgroundColor, selectionColor, textColor (use a component object including title and collectionView)

@end
