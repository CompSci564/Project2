-- User Table
CREATE TABLE User (
    UserID TEXT,
    Rating INTEGER,
    Location TEXT,
    Country TEXT,
    PRIMARY KEY (UserID, Rating)
);

-- Category Table
CREATE TABLE Category (
    CategoryName TEXT,
    ItemID INTEGER,
    PRIMARY KEY (CategoryName, ItemID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

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
    SellerID TEXT,
    CategoryName TEXT,
    FOREIGN KEY (SellerID) REFERENCES User(UserID),
    FOREIGN KEY (CategoryName) REFERENCES Category(CategoryName)
);

-- Bid Table
CREATE TABLE Bid (
    ItemID INTEGER,
    UserID TEXT,
    Amount REAL,
    Time DATE,
    PRIMARY KEY (ItemID, UserID, Time),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);
