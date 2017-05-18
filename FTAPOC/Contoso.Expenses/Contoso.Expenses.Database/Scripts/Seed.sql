if not exists (select 1 from dbo.Expense)

BEGIN

INSERT INTO dbo.Expense (Purpose, [Date], [Cost Center], [Amount], [Approver], [Receipt])  values ('FastTrack team visit-1', '2017-4-10', '101',  500, 'Dennis', 'http://contosocandies-cdnep.azureedge.net/cdn/candie-3.jpg')
INSERT INTO dbo.Expense (Purpose, [Date], [Cost Center], [Amount], [Approver], [Receipt])  values ('FastTrack team visit-2', '2017-5-11', '102', 600, 'Anusha', 'http://contosocandies-cdnep.azureedge.net/cdn/candie-4.jpg')
INSERT INTO dbo.Expense (Purpose, [Date], [Cost Center], [Amount], [Approver], [Receipt])  values ('FastTrack team visit-3', '2017-3-09', '104', 800, 'Anusha', 'http://contosocandies-cdnep.azureedge.net/cdn/candie-1.jpg')

END