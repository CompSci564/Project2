DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Bid;
DROP TABLE IF EXISTS User;

CREATE TABLE Item (
    ItemID INTEGER PRIMARY KEY,
    Name TEXT,
    Currently REAL,
    Description TEXT,
    Number_of_Bids INTEGER,
    First_Bid REAL,
    Buy_Price REAL,
    Started DATE,
    Ends DATE
);

CREATE TABLE Category (
    CategoryName TEXT PRIMARY KEY
);

CREATE TABLE User (
    UserID INTEGER PRIMARY KEY,
    Location TEXT,
    Country TEXT,
    Rating INTEGER
);

CREATE TABLE Bid (
    Amount REAL,
    Time DATE,
    ItemID INTEGER NOT NULL,
    UserID INTEGER NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);
