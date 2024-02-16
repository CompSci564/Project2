SELECT COUNT(*) 
FROM User 
WHERE UserID IN (SELECT DISTINCT SellerID FROM Item) AND Rating > 1000;