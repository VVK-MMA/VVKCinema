//
//  CinemaPickerView.h
//  VVKCinema
//
//  Created by AdrenalineHvata on 6/19/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CinemaPickerView, CinemaPickerComponentView;

#pragma mark - Delegate protocol
@protocol CinemaPickerViewDelegate <NSObject>

@optional
- (void)pickerView:(CinemaPickerView *)pickerView didSelectItem:(NSUInteger)item forComponent:(NSUInteger)component;

@end

#pragma mark - Datasource protocol
@protocol CinemaPickerViewDatasource <NSObject>

@required
- (NSUInteger)numberOfComponentsForPickerView:(CinemaPickerView *)pickerView;
- (NSUInteger)pickerView:(CinemaPickerView *)pickerView numberOfItemsForComponent:(NSUInteger)component;
- (NSString *)pickerView:(CinemaPickerView *)pickerView textForItem:(NSInteger)item forComponent:(NSInteger)component;

@optional
- (NSString *)pickerView:(CinemaPickerView *)pickerView titleForComponent:(NSUInteger)component;
- (CGFloat)pickerView:(CinemaPickerView *)pickerView itemsWidthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(CinemaPickerView *)pickerView heightForComponent:(NSInteger)component;
- (UIColor *)selectionColorForPickerView:(CinemaPickerView *)pickerView;

- (UIView *)pickerView:(CinemaPickerView *)pickerView viewForItem:(NSInteger *)item forComponent:(NSInteger)component __attribute__((unavailable));

@end

#pragma mark - CinemaPickerView Interface
@interface CinemaPickerView : UIView

@property (weak, nonatomic) id<CinemaPickerViewDelegate> delegate;
@property (weak, nonatomic) id<CinemaPickerViewDatasource> datasource;

@property (weak, nonatomic, readonly) UIScrollView *mainVerticalScrollView;

- (instancetype)init __attribute__((unavailable("Use -initWithFrame: instead")));

- (void)setItem:(NSUInteger)item forComponent:(NSUInteger)component animated:(BOOL)animated;
- (void)reloadData;

@end

