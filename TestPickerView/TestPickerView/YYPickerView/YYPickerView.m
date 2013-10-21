//
// Created by ivan on 13-7-25.
//
//


#import <AudioToolbox/AudioToolbox.h>
#import "YYPickerView.h"
#import "UIView+YY.h"
#import "UIImage+SY.h"

#define CellContentSubViewTag 438

@interface NSArray (YY)
- (id)yyObjectAtIndex:(NSInteger)index;
@end

@implementation NSArray (YY)
- (id)yyObjectAtIndex:(NSInteger)index
{
    return index < self.count ? self[index] : nil;
}

@end

@interface YYPickerView () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isSetuped;
    BOOL soundOK;
    CGFloat tablesWholeWidth;
}
@property(strong, nonatomic) NSMutableArray *tables;
@property(strong, nonatomic) UIView *contentView;
@property(strong, nonatomic) NSMutableArray *cellIdentifiers;
@property(strong, nonatomic) NSMutableArray *selectedIndexes;
@property(strong, nonatomic) NSMutableArray *offSetYs;
@end

@implementation YYPickerView


- (id)init
{
    self = [super init];
    if (self)
    {
        self.tables = [[NSMutableArray alloc] init];
        self.selectedIndexes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tables = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (id)pickerView:(CGRect)rect;
{
    YYPickerView *yyPickerView = [[self alloc] initWithFrame:rect];
    yyPickerView.clipsToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roll_bg.png"]];
    imageView.width = rect.size.width;
    [yyPickerView addSubview:imageView];
    return yyPickerView;
}

- (void)setDataSource:(id <YYPickerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self setupPickerView];
    [self layoutTables];
    [self reloadAllComponents];
}

- (void)setDelegate:(id <YYPickerViewDelegate>)delegate
{
    [self setupPickerView];
    _delegate = delegate;
    if (_tables.count > 0)
    {
        [self layoutTables];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        soundOK = YES;
    });
}


- (void)setupPickerView
{
    if (!_contentView)
    {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + 10, self.bounds.origin.y + 10, self.width - 20, self.height - 20)];
        UIImageView *border = [[UIImageView alloc] initWithFrame:_contentView.bounds];
        border.image = [[UIImage imageNamed:@"roll_pan.png"] resizableImageCenter];
        [_contentView addSubview:border];
        
        //中间的选中图片
        UIImageView *center = [[UIImageView alloc] initWithFrame:_contentView.bounds];
        center.tag = 4567;
        center.image = [UIImage imageNamed:@"roll_red.png"].resizableImageCenter;
        center.height = 44;
        center.centerY = _contentView.centerY - 10;
        [_contentView addSubview:center];
        
    }
    _contentView.backgroundColor = [UIColor clearColor];
    int components = 0;
    if ([_dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)])
    {
        components = [_dataSource numberOfComponentsInPickerView:self];
    }
    if (components > 0)
    {
        if (_tables.count == 0)
        {
            self.selectedIndexes = [[NSMutableArray alloc] init];
            self.offSetYs = [[NSMutableArray alloc] init];
            for (int i = 0; i < components; i++)
            {
                UITableView *tableView = [[UITableView alloc] init];
                [_cellIdentifiers addObject:[NSString stringWithFormat:@"%p", &tableView]];
                tableView.backgroundView = nil;
                tableView.backgroundColor = [UIColor clearColor];
                tableView.showsVerticalScrollIndicator = NO;
                tableView.showsHorizontalScrollIndicator = NO;
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                //40是行高，暂时写死,总高度减去一行的高度，其他的高度，顶部和底部各分一半
                UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, (_contentView.height - 40) / 2)];
                UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, (_contentView.height - 40) / 2)];
                tableView.tableHeaderView = tableHeaderView;
                tableView.tableFooterView = tableFooterView;
                tableView.tag = i;
                tableView.delegate = self;
                tableView.dataSource = self;
                [_contentView addSubview:tableView];
                [_tables addObject:tableView];
                [_selectedIndexes addObject:@0];
                [_offSetYs addObject:@0];
            }
        }
    }
    [self addSubview:_contentView];
}

- (void)layoutTables
{
    //todo 先不处理超过的问题
    tablesWholeWidth = _contentView.width - 20;
    [_tables enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger index, BOOL *stop) {
        tableView.frame = CGRectMake(10 + index * tablesWholeWidth / _tables.count, 10, tablesWholeWidth / _tables.count, _contentView.height - 20);
        tableView.rowHeight = 40;
        if ([_delegate respondsToSelector:@selector(pickerView:widthForComponent:)])
        {
            tableView.width = [_delegate pickerView:self widthForComponent:index];
        }
        if ([_delegate respondsToSelector:@selector(pickerView:rowHeightForComponent:)])
        {
            tableView.rowHeight = [_delegate pickerView:self rowHeightForComponent:index];
        }
        if (index != _tables.count - 1)
        {
            UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.right - 1, tableView.frame.origin.y, 2, tableView.height)];
            splitView.image = [UIImage imageNamed:@"roll_line.png"];
            [_contentView addSubview:splitView];
        }
        [self selectRow:0 inComponent:tableView.tag animated:YES callDelegate:NO];
    }];
    [_contentView bringSubviewToFront:[_contentView viewWithTag:4567]];
}

- (NSInteger)numberOfComponents
{
    return _tables.count;
}


- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    return ([_dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) ? ([_dataSource pickerView:self numberOfRowsInComponent:component]) : 0;
}

- (CGSize)rowSizeForComponent:(NSInteger)component
{
    CGSize result = CGSizeZero;
    UITableView *tableView = [_tables yyObjectAtIndex:component];
    result = CGSizeMake(tableView.frame.size.width, tableView.rowHeight);
    return result;
}


- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component
{
    int rows = [self numberOfRowsInComponent:component];
    UITableView *tableView = [_tables yyObjectAtIndex:component];
    if (tableView && row < rows - 1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell.contentView viewWithTag:CellContentSubViewTag];
    }
    return nil;
}

- (void)reloadAllComponents
{
    [_tables makeObjectsPerformSelector:@selector(reloadData)];
}

- (void)reloadComponent:(NSInteger)component
{
    UITableView *tableView = [_tables yyObjectAtIndex:component];
    [tableView reloadData];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self selectRow:row inComponent:component animated:animated callDelegate:YES];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated callDelegate:(BOOL)flag
{
    int rows = [self numberOfRowsInComponent:component];
    UITableView *tableView = [_tables yyObjectAtIndex:component];
    if (tableView && row < rows)
    {
        _selectedIndexes[component] = @(row);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
        if (flag && [_delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
        {
            [_delegate pickerView:self didSelectRow:row inComponent:component];
        }
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    UITableView *tableView = [_tables yyObjectAtIndex:component];
    if (tableView)
    {
        return [_selectedIndexes[component] intValue];
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInComponent:tableView.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = _cellIdentifiers[tableView.tag];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:67 / 255.0 green:43 / 255.0 blue:43 / 255.0 alpha:1];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = nil;
    int component = tableView.tag;
    UIView *resultView = nil;
    if ([_delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:adviceWidth:)])
    {
        UIView *reusingView = [cell.contentView viewWithTag:CellContentSubViewTag];
        //addSubview内部机制，不移除了，直接再次addSubview没关系     
        resultView = [_delegate pickerView:self viewForRow:indexPath.row forComponent:component reusingView:reusingView adviceWidth:tablesWholeWidth/_tables.count];
        resultView.tag = CellContentSubViewTag;
        [cell.contentView addSubview:resultView];
    }
    else if ([_delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)])
    {
        UIView *reusingView = [cell.contentView viewWithTag:CellContentSubViewTag];
        //addSubview内部机制，不移除了，直接再次addSubview没关系
        resultView = [_delegate pickerView:self viewForRow:indexPath.row forComponent:component reusingView:reusingView];
        resultView.tag = CellContentSubViewTag;
        [cell.contentView addSubview:resultView];
    }
    if (!resultView && [_delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)])
    {
        cell.textLabel.text = [_delegate pickerView:self titleForRow:indexPath.row forComponent:component];
        if ([_selectedIndexes[tableView.tag] intValue] == indexPath.row)
        {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else
        {
            cell.textLabel.textColor = [UIColor colorWithRed:67 / 255.0 green:43 / 255.0 blue:43 / 255.0 alpha:1];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self scrollViewDidEndDecelerating:tableView];
    [self selectRow:indexPath.row inComponent:tableView.tag animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat lastY = [_offSetYs[scrollView.tag] intValue];
    if (fabs(scrollView.contentOffset.y - lastY) >= 40)
    {
        _offSetYs[scrollView.tag] = @(scrollView.contentOffset.y);
        [self playSound];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _offSetYs[scrollView.tag] = @(scrollView.contentOffset.y);
}


- (void)playSound
{
    if (soundOK && !_soundDisable)
    {
        AudioServicesPlaySystemSound(1105);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *) scrollView;
        int rows = [self numberOfRowsInComponent:tableView.tag];
        NSArray *cells = tableView.visibleCells;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [cells enumerateObjectsUsingBlock:^(UITableViewCell *obj, NSUInteger idx, BOOL *stop) {
            CGRect rect = [scrollView convertRect:obj.frame toView:self];
            [array addObject:@(fabs(rect.origin.y - _contentView.centerY + rect.size.height / 2))];
        }];
        int index = [self indexOfSmallestAtArray:array];
        UITableViewCell *cell = cells[MAX(index, 0)];
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        if (cells.count < 4 && indexPath.row == rows - 2 && rows!=2)
        {
            indexPath = [NSIndexPath indexPathForRow:MIN(rows - 1, indexPath.row + 1) inSection:0];
        }
        [self selectRow:indexPath.row inComponent:tableView.tag animated:YES];
    }
}

- (int)indexOfSmallestAtArray:(NSArray *)array
{
    int index = 0;
    for (int i = 1; i < array.count; i++)
    {
        if ([array[i] floatValue] < [array[index] floatValue])
        {
            index = i;
        }
    }
    return index;
}


@end