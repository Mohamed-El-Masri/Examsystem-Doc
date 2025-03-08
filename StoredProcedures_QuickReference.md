# Online Exam System - Stored Procedures Quick Reference

This document provides a quick reference for all stored procedures in the Online Exam System database.

## User Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `InsertUser` | Adds a new user | `@UserID`, `@UserName`, `@Email`, `@Password`, `@UserType` |
| `UpdateUser` | Updates user information | `@UserID`, `@UserName`, `@Email`, `@Password`, `@UserType` |
| `DeleteUser` | Removes a user | `@UserID` |
| `GetUser` | Retrieves user information | `@UserID` |

## Student Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `InsertStudent` | Registers a new student | `@UserID` |
| `DeleteStudent` | Removes a student | `@UserID` |
| `UpdateStudent` | Updates student information | `@OldUserID`, `@NewUserID` |
| `GetStudent` | Retrieves student information | `@UserID` |
| `GetAllStudents` | Lists all students | None |

## Department Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `InsertDepartment` | Creates a new department | `@DepartmentID`, `@DepartmentName` |
| `UpdateDepartment` | Updates department information | `@DepartmentID`, `@NewDepartmentName` |
| `DeleteDepartment` | Removes a department | `@DepartmentID` |
| `GetDepartment` | Retrieves department information | `@DepartmentID` |
| `GetAllDepartments` | Lists all departments | None |

## Instructor Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `sp_InsertInstructor` | Assigns an instructor to a department | `@UserID`, `@DepartmentID` |
| `sp_UpdateInstructor` | Updates instructor information | `@UserID`, `@DepartmentID` |
| `sp_DeleteInstructor` | Removes an instructor | `@UserID` |
| `sp_GetInstructor` | Retrieves instructor information | `@UserID` |
| `sp_GetAllInstructors` | Lists all instructors | None |

## Course Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `sp_InsertCourse` | Creates a new course | `@Course_id`, `@Crs_name`, `@Ins_id` |
| `sp_UpdateCourse` | Updates course information | `@Course_id`, `@Crs_name`, `@Ins_id` |
| `sp_DeleteCourse` | Removes a course | `@Course_id` |
| `sp_GetCourse` | Retrieves course information | `@Course_id` |
| `sp_GetAllCourses` | Lists all courses | None |
| `sp_EnrollStudentInCourse` | Enrolls a student in a course | `@StudentID`, `@CourseID` |
| `sp_UnenrollStudentFromCourse` | Removes a student from a course | `@StudentID`, `@CourseID` |

## Exam Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `sp_InsertExam` | Creates a new exam | `@Exam_id`, `@Exam_name`, `@Crs_id` |
| `sp_UpdateExam` | Updates exam information | `@Exam_id`, `@Exam_name`, `@Crs_id` |
| `sp_DeleteExam` | Removes an exam | `@Exam_id` |
| `sp_GetExam` | Retrieves exam information | `@Exam_id` |
| `sp_GetExamsByCourse` | Lists exams for a specific course | `@CourseID` |
| `sp_GetAllExams` | Lists all exams | None |

## Question Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `InsertQuestion` | Adds a question to an exam | `@Q_id`, `@Exam_id`, `@Q_text`, `@Q_type` |
| `UpdateQuestion` | Updates question information | `@Q_id`, `@NewExam_id`, `@NewQ_text`, `@NewQ_type` |
| `DeleteQuestion` | Removes a question | `@Q_id` |
| `GetQuestions` | Lists all questions | None |
| `GetQuestionsByExam` | Lists questions for a specific exam | `@ExamID` |
| `GetQuestionsByType` | Lists questions of a specific type | `@QuestionType` |

## Choice Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `InsertChoice` | Adds an answer choice to a question | `@Ch_id`, `@Q_id`, `@ChoiceText`, `@IsCorrect` |
| `UpdateChoice` | Updates choice information | `@Ch_id`, `@NewQ_id`, `@NewChoiceText`, `@NewIsCorrect` |
| `DeleteChoice` | Removes a choice | `@Ch_id` |
| `GetChoices` | Lists all choices | None |
| `GetChoicesByQuestion` | Lists choices for a specific question | `@QuestionID` |
| `GetCorrectChoices` | Lists all correct choices | None |

## Student Grades Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `InsertStudentGrade` | Records a grade for a student | `@StudentID`, `@ExamID`, `@Grade` |
| `UpdateStudentGrade` | Updates a student's grade | `@StudentID`, `@ExamID`, `@NewGrade` |
| `DeleteStudentGrade` | Removes a grade record | `@StudentID`, `@ExamID` |
| `GetStudentGrades` | Lists all grades | None |
| `GetStudentGradesByExam` | Lists grades for a specific exam | `@ExamID` |
| `GetStudentGradesByStudent` | Lists grades for a specific student | `@StudentID` |

## Student Answers Management Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `InsertStudentAnswer` | Records a student's answer | `@StudentID`, `@QuestionID`, `@ExamID`, `@SelectedChoiceID` |
| `UpdateStudentAnswer` | Updates a student's answer | `@StudentID`, `@QuestionID`, `@ExamID`, `@NewSelectedChoiceID` |
| `DeleteStudentAnswer` | Removes an answer record | `@StudentID`, `@QuestionID`, `@ExamID` |
| `GetStudentAnswers` | Lists all student answers | None |
| `GetStudentAnswersByExam` | Lists answers for a specific exam | `@StudentID`, `@ExamID` |
| `GetCorrectStudentAnswers` | Lists correct answers for a student | `@StudentID`, `@ExamID` |

## Advanced Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| `GenerateExam` | Automatically generates an exam from a question bank | `@ExamName`, `@CourseID`, `@NumMCQ`, `@NumTF` |
| `SubmitExamAnswers` | Processes student exam submissions | `@StudentID`, `@ExamID`, `@Answers` (table type) |
| `ExamCorrection` | Automatically grades an exam | `@ExamID`, `@StudentID` |

## Usage Examples

### Creating a New User and Student

```sql
-- Add a new user
EXEC InsertUser 
    @UserID = 5, 
    @UserName = 'Ahmed Ali', 
    @Email = 'ahmed@example.com', 
    @Password = 'securePassword123', 
    @UserType = 'Student';

-- Register the user as a student
EXEC InsertStudent @UserID = 5;
```

### Creating a Course and Enrolling Students

```sql
-- Create a new course
EXEC sp_InsertCourse 
    @Course_id = 103, 
    @Crs_name = 'Advanced Programming', 
    @Ins_id = 3;

-- Enroll a student in the course
EXEC sp_EnrollStudentInCourse 
    @StudentID = 1, 
    @CourseID = 103;
```

### Creating an Exam with Questions and Choices

```sql
-- Create a new exam
EXEC sp_InsertExam 
    @Exam_id = 203, 
    @Exam_name = 'Midterm Exam', 
    @Crs_id = 103;

-- Add a question to the exam
EXEC InsertQuestion 
    @Q_id = 303, 
    @Exam_id = 203, 
    @Q_text = 'What is inheritance in OOP?', 
    @Q_type = 'MCQ';

-- Add choices to the question
EXEC InsertChoice 
    @Ch_id = 405, 
    @Q_id = 303, 
    @ChoiceText = 'A mechanism where a class inherits properties and behaviors from another class', 
    @IsCorrect = 1;

EXEC InsertChoice 
    @Ch_id = 406, 
    @Q_id = 303, 
    @ChoiceText = 'A way to create multiple instances of a class', 
    @IsCorrect = 0;
```

### Submitting and Grading an Exam

```sql
-- First, declare a variable of the AnswerTableType
DECLARE @StudentAnswers AS AnswerTableType;

-- Insert answers into the table variable
INSERT INTO @StudentAnswers (QuestionID, SelectedChoiceID)
VALUES (303, 405);

-- Submit the answers
EXEC SubmitExamAnswers 
    @StudentID = 1, 
    @ExamID = 203, 
    @Answers = @StudentAnswers;

-- The exam is automatically graded by the SubmitExamAnswers procedure
-- But you can also manually grade it
EXEC ExamCorrection 
    @ExamID = 203, 
    @StudentID = 1;
```

### Generating an Exam Automatically

```sql
-- Generate an exam with 5 MCQ and 3 True/False questions
EXEC GenerateExam 
    @ExamName = 'Auto-Generated Quiz', 
    @CourseID = 103, 
    @NumMCQ = 5, 
    @NumTF = 3;
``` 