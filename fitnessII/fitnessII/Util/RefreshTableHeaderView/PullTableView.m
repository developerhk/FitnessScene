//
//  PullTableView.m
//  MyPullTableView
//
//  Created by lu jingyu on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullTableView.h"

// 加载更多view的高度
#define load_more_view_height  44

@implementation PullTableView

@synthesize refreshHeaderViewBackgroundColor;
@synthesize needPullToLoadMore;
@synthesize needPullToRefresh;
@synthesize pullDataSource;
@synthesize pullDelegate;

- (void)dealloc {
    self.pullDataSource = nil;
	self.pullDelegate = nil;
    self.delegate = nil;
    self.dataSource = nil;
    self.refreshHeaderViewBackgroundColor = nil;
	[_refreshHeaderView release];
	[_loadMoreFooterView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        // Initialization code
		self.needPullToRefresh = YES;
		self.needPullToLoadMore = NO;
		self.tableFooterView = [[[UIView alloc] init] autorelease];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	if (_loadMoreFooterView) {
		[_loadMoreFooterView setFrame:CGRectMake(0,
												 self.contentSize.height,
												 self.bounds.size.width,
												 self.bounds.size.height)];
	}
}

- (void)setPullDataSource:(id<PullTableViewDataSource>)_pullDataSource {
	pullDataSource = _pullDataSource;
	if (pullDataSource) {
		self.dataSource = self;
	}
	else {
		self.dataSource = nil;
	}
}
- (void)setNeedPullToLoadMore:(BOOL)aNeedPullToLoadMore{
    needPullToLoadMore = aNeedPullToLoadMore;
    if(aNeedPullToLoadMore){
        
        if (self.contentInset.bottom == 0) {
            [self setContentInset:UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, load_more_view_height, self.contentInset.right)];
            if (_loadMoreFooterView == nil) {
                [self addSubview:[self loadMoreFooterView]];
            }
        }
    }else{
        if (_loadMoreFooterView) {
            [_loadMoreFooterView removeFromSuperview];
            [_loadMoreFooterView release];
            _loadMoreFooterView = nil;
        }
        [self setContentInset:UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, 0, self.contentInset.right)];
    }
}
- (void)setPullDelegate:(id<PullTableViewDelegate>)_pullDelegate {
	pullDelegate = _pullDelegate;
	if (pullDelegate) {
		self.delegate = self;
	}
	else {
		self.delegate = nil;
	}
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
	
	// 配置下拉刷新
	if (self.needPullToRefresh == YES) {
		if (_refreshHeaderView == nil) {
			_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
																							 0.0f - self.bounds.size.height,
																							 self.frame.size.width,
																							 self.bounds.size.height)];
			_refreshHeaderView.delegate = self;
			_refreshHeaderView.backgroundColor = self.refreshHeaderViewBackgroundColor == nil ? [UIColor clearColor] : self.refreshHeaderViewBackgroundColor;
			[self addSubview:_refreshHeaderView];
		}
		[_refreshHeaderView refreshLastUpdatedDate];
	}
	
	// 配置上提加载
	if (self.needPullToLoadMore == YES) {
		self.contentInset = UIEdgeInsetsMake(0, 0, load_more_view_height, 0);
		[self addSubview:[self loadMoreFooterView]];
	}
	
}

- (LoadMoreTableFooterView *)loadMoreFooterView {
	if (_loadMoreFooterView == nil) {
		_loadMoreFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0,
																						self.contentSize.height,
																						self.bounds.size.width,
																						self.bounds.size.height)];
		_loadMoreFooterView.delegate = self;
	}
	return _loadMoreFooterView;
}

//- (void)loadMoreTableFooterViewDataSourceDidFinishedLoading:(LoadMoreTableFooterView *)footerView;
//
//// 发起加载数据请求（比如点击more，或者上提加载的动作）
//- (void)loadMoreTableFooterDidTriggerLoading:(LoadMoreTableFooterView *)footerView;
//
//// 当前是否仍在加载数据（当前是否是loading状态）
//- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)footerView;

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableViewStartLoadingNewData:)]) {
        [self.pullDelegate tableViewStartLoadingNewData:self];
    }
}

- (void)loadingMoreData {
	_loadingMore = YES;
	if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableViewLoadingMoreData:)]) {
		[self.pullDelegate tableViewLoadingMoreData:self];
	}
}

- (void)doneLoadingTableViewData {
	_reloading = NO;
	//  model should call this when its done loading
    if (self.pullDelegate) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

- (void)doneLoadingMoreTableViewData {
	_loadingMore = NO;
	if (self.pullDelegate) {
		[_loadMoreFooterView doneLoadMore];
	}
}

- (void)loadingMoreToTheEnd:(BOOL)isEnd {
	if (self.needPullToLoadMore == YES) {
		if (isEnd == YES) {
			if (_loadMoreFooterView) {
				[_loadMoreFooterView removeFromSuperview];
				[_loadMoreFooterView release];
				_loadMoreFooterView = nil;
			}
			[self setContentInset:UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, 0, self.contentInset.right)];
		}
		else {
			if (self.contentInset.bottom == 0) {
				[self setContentInset:UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, load_more_view_height, self.contentInset.right)];
				if (_loadMoreFooterView == nil) {
					[self addSubview:[self loadMoreFooterView]];
				}
			}
		}
	}
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
	
	[self reloadTableViewDataSource];
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
	
	return _reloading; // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
	
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:scrollViewDidScroll:)]) {
        [self.pullDelegate tableView:self scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//	NBLog(@"pull up end dragging");
	if (self.needPullToRefresh) {
		// 判断下拉刷新状态
		[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	}
	
	if (self.needPullToLoadMore) {
		// 判断上提加载状态
		[_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
	}
}

#pragma mark -
#pragma mark LoadMoreTableFooterViewDelegate

- (void)loadMoreTableFooterViewDataSourceDidFinishedLoading:(LoadMoreTableFooterView *)footerView {
	[self doneLoadingMoreTableViewData];
}

- (void)loadMoreTableFooterDidTriggerLoading:(LoadMoreTableFooterView *)footerView {
	[self loadingMoreData];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)footerView {
	return _loadingMore;
}

#pragma mark -
#pragma mark PullTableViewDataSource

- (NSInteger)tableView:(PullTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pullDataSource tableView:self numberOfRowsInSection:section];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(PullTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.pullDataSource tableView:self cellForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(PullTableView *)tableView {
    // Default is 1 if not implemented
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.pullDataSource numberOfSectionsInTableView:self];
    }
    else {
        return 1;
    }
}

- (NSString *)tableView:(PullTableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // fixed font style. use custom view (UILabel) if you want something different
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [self.pullDataSource tableView:self titleForHeaderInSection:section];
    }
    else {
        return nil;
    }
}

- (NSString *)tableView:(PullTableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [self.pullDataSource tableView:self titleForFooterInSection:section];
    }
    else {
        return nil;
    }
}

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(PullTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [self.pullDataSource tableView:self canEditRowAtIndexPath:indexPath];
    }
    else {
        return NO;
    }
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(PullTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        return [self.pullDataSource tableView:self canMoveRowAtIndexPath:indexPath];
    }
    else {
        return NO;
    }
}

// Index

- (NSArray *)sectionIndexTitlesForTableView:(PullTableView *)tableView  {
    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [self.pullDataSource sectionIndexTitlesForTableView:self];
    }
    else {
        return nil;
    }
}

- (NSInteger)tableView:(PullTableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    // tell table which section corresponds to section title/index (e.g. "B",1))
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [self.pullDataSource tableView:self sectionForSectionIndexTitle:title atIndex:index];
    }
    else {
        return 0;
    }
}

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(PullTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.pullDataSource tableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

// Data manipulation - reorder / moving support

- (void)tableView:(PullTableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.pullDataSource && [self.pullDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.pullDataSource tableView:self moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

#pragma mark -
#pragma mark PullTableViewDelegate

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.pullDelegate tableView:self willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.pullDelegate tableView:self heightForRowAtIndexPath:indexPath];
    }
    else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.pullDelegate tableView:self heightForHeaderInSection:section];
    }
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.pullDelegate tableView:self heightForFooterInSection:section];
    }
    else {
        return 0;
    }
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // custom view for header. will be adjusted to default or specified header height
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.pullDelegate tableView:self viewForHeaderInSection:section];
    }
    else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // custom view for footer. will be adjusted to default or specified footer height
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.pullDelegate tableView:self viewForFooterInSection:section];
    }
    else {
        return nil;
    }
}

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
        [self.pullDelegate tableView:self accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        return [self.pullDelegate tableView:self willSelectRowAtIndexPath:indexPath];
    }
    else {
        return indexPath;
    }
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.pullDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.pullDelegate tableView:self editingStyleForRowAtIndexPath:indexPath];
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        return [self.pullDelegate tableView:self shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    else {
        return YES;
    }
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        [self.pullDelegate tableView:self willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        [self.pullDelegate tableView:self didEndEditingRowAtIndexPath:indexPath];
    }
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [self.pullDelegate tableView:self targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    else {
        return nil;
    }
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    // return 'depth' of row for hierarchies
    if (self.pullDelegate && [self.pullDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        return [self.pullDelegate tableView:self indentationLevelForRowAtIndexPath:indexPath];
    }
    else {
        return 0;
    }
}

@end
