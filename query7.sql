SELECT COUNT(DISTINCT c.CategoryName)
FROM Category c
JOIN Item i ON c.ItemID = i.ItemID
JOIN Bid b ON i.ItemID = b.ItemID
WHERE b.Amount > 100;
