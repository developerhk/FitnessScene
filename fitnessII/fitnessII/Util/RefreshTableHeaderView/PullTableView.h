//
//  PullTableView.h
//  MyPullTableView
//
//  Created by lu jingyu on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
//#import "PMicSwipDeleteTableView.h"

@protocol PullTableViewDataSource;
@protocol PullTableViewDelegate;

@interface PullTableView : UITableView <LoadMoreTableFooterViewDelegate, EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
	
	LoadMoreTableFooterView   *_loadMoreFooterView;
	BOOL _loadingMore;
    
    id<PullTableViewDataSource> pullDataSource;
    id<PullTableViewDelegate>   pullDelegate;
    
}
@property (nonatomic, retain) UIColor  *refreshHeaderViewBackgroundColor;
@property (nonatomic, assign) id<PullTableViewDataSource> pullDataSource;
@property (nonatomic, assign) id<PullTableViewDelegate>   pullDelegate;

@property (nonatomic, assign) BOOL needPullToRefresh;  // 是否下拉刷新     Default is YES
@property (nonatomic, assign) BOOL needPullToLoadMore; // 是否上拉加载更多  Default is NO

/**
 下拉刷新数据完毕后，执行本方法将headerView状态置为normal
 */
- (void)doneLoadingTableViewData;

/**
 上提加载数据完毕后，执行本方法将footerView状态置为normal
 @param 	end  是否到头了
 */
- (void)doneLoadingMoreTableViewData;

/**
 上提加载完毕后，如果已经全部加载完毕后，置isEnd为YES
 只有当needPullToLoadMore为YES时，本方法才有效果
 */
- (void)loadingMoreToTheEnd:(BOOL)isEnd;

@end

@protocol PullTableViewDataSource <NSObject>

@required

- (NSInteger)tableView:(PullTableView *)tableView numberOfRowsInSection:(NSInteger)section;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(PullTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(PullTableView *)tableView;              // Default is 1 if not implemented

- (NSString *)tableView:(PullTableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
- (NSString *)tableView:(PullTableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(PullTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(PullTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

- (NSArray *)sectionIndexTitlesForTableView:(PullTableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(PullTableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(PullTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

// Data manipulation - reorder / moving support

- (void)tableView:(PullTableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@protocol PullTableViewDelegate <NSObject>


@optional

- (void)tableViewStartLoadingNewData:(PullTableView *)tableView;

- (void)tableViewLoadingMoreData:(PullTableView *)tableView;

// ScrollView delegate
- (void)tableView:(PullTableView *)tableView scrollViewDidScroll:(UIScrollView *)scrollView;

// Display customization

- (void)tableView:(PullTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

// Variable height support

- (CGFloat)tableView:(PullTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(PullTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(PullTableView *)tableView heightForFooterInSection:(NSInteger)section;

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(PullTableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(PullTableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures).

- (void)tableView:(PullTableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

// Selection

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(PullTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
// Called after the user changes the selection.
- (void)tableView:(PullTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(PullTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(PullTableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(PullTableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(PullTableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(PullTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

// Indentation

- (NSInteger)tableView:(PullTableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies

@end
