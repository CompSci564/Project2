SELECT COUNT(DISTINCT SellerID) 
FROM Item 
WHERE SellerID IN (SELECT DISTINCT UserID FROM Bid);