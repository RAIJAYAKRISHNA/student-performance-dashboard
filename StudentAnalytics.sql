--Creation of Student Database
CREATE DATABASE StudentAnalytics;
GO
-- Using it
USE StudentAnalytics;
GO

--Creating Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    Gender VARCHAR(10)
);

--Creating Subjects Table
CREATE TABLE Subjects (
    SubjectID INT PRIMARY KEY,
    SubjectName VARCHAR(50)
);

--Creating Marks Table
CREATE TABLE Marks (
    MarkID INT PRIMARY KEY,
    StudentID INT,
    SubjectID INT,
    Marks INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

--Inserting Data into Students Table
INSERT INTO Students VALUES
(101,'Rahul','Male'),
(102,'Priya','Female'),
(103,'Arjun','Male'),
(104,'Sneha','Female'),
(105,'Kiran','Male'),
(106,'Anjali','Female'),
(107,'Ravi','Male'),
(108,'Meena','Female');

--Inserting Data into Subjects Table
INSERT INTO Subjects VALUES
(1,'DBMS'),
(2,'Python'),
(3,'Statistics'),
(4,'Excel');

--Inserting Data into Marks Table
INSERT INTO Marks VALUES
(1,101,1,85),(2,101,2,90),(3,101,3,78),(4,101,4,88),
(5,102,1,92),(6,102,2,95),(7,102,3,89),(8,102,4,91),
(9,103,1,70),(10,103,2,75),(11,103,3,68),(12,103,4,72),
(13,104,1,88),(14,104,2,82),(15,104,3,90),(16,104,4,85),
(17,105,1,60),(18,105,2,65),(19,105,3,58),(20,105,4,62),
(21,106,1,95),(22,106,2,96),(23,106,3,94),(24,106,4,93),
(25,107,1,78),(26,107,2,80),(27,107,3,76),(28,107,4,82),
(29,108,1,89),(30,108,2,91),(31,108,3,87),(32,108,4,90);


--Task 1: Total Students

SELECT 
    COUNT(*) AS TotalStudents
FROM dbo.Students;

--Task 2: Subject - wise Average Marks
SELECT
    s.SubjectID,
    s.SubjectName,
    AVG(m.Marks) As SubjectWiseAvgMarks
FROM dbo.Subjects s
JOIN dbo.Marks m
    ON s.SubjectID = m.SubjectID
GROUP BY s.SubjectID,s.SubjectName

--Task 3: Top 5 Students
SELECT TOP 5
    s.StudentName,
    SUM(m.Marks) AS TotalScore,
    ROUND(AVG(CAST(m.Marks AS DECIMAL(10,2))), 2) AS AverageScore
FROM dbo.Students s
JOIN dbo.Marks m
    ON s.StudentID = m.StudentID
GROUP BY s.StudentName
ORDER BY TotalScore DESC;

--Task 4: Gender distribution
SELECT
    Gender,
    COUNT(*) AS StudentCount
FROM dbo.Students
GROUP BY Gender

--Task 5: Pass Percentage
SELECT
ROUND(
100.0 * SUM(CASE WHEN Marks >= 40 THEN 1 ELSE 0 END)
/ COUNT(*),
2
) AS PassPercentage
FROM Marks;

--Task 5: Student Ranking
SELECT
    st.StudentName,
    SUM(m.Marks) AS TotalScore,
    ROUND(AVG(CAST(m.Marks AS DECIMAL(10,2))),2) AS AverageScore,
    RANK() OVER (
        ORDER BY SUM(m.Marks) DESC
    ) AS StudentRank
FROM Marks m
JOIN Students st
    ON m.StudentID = st.StudentID
GROUP BY st.StudentName;