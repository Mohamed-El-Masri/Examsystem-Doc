-- This is a placeholder file for the SQL script
-- In a real implementation, this would contain the complete SQL script for creating the Online Exam System database
-- The actual file would be several hundred lines of SQL code including:
-- - Table creation statements
-- - Stored procedure definitions
-- - Initial data insertion
-- - Constraints and indexes

-- For demonstration purposes, this placeholder indicates where the real SQL file would be placed
-- Users would download this file and execute it in SQL Server Management Studio to create the database schema

-- =============================================
-- SECTION: TABLE CREATION - INITIAL SCHEMA
-- =============================================
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Password VARCHAR(255),
    UserType VARCHAR(10) CHECK (UserType IN ('Student', 'Instructor'))
);

CREATE TABLE Students (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE
);

CREATE TABLE Instructors (
    UserID INT PRIMARY KEY,
    DepartmentID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses (
    Course_id INT PRIMARY KEY,
    Crs_name VARCHAR(100),
    Ins_id INT,
    FOREIGN KEY (Ins_id) REFERENCES Instructors(UserID) ON DELETE SET NULL
);

CREATE TABLE Student_Course (
    Crs_id INT,
    Std_id INT,
    PRIMARY KEY (Crs_id, Std_id),
    FOREIGN KEY (Crs_id) REFERENCES Courses(Course_id) ON DELETE CASCADE,
    FOREIGN KEY (Std_id) REFERENCES Students(UserID) ON DELETE CASCADE
);

CREATE TABLE Exam (
    Exam_id INT PRIMARY KEY,
    Exme_name VARCHAR(100),
    Crs_id INT,
    FOREIGN KEY (Crs_id) REFERENCES Courses(Course_id) ON DELETE CASCADE
);

CREATE TABLE Student_Grades (
    StudentID INT,
    ExamID INT,
    Grade DECIMAL(5,2),
    PRIMARY KEY (StudentID, ExamID),
    FOREIGN KEY (StudentID) REFERENCES Students(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ExamID) REFERENCES Exam(Exam_id) ON DELETE CASCADE
);

CREATE TABLE Questions (
    Q_id INT PRIMARY KEY,
    Exam_id INT,
    Q_text TEXT,
    Q_type VARCHAR(20) CHECK (Q_type IN ('MCQ', 'True/False')),
    FOREIGN KEY (Exam_id) REFERENCES Exam(Exam_id) ON DELETE CASCADE
);

CREATE TABLE Choice (
    Ch_id INT PRIMARY KEY,
    Q_id INT,
    ChoiceText TEXT,
    IsCorrect BIT,
    FOREIGN KEY (Q_id) REFERENCES Questions(Q_id) ON DELETE CASCADE
);

CREATE TABLE Student_Answers (
    StudentID INT,
    QuestionID INT,
    ExamID INT,
    SelectedChoiceID INT,
    PRIMARY KEY (StudentID, QuestionID, ExamID), 
    FOREIGN KEY (StudentID) REFERENCES Students(UserID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(Q_id),
    FOREIGN KEY (ExamID) REFERENCES Exam(Exam_id),
    FOREIGN KEY (SelectedChoiceID) REFERENCES Choice(Ch_id)
);

-- =============================================
-- SECTION: INITIAL DATA INSERTION
-- =============================================
INSERT INTO Users (UserID, UserName, Email, Password, UserType) VALUES
(1, 'Ali Ahmed', 'ali@example.com', 'pass123', 'Student'),
(2, 'Mona Mohamed', 'mona@example.com', 'pass456', 'Student'),
(3, 'Dr. Hassan', 'hassan@example.com', 'pass789', 'Instructor'),
(4, 'Dr. khaled', 'khaled@example.com', 'pass789', 'Instructor');

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Information Systems');

INSERT INTO Instructors (UserID, DepartmentID) VALUES
(3, 1),
(4, 1);

INSERT INTO Students (UserID) VALUES
(1),
(2);

INSERT INTO Courses (Course_id, Crs_name, Ins_id) VALUES
(101, 'Database Systems', 3),
(102, 'Web Development', 3);

INSERT INTO Student_Course (Crs_id, Std_id) VALUES
(101, 1),
(102, 2);

INSERT INTO Exam (Exam_id, Exme_name, Crs_id) VALUES
(201, 'Midterm Exam', 101),
(202, 'Final Exam', 102);

INSERT INTO Questions (Q_id, Exam_id, Q_text, Q_type) VALUES
(301, 201, 'What is SQL?', 'MCQ'),
(302, 201, 'Is HTML a programming language?', 'True/False');

INSERT INTO Choice (Ch_id, Q_id, ChoiceText, IsCorrect) VALUES
(401, 301, 'Structured Query Language', 1),
(402, 301, 'Simple Query Language', 0),
(403, 302, 'True', 0),
(404, 302, 'False', 1);

INSERT INTO Student_Grades (StudentID, ExamID, Grade) VALUES
(1, 201, 85.50),
(2, 202, 90.00);

INSERT INTO Student_Answers (StudentID, QuestionID, ExamID, SelectedChoiceID) VALUES
(1, 301, 201, 401),
(1, 302, 201, 403),
(2, 301, 201, 402),
(2, 302, 201, 404);

-- =============================================
-- SECTION: UPDATED SCHEMA WITH IDENTITY COLUMNS
-- =============================================
-- Drop existing tables if you want to recreate them with IDENTITY
/*
DROP TABLE IF EXISTS Student_Answers;
DROP TABLE IF EXISTS Choice;
DROP TABLE IF EXISTS Questions;
DROP TABLE IF EXISTS Student_Grades;
DROP TABLE IF EXISTS Exam;
DROP TABLE IF EXISTS Student_Course;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Instructors;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Users;
*/

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Password VARCHAR(255),
    UserType VARCHAR(10) CHECK (UserType IN ('Student', 'Instructor'))
);

CREATE TABLE Students (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE
);

CREATE TABLE Instructors (
    UserID INT PRIMARY KEY,
    DepartmentID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses (
    Course_id INT IDENTITY(1,1) PRIMARY KEY,
    Crs_name VARCHAR(100),
    Ins_id INT,
    FOREIGN KEY (Ins_id) REFERENCES Instructors(UserID) ON DELETE SET NULL
);

CREATE TABLE Student_Course (
    Crs_id INT,
    Std_id INT,
    PRIMARY KEY (Crs_id, Std_id),
    FOREIGN KEY (Crs_id) REFERENCES Courses(Course_id) ON DELETE CASCADE,
    FOREIGN KEY (Std_id) REFERENCES Students(UserID) ON DELETE CASCADE
);

CREATE TABLE Exam (
    Exam_id INT IDENTITY(1,1) PRIMARY KEY,
    Exme_name VARCHAR(100),
    Crs_id INT,
    FOREIGN KEY (Crs_id) REFERENCES Courses(Course_id) ON DELETE CASCADE
);

CREATE TABLE Student_Grades (
    StudentID INT,
    ExamID INT,
    Grade DECIMAL(5,2),
    PRIMARY KEY (StudentID, ExamID),
    FOREIGN KEY (StudentID) REFERENCES Students(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ExamID) REFERENCES Exam(Exam_id) ON DELETE CASCADE
);

CREATE TABLE Questions (
    Q_id INT IDENTITY(1,1) PRIMARY KEY,
    Exam_id INT,
    Q_text TEXT,
    Q_type VARCHAR(20) CHECK (Q_type IN ('MCQ', 'True/False')),
    FOREIGN KEY (Exam_id) REFERENCES Exam(Exam_id) ON DELETE CASCADE
);

CREATE TABLE Choice (
    Ch_id INT IDENTITY(1,1) PRIMARY KEY,
    Q_id INT,
    ChoiceText TEXT,
    IsCorrect BIT,
    FOREIGN KEY (Q_id) REFERENCES Questions(Q_id) ON DELETE CASCADE
);

CREATE TABLE Student_Answers (
    StudentID INT,
    QuestionID INT,
    ExamID INT,
    SelectedChoiceID INT,
    PRIMARY KEY (StudentID, QuestionID, ExamID), 
    FOREIGN KEY (StudentID) REFERENCES Students(UserID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(Q_id),
    FOREIGN KEY (ExamID) REFERENCES Exam(Exam_id),
    FOREIGN KEY (SelectedChoiceID) REFERENCES Choice(Ch_id)
);

-- =============================================
-- SECTION: IDENTITY RESET COMMANDS
-- =============================================
DBCC CHECKIDENT ('Exam', RESEED, 0);
DBCC CHECKIDENT ('Questions', RESEED, 0);
DBCC CHECKIDENT ('Courses', RESEED, 0);
DBCC CHECKIDENT ('Choice', RESEED, 0);
DBCC CHECKIDENT ('Student_Answers', RESEED, 0);
DBCC CHECKIDENT ('Users', RESEED, 0);
DBCC CHECKIDENT ('Departments', RESEED, 0);

-- =============================================
-- SECTION: USER MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE InsertUser
    @UserID INT,
    @UserName VARCHAR(100),
    @Email VARCHAR(100),
    @Password VARCHAR(255),
    @UserType VARCHAR(10)
AS
BEGIN
    INSERT INTO Users (UserID, UserName, Email, Password, UserType)
    VALUES (@UserID, @UserName, @Email, @Password, @UserType);
END;

CREATE PROCEDURE UpdateUser
    @UserID INT,
    @UserName VARCHAR(100),
    @Email VARCHAR(100),
    @Password VARCHAR(255),
    @UserType VARCHAR(10)
AS
BEGIN
    UPDATE Users
    SET UserName = @UserName, Email = @Email, Password = @Password, UserType = @UserType
    WHERE UserID = @UserID;
END;

CREATE PROCEDURE DeleteUser
    @UserID INT
AS
BEGIN
    DELETE FROM Users WHERE UserID = @UserID;
END;

CREATE PROCEDURE GetUser
    @UserID INT
AS
BEGIN
    SELECT * FROM Users WHERE UserID = @UserID;
END;

-- =============================================
-- SECTION: STUDENT MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE InsertStudent
    @UserID INT
AS
BEGIN
    INSERT INTO Students (UserID) VALUES (@UserID);
END;

CREATE PROCEDURE DeleteStudent
    @UserID INT
AS
BEGIN
    DELETE FROM Students WHERE UserID = @UserID;
END;

CREATE PROCEDURE UpdateStudent
    @OldUserID INT,
    @NewUserID INT
AS
BEGIN
    UPDATE Students SET UserID = @NewUserID WHERE UserID = @OldUserID;
END;

CREATE PROCEDURE GetStudent
    @UserID INT
AS
BEGIN
    SELECT * FROM Students WHERE UserID = @UserID;
END;

CREATE PROCEDURE GetAllStudents
AS
BEGIN
    SELECT u.*, s.UserID AS StudentID
    FROM Users u
    JOIN Students s ON u.UserID = s.UserID
    WHERE u.UserType = 'Student';
END;

-- =============================================
-- SECTION: DEPARTMENT MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE InsertDepartment
    @DepartmentID INT, 
    @DepartmentName VARCHAR(100)
AS
BEGIN
    INSERT INTO Departments (DepartmentID, DepartmentName) 
    VALUES (@DepartmentID, @DepartmentName);
END;

CREATE PROCEDURE UpdateDepartment
    @DepartmentID INT, 
    @NewDepartmentName VARCHAR(100)
AS
BEGIN
    UPDATE Departments 
    SET DepartmentName = @NewDepartmentName 
    WHERE DepartmentID = @DepartmentID;
END;

CREATE PROCEDURE DeleteDepartment
    @DepartmentID INT
AS
BEGIN
    DELETE FROM Departments 
    WHERE DepartmentID = @DepartmentID;
END;

CREATE PROCEDURE GetDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT * FROM Departments 
    WHERE DepartmentID = @DepartmentID;
END;

CREATE PROCEDURE GetAllDepartments
AS
BEGIN
    SELECT * FROM Departments
    ORDER BY DepartmentName;
END;

-- =============================================
-- SECTION: INSTRUCTOR MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE sp_InsertInstructor
    @UserID INT,
    @DepartmentID INT
AS
BEGIN
    INSERT INTO Instructors (UserID, DepartmentID)
    VALUES (@UserID, @DepartmentID);
END;

CREATE PROCEDURE sp_UpdateInstructor
    @UserID INT,
    @DepartmentID INT
AS
BEGIN
    UPDATE Instructors
    SET DepartmentID = @DepartmentID
    WHERE UserID = @UserID;
END;

CREATE PROCEDURE sp_DeleteInstructor
    @UserID INT
AS
BEGIN
    DELETE FROM Instructors WHERE UserID = @UserID;
END;

CREATE PROCEDURE sp_GetInstructor
    @UserID INT
AS
BEGIN
    SELECT * FROM Instructors WHERE UserID = @UserID;
END;

CREATE PROCEDURE sp_GetAllInstructors
AS
BEGIN
    SELECT u.*, i.DepartmentID, d.DepartmentName
    FROM Users u
    JOIN Instructors i ON u.UserID = i.UserID
    JOIN Departments d ON i.DepartmentID = d.DepartmentID
    WHERE u.UserType = 'Instructor'
    ORDER BY u.UserName;
END;

-- =============================================
-- SECTION: COURSE MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE sp_InsertCourse
    @Course_id INT,
    @Crs_name VARCHAR(100),
    @Ins_id INT
AS
BEGIN
    INSERT INTO Courses (Course_id, Crs_name, Ins_id)
    VALUES (@Course_id, @Crs_name, @Ins_id);
END;

CREATE PROCEDURE sp_UpdateCourse
    @Course_id INT,
    @Crs_name VARCHAR(100),
    @Ins_id INT
AS
BEGIN
    UPDATE Courses
    SET Crs_name = @Crs_name, Ins_id = @Ins_id
    WHERE Course_id = @Course_id;
END;

CREATE PROCEDURE sp_DeleteCourse
    @Course_id INT
AS
BEGIN
    DELETE FROM Courses WHERE Course_id = @Course_id;
END;

CREATE PROCEDURE sp_GetCourse
    @Course_id INT
AS
BEGIN
    SELECT * FROM Courses WHERE Course_id = @Course_id;
END;

CREATE PROCEDURE sp_GetAllCourses
AS
BEGIN
    SELECT c.*, u.UserName AS InstructorName
    FROM Courses c
    JOIN Instructors i ON c.Ins_id = i.UserID
    JOIN Users u ON i.UserID = u.UserID
    ORDER BY c.Crs_name;
END;

CREATE PROCEDURE sp_EnrollStudentInCourse
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student_Course WHERE Std_id = @StudentID AND Crs_id = @CourseID)
    BEGIN
        INSERT INTO Student_Course (Std_id, Crs_id)
        VALUES (@StudentID, @CourseID);
    END
END;

CREATE PROCEDURE sp_UnenrollStudentFromCourse
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    DELETE FROM Student_Course 
    WHERE Std_id = @StudentID AND Crs_id = @CourseID;
END;

-- =============================================
-- SECTION: EXAM MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE sp_InsertExam
    @Exam_id INT,
    @Exam_name VARCHAR(100),
    @Crs_id INT
AS
BEGIN
    INSERT INTO Exam (Exam_id, Exme_name, Crs_id)
    VALUES (@Exam_id, @Exam_name, @Crs_id);
END;

CREATE PROCEDURE sp_UpdateExam
    @Exam_id INT,
    @Exam_name VARCHAR(100),
    @Crs_id INT
AS
BEGIN
    UPDATE Exam
    SET Exme_name = @Exam_name, Crs_id = @Crs_id
    WHERE Exam_id = @Exam_id;
END;

CREATE PROCEDURE sp_DeleteExam
    @Exam_id INT
AS
BEGIN
    DELETE FROM Exam WHERE Exam_id = @Exam_id;
END;

CREATE PROCEDURE sp_GetExam
    @Exam_id INT
AS
BEGIN
    SELECT * FROM Exam WHERE Exam_id = @Exam_id;
END;

CREATE PROCEDURE sp_GetExamsByCourse
    @CourseID INT
AS
BEGIN
    SELECT e.*, c.Crs_name
    FROM Exam e
    JOIN Courses c ON e.Crs_id = c.Course_id
    WHERE e.Crs_id = @CourseID
    ORDER BY e.Exme_name;
END;

CREATE PROCEDURE sp_GetAllExams
AS
BEGIN
    SELECT e.*, c.Crs_name
    FROM Exam e
    JOIN Courses c ON e.Crs_id = c.Course_id
    ORDER BY e.Exme_name;
END;

-- =============================================
-- SECTION: QUESTION MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE InsertQuestion
    @Q_id INT, 
    @Exam_id INT, 
    @Q_text TEXT, 
    @Q_type VARCHAR(20)
AS
BEGIN
    INSERT INTO Questions (Q_id, Exam_id, Q_text, Q_type)
    VALUES (@Q_id, @Exam_id, @Q_text, @Q_type);
END;

CREATE PROCEDURE UpdateQuestion
    @Q_id INT, 
    @NewExam_id INT, 
    @NewQ_text TEXT, 
    @NewQ_type VARCHAR(20)
AS
BEGIN
    UPDATE Questions
    SET Exam_id = @NewExam_id, Q_text = @NewQ_text, Q_type = @NewQ_type
    WHERE Q_id = @Q_id;
END;

CREATE PROCEDURE DeleteQuestion
    @Q_id INT
AS
BEGIN
    DELETE FROM Questions WHERE Q_id = @Q_id;
END;

CREATE PROCEDURE GetQuestions
AS
BEGIN
    SELECT * FROM Questions;
END;

CREATE PROCEDURE GetQuestionsByExam
    @ExamID INT
AS
BEGIN
    SELECT q.*, e.Exme_name
    FROM Questions q
    JOIN Exam e ON q.Exam_id = e.Exam_id
    WHERE q.Exam_id = @ExamID
    ORDER BY q.Q_id;
END;

CREATE PROCEDURE GetQuestionsByType
    @QuestionType VARCHAR(20)
AS
BEGIN
    SELECT q.*, e.Exme_name
    FROM Questions q
    JOIN Exam e ON q.Exam_id = e.Exam_id
    WHERE q.Q_type = @QuestionType
    ORDER BY q.Q_id;
END;

-- =============================================
-- SECTION: CHOICE MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE InsertChoice
    @Ch_id INT, 
    @Q_id INT, 
    @ChoiceText TEXT, 
    @IsCorrect BIT
AS
BEGIN
    INSERT INTO Choice (Ch_id, Q_id, ChoiceText, IsCorrect)
    VALUES (@Ch_id, @Q_id, @ChoiceText, @IsCorrect);
END;

CREATE PROCEDURE UpdateChoice
    @Ch_id INT, 
    @NewQ_id INT, 
    @NewChoiceText TEXT, 
    @NewIsCorrect BIT
AS
BEGIN
    UPDATE Choice
    SET Q_id = @NewQ_id, ChoiceText = @NewChoiceText, IsCorrect = @NewIsCorrect
    WHERE Ch_id = @Ch_id;
END;

CREATE PROCEDURE DeleteChoice
    @Ch_id INT
AS
BEGIN
    DELETE FROM Choice WHERE Ch_id = @Ch_id;
END;

CREATE PROCEDURE GetChoices
AS
BEGIN
    SELECT * FROM Choice;
END;

CREATE PROCEDURE GetChoicesByQuestion
    @QuestionID INT
AS
BEGIN
    SELECT c.*, q.Q_text
    FROM Choice c
    JOIN Questions q ON c.Q_id = q.Q_id
    WHERE c.Q_id = @QuestionID
    ORDER BY c.Ch_id;
END;

CREATE PROCEDURE GetCorrectChoices
AS
BEGIN
    SELECT c.*, q.Q_text
    FROM Choice c
    JOIN Questions q ON c.Q_id = q.Q_id
    WHERE c.IsCorrect = 1
    ORDER BY q.Q_id, c.Ch_id;
END;

-- =============================================
-- SECTION: STUDENT GRADES MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE InsertStudentGrade
    @StudentID INT, 
    @ExamID INT, 
    @Grade DECIMAL(5,2)
AS
BEGIN
    INSERT INTO Student_Grades (StudentID, ExamID, Grade)
    VALUES (@StudentID, @ExamID, @Grade);
END;

CREATE PROCEDURE UpdateStudentGrade
    @StudentID INT, 
    @ExamID INT, 
    @NewGrade DECIMAL(5,2)
AS
BEGIN
    UPDATE Student_Grades
    SET Grade = @NewGrade
    WHERE StudentID = @StudentID AND ExamID = @ExamID;
END;

CREATE PROCEDURE DeleteStudentGrade
    @StudentID INT, 
    @ExamID INT
AS
BEGIN
    DELETE FROM Student_Grades 
    WHERE StudentID = @StudentID AND ExamID = @ExamID;
END;

CREATE PROCEDURE GetStudentGrades
AS
BEGIN
    SELECT * FROM Student_Grades;
END;

CREATE PROCEDURE GetStudentGradesByExam
    @ExamID INT
AS
BEGIN
    SELECT sg.*, u.UserName, e.Exme_name
    FROM Student_Grades sg
    JOIN Users u ON sg.StudentID = u.UserID
    JOIN Exam e ON sg.ExamID = e.Exam_id
    WHERE sg.ExamID = @ExamID
    ORDER BY sg.Grade DESC;
END;

CREATE PROCEDURE GetStudentGradesByStudent
    @StudentID INT
AS
BEGIN
    SELECT sg.*, u.UserName, e.Exme_name, c.Crs_name
    FROM Student_Grades sg
    JOIN Users u ON sg.StudentID = u.UserID
    JOIN Exam e ON sg.ExamID = e.Exam_id
    JOIN Courses c ON e.Crs_id = c.Course_id
    WHERE sg.StudentID = @StudentID
    ORDER BY e.Exme_name;
END;

-- =============================================
-- SECTION: STUDENT ANSWERS MANAGEMENT STORED PROCEDURES
-- =============================================
CREATE PROCEDURE InsertStudentAnswer
    @StudentID INT, 
    @QuestionID INT, 
    @ExamID INT, 
    @SelectedChoiceID INT
AS
BEGIN
    INSERT INTO Student_Answers (StudentID, QuestionID, ExamID, SelectedChoiceID)
    VALUES (@StudentID, @QuestionID, @ExamID, @SelectedChoiceID);
END;

CREATE PROCEDURE UpdateStudentAnswer
    @StudentID INT, 
    @QuestionID INT, 
    @ExamID INT, 
    @NewSelectedChoiceID INT
AS
BEGIN
    UPDATE Student_Answers
    SET SelectedChoiceID = @NewSelectedChoiceID
    WHERE StudentID = @StudentID AND QuestionID = @QuestionID AND ExamID = @ExamID;
END;

CREATE PROCEDURE DeleteStudentAnswer
    @StudentID INT, 
    @QuestionID INT, 
    @ExamID INT
AS
BEGIN
    DELETE FROM Student_Answers 
    WHERE StudentID = @StudentID AND QuestionID = @QuestionID AND ExamID = @ExamID;
END;

CREATE PROCEDURE GetStudentAnswers
AS
BEGIN
    SELECT * FROM Student_Answers;
END;

CREATE PROCEDURE GetStudentAnswersByExam
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    SELECT sa.*, q.Q_text, c.ChoiceText
    FROM Student_Answers sa
    JOIN Questions q ON sa.QuestionID = q.Q_id
    JOIN Choice c ON sa.SelectedChoiceID = c.Ch_id
    WHERE sa.StudentID = @StudentID AND sa.ExamID = @ExamID;
END;

CREATE PROCEDURE GetCorrectStudentAnswers
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    SELECT sa.*, q.Q_text, c.ChoiceText, c.IsCorrect
    FROM Student_Answers sa
    JOIN Questions q ON sa.QuestionID = q.Q_id
    JOIN Choice c ON sa.SelectedChoiceID = c.Ch_id
    WHERE sa.StudentID = @StudentID 
        AND sa.ExamID = @ExamID
        AND c.IsCorrect = 1;
END;

-- =============================================
-- SECTION: ADVANCED EXAM GENERATION PROCEDURE
-- =============================================
CREATE PROCEDURE GenerateExam
    @ExamName VARCHAR(100),
    @CourseID INT,
    @NumMCQ INT,
    @NumTF INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ExamID INT;

    -- Create new exam
    INSERT INTO Exam (Exme_name, Crs_id)
    VALUES (@ExamName, @CourseID);

    SET @ExamID = SCOPE_IDENTITY();

    -- Create temporary table for question mapping
    CREATE TABLE #QuestionMapping (Q_id_Old INT, Q_id_New INT);

    -- Create temporary table for selected questions
    CREATE TABLE #SelectedQuestions (Q_id_Old INT, Q_text NVARCHAR(MAX), Q_type VARCHAR(50));

    -- Select MCQ questions
    INSERT INTO #SelectedQuestions (Q_id_Old, Q_text, Q_type)
    SELECT TOP (@NumMCQ) Q_id, Q_text, Q_type
    FROM Questions 
    WHERE Q_type = 'MCQ' AND Exam_id IN (SELECT Exam_id FROM Exam WHERE Crs_id = @CourseID)
    ORDER BY Q_id;

    -- Select True/False questions
    INSERT INTO #SelectedQuestions (Q_id_Old, Q_text, Q_type)
    SELECT TOP (@NumTF) Q_id, Q_text, Q_type
    FROM Questions 
    WHERE Q_type = 'True/False' AND Exam_id IN (SELECT Exam_id FROM Exam WHERE Crs_id = @CourseID)
    ORDER BY Q_id;

    -- Insert new questions and map to old ones
    DECLARE @TempMapping TABLE (Q_id_New INT, Q_text NVARCHAR(MAX), Q_type VARCHAR(50));

    INSERT INTO Questions (Exam_id, Q_text, Q_type)
    OUTPUT Inserted.Q_id, Inserted.Q_text, Inserted.Q_type INTO @TempMapping (Q_id_New, Q_text, Q_type)
    SELECT @ExamID, Q_text, Q_type FROM #SelectedQuestions;

    INSERT INTO #QuestionMapping (Q_id_New, Q_id_Old)
    SELECT T.Q_id_New, S.Q_id_Old 
    FROM @TempMapping T
    INNER JOIN #SelectedQuestions S ON T.Q_text = S.Q_text AND T.Q_type = S.Q_type;

    -- Copy choices for new questions
    INSERT INTO Choice (Q_id, ChoiceText, IsCorrect)
    SELECT QM.Q_id_New, C.ChoiceText, C.IsCorrect
    FROM Choice C
    INNER JOIN #QuestionMapping QM ON C.Q_id = QM.Q_id_Old;

    -- Clean up temporary tables
    DROP TABLE #QuestionMapping;
    DROP TABLE #SelectedQuestions;
    
    -- Return the ID of the created exam
    SELECT @ExamID AS ExamID;
END;

-- =============================================
-- SECTION: EXAM SUBMISSION PROCEDURE
-- =============================================
-- Create user-defined table type for submitting answers
CREATE TYPE AnswerTableType AS TABLE 
(
    QuestionID INT, 
    SelectedChoiceID INT
);

-- Create procedure for submitting exam answers
CREATE PROCEDURE SubmitExamAnswers
    @StudentID INT,
    @ExamID INT,
    @Answers AnswerTableType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Insert student answers
    INSERT INTO Student_Answers (StudentID, QuestionID, ExamID, SelectedChoiceID)
    SELECT @StudentID, QuestionID, @ExamID, SelectedChoiceID
    FROM @Answers;

    -- Call the correction procedure to grade the exam
    EXEC ExamCorrection @ExamID, @StudentID;
    
    PRINT 'Exam answers submitted and graded successfully!';
END;

-- =============================================
-- SECTION: EXAM CORRECTION PROCEDURE
-- =============================================
CREATE PROCEDURE ExamCorrection
    @ExamID INT,
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalGrade INT = 0;
    DECLARE @MaxGrade INT;
    
    -- Get the total number of questions in the exam
    SELECT @MaxGrade = COUNT(*) 
    FROM Questions 
    WHERE Exam_id = @ExamID;
    
    -- If no questions found, set MaxGrade to default value to avoid division by zero
    IF @MaxGrade IS NULL OR @MaxGrade = 0
        SET @MaxGrade = 1;

    -- Calculate total correct answers
    SELECT @TotalGrade = COUNT(*)
    FROM Student_Answers sa
    JOIN (
        SELECT 
            Ch_id, 
            Q_id, 
            IsCorrect
        FROM Choice
    ) c ON sa.QuestionID = c.Q_id AND sa.SelectedChoiceID = c.Ch_id
    WHERE sa.StudentID = @StudentID
      AND sa.ExamID = @ExamID
      AND c.IsCorrect = 1;  -- Only correct answers

    -- Check if student grade already exists
    IF EXISTS (SELECT 1 FROM Student_Grades WHERE StudentID = @StudentID AND ExamID = @ExamID)
    BEGIN
        -- Update existing grade
        UPDATE Student_Grades
        SET Grade = (@TotalGrade * 100.0) / @MaxGrade  -- Convert to percentage
        WHERE StudentID = @StudentID AND ExamID = @ExamID;
    END
    ELSE
    BEGIN
        -- Insert new grade
        INSERT INTO Student_Grades (StudentID, ExamID, Grade)
        VALUES (
            @StudentID, 
            @ExamID, 
            (@TotalGrade * 100.0) / @MaxGrade  -- Convert to percentage
        );
    END

    -- Output results
    PRINT 'Total Correct Answers: ' + CAST(@TotalGrade AS VARCHAR);
    PRINT 'Max Grade: ' + CAST(@MaxGrade AS VARCHAR);
    PRINT 'Grade Inserted: ' + CAST((@TotalGrade * 100.0) / @MaxGrade AS VARCHAR) + '%';
END;

