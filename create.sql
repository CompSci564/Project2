-- -- User Table
-- CREATE TABLE User (
--     UserID INTEGER PRIMARY KEY,
--     Location TEXT,
--     Country TEXT,
--     Rating INTEGER
-- );

-- -- Category Table
-- CREATE TABLE Category (
--     CategoryName TEXT PRIMARY KEY
-- );

-- Item Table
CREATE TABLE Item (
    ItemID INTEGER PRIMARY KEY,
    Name TEXT,
    Currently REAL,
    Description TEXT,
    Number_of_Bids INTEGER,
    First_Bid REAL,
    Buy_Price REAL,
    Started DATE,
    Ends DATE,
    SellerID INTEGER,
    CategoryName TEXT,
    FOREIGN KEY (SellerID) REFERENCES User(UserID),
    FOREIGN KEY (CategoryName) REFERENCES Category(CategoryName)
);

-- -- Bid Table
-- CREATE TABLE Bid (
--     ItemID INTEGER,
--     UserID INTEGER,
--     Amount REAL,
--     Time DATE,
--     PRIMARY KEY (ItemID, UserID),
--     FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
--     FOREIGN KEY (UserID) REFERENCES User(UserID)
-- );
