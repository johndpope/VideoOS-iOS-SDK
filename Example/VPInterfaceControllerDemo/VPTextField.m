//
//  VPTextField.m
//  VPInterfaceControllerDemo
//
//  Created by peter on 2018/6/6.
//  Copyright © 2018 videopls. All rights reserved.
//

#import "VPTextField.h"

@interface VPTextField () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<UITextFieldDelegate> vpDelegate;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VPTextField

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.vpDelegate = delegate;
}

- (id<UITextFieldDelegate>)delegate {
    return self.vpDelegate;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        super.delegate = self;
        _showCellCount = 3;
    }
    return self;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.vpDelegate && [self.vpDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.vpDelegate textFieldShouldBeginEditing:textField];
    }
    [self createTableView];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.vpDelegate && [self.vpDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.vpDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.vpDelegate && [self.vpDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.vpDelegate textFieldShouldClear:textField];
    }
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.vpDelegate && [self.vpDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.vpDelegate textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (self.vpDelegate && [self.vpDelegate respondsToSelector:@selector(textFieldDidEndEditing:reason:)]) {
        [self.vpDelegate textFieldDidEndEditing:textField reason:reason];
    }
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.vpDelegate && [self.vpDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.vpDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.vpDelegate && [self.vpDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.vpDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.vpDelegate && [self.vpDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.vpDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

- (void)createTableView {
    if (!self.tableView && self.superview) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height * self.showCellCount) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.layer.borderColor = [UIColor grayColor].CGColor;
        self.tableView.layer.borderWidth = 1;
        [self.superview addSubview:self.tableView];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = self.font;
        cell.detailTextLabel.textColor = self.textColor;
    }
    cell.detailTextLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma make UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    NSString *text = [self.dataArray objectAtIndex:indexPath.row];
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:style}];
    
    CGSize size =  [string boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;

    return size.height + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.text = [self.dataArray objectAtIndex:indexPath.row];
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self resignFirstResponder];
}

@end
