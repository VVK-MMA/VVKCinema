//
//  DropTicketViewController.h
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/21/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropTicketViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *projectionTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
