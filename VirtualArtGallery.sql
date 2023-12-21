CREATE DATABASE VirtualGallery;

USE VirtualGallery;

CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);

CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description,
ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso powerful anti-war mural.', 'guernica.jpg');

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description)
VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);

-- 1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
ORDER BY ArtworkCount DESC;

-- 2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.
SELECT Artworks.Title, Artists.Name, Artworks.Year
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
WHERE Artists.Nationality IN ('Spanish', 'Dutch')
ORDER BY Artworks.Year ASC;

-- 3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category.
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
WHERE Artworks.CategoryID = 1  -- Assuming 'Painting' has CategoryID = 1
GROUP BY Artists.Name;

-- 4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.
SELECT Artworks.Title, Artists.Name, Categories.Name AS Category
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';

-- 5. Find the artists who have more than two artworks in the gallery.
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

-- 6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions
SELECT DISTINCT Artworks.Title
FROM Artworks
JOIN ExhibitionArtworks ea1 ON Artworks.ArtworkID = ea1.ArtworkID
JOIN ExhibitionArtworks ea2 ON Artworks.ArtworkID = ea2.ArtworkID
JOIN Exhibitions e1 ON ea1.ExhibitionID = e1.ExhibitionID
JOIN Exhibitions e2 ON ea2.ExhibitionID = e2.ExhibitionID
WHERE e1.Title = 'Modern Art Masterpieces' AND e2.Title = 'Renaissance Art';

-- 7. Find the total number of artworks in each category
SELECT Categories.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name;

-- 8. List artists who have more than 3 artworks in the gallery.
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 3;

-- 9. Find the artworks created by artists from a specific nationality (e.g., Spanish).
SELECT Artworks.Title, Artists.Name, Artists.Nationality
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
WHERE Artists.Nationality = 'Spanish';

-- 10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.
SELECT e.Title
FROM Exhibitions e
JOIN ExhibitionArtworks ea1 ON e.ExhibitionID = ea1.ExhibitionID
JOIN ExhibitionArtworks ea2 ON e.ExhibitionID = ea2.ExhibitionID
JOIN Artworks a1 ON ea1.ArtworkID = a1.ArtworkID
JOIN Artworks a2 ON ea2.ArtworkID = a2.ArtworkID
JOIN Artists av ON a1.ArtistID = av.ArtistID
JOIN Artists al ON a2.ArtistID = al.ArtistID
WHERE (av.Name = 'Vincent van Gogh' AND al.Name = 'Leonardo da Vinci')

-- 11.Find all the artworks that have not been included in any exhibition.
SELECT Artworks.*
FROM Artworks
LEFT JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
WHERE ExhibitionArtworks.ArtworkID IS NULL;

-- 12. List artists who have created artworks in all available categories.
SELECT Artists.ArtistID, Artists.Name
FROM Artists
WHERE NOT EXISTS (
    SELECT CategoryID
    FROM Categories
    EXCEPT
    SELECT DISTINCT CategoryID
    FROM Artworks
    WHERE Artworks.ArtistID = Artists.ArtistID
);

-- 13. List the total number of artworks in each category.
SELECT Categories.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name;

-- 14.Find the artists who have more than 2 artworks in the gallery.
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

-- 15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.
SELECT Categories.Name, AVG(Artworks.Year) AS AverageYear
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name
HAVING COUNT(Artworks.ArtworkID) > 1;

-- 16.Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
SELECT Artworks.Title, Artworks.ArtistID, Artists.Name
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';

-- 17.Find the categories where the average year of artworks is greater than the average year of all artworks.
SELECT
    C.CategoryID,
    C.Name AS CategoryName,
    AVG(W.Year) AS AverageYearInCategory,
    (SELECT AVG(Year) FROM Artworks) AS AverageYearOverall
FROM Categories C
JOIN  Artworks W ON C.CategoryID = W.CategoryID
GROUP BY C.CategoryID, C.Name
HAVING AVG(W.Year) > (SELECT AVG(Year) FROM Artworks);

-- 18. List the artworks that were not exhibited in any exhibition.
SELECT Artworks.*
FROM Artworks
WHERE Artworks.ArtworkID NOT IN (SELECT ArtworkID FROM ExhibitionArtworks);

-- 19.Show artists who have artworks in the same category as "Mona Lisa."
SELECT DISTINCT
    A.ArtistID,
    A.Name AS ArtistName,
    AC.CategoryID,
    AC.CategoryName
FROM Artists A
JOIN Artworks AW ON A.ArtistID = AW.ArtistID
JOIN (SELECT AW.CategoryID,C.Name AS CategoryName FROM Artworks AW
JOIN Categories C ON AW.CategoryID = C.CategoryID
WHERE AW.Title = 'Mona Lisa') 
AC ON AW.CategoryID = AC.CategoryID AND A.ArtistID != (SELECT ArtistID FROM Artworks WHERE Title = 'Mona Lisa');

-- 20. List the names of artists and the number of artworks they have in the gallery.
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name;

