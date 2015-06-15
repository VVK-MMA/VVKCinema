//
//  DayCell.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/15/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "DayCell.h"

@interface DayCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) NSDateFormatter *weekdayFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation DayCell

- (void)setDate:(NSDate *)date
{
    if ( [date isEqual:@"All"] ) {
        self.titleLabel.text = @"All";
        self.detailLabel.text = @"";
    } else {
        self.titleLabel.text = [self.weekdayFormatter stringFromDate:date];
        self.detailLabel.text = [self.dateFormatter stringFromDate:date];
    }
}

-(void)prepareForReuse {
    self.titleLabel.text = @"All";
    self.detailLabel.text = @"";
}

- (NSDateFormatter *)weekdayFormatter
{
    if (!_weekdayFormatter) {
        _weekdayFormatter = [[NSDateFormatter alloc] init];
        [_weekdayFormatter setDateFormat:@"EEEE"];
    }
    
    return _weekdayFormatter;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    
    return _dateFormatter;
}

@end
