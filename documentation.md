# Online Exam System Documentation

## Introduction

The Online Exam System is a comprehensive solution designed to manage educational institutions' examination processes. The system facilitates the management of users (students and instructors), departments, courses, exams, questions, and student responses. It provides a complete workflow from course enrollment to exam generation, submission, and automatic grading.

## Download Resources

You can download the following resources to implement the system:

- [Download SQL Queries (OnlineExam_Complete.sql)](OnlineExam_Complete.sql)
- [Download Database Backup (online.bak)](online.bak)

## Database Schema

The system is built on a relational database with the following tables:

### Core Tables

1. **Users** - Stores information about all users in the system
   - UserID (PK)
   - Name
   - Email
   - UserType (Student/Instructor)
   - Password

2. **Students** - Stores student-specific information
   - UserID (PK, FK to Users)

3. **Departments** - Stores academic departments
   - DepartmentID (PK)
   - Name

4. **Instructors** - Stores instructor-specific information
   - UserID (PK, FK to Users)
   - DepartmentID (FK to Departments)

5. **Courses** - Stores course information
   - Course_id (PK)
   - Crs_name
   - Ins_id (FK to Instructors)

6. **Student_Course** - Maps students to courses (many-to-many relationship)
   - Crs_id (PK, FK to Courses)
   - Std_id (PK, FK to Students)

### Exam-Related Tables

7. **Exam** - Stores exam information
   - Exam_id (PK)
   - Exme_name
   - Crs_id (FK to Courses)

8. **Questions** - Stores exam questions
   - Q_id (PK)
   - Exam_id (FK to Exam)
   - Q_text
   - Q_type (MCQ/True/False)

9. **Choice** - Stores answer choices for questions
   - Ch_id (PK)
   - Q_id (FK to Questions)
   - ChoiceText
   - IsCorrect

10. **Student_Answers** - Records student responses to exam questions
    - StudentID (PK, FK to Students)
    - QuestionID (PK, FK to Questions)
    - ExamID (PK, FK to Exam)
    - SelectedChoiceID (FK to Choice)

11. **Student_Grades** - Stores student grades for exams
    - StudentID (PK, FK to Students)
    - ExamID (PK, FK to Exam)
    - Grade

## Entity Relationship Diagrams

The system's database structure is represented in the following diagrams:

### ER Diagram
![ER Diagram](erd.jpg)

### Mapping Diagram
![Mapping Diagram](mapping.jpg)

### Database Diagram
![Database Diagram](db%20daigram.png)

## System Components

### User Management
- User registration and authentication
- Role-based access control (Student/Instructor)
- Profile management

### Department Management
- Department creation and management
- Assignment of instructors to departments

### Course Management
- Course creation and management
- Assignment of instructors to courses
- Student enrollment in courses

### Exam Management
- Exam creation and configuration
- Question bank management
- Automatic and manual exam generation
- Multiple question types support (MCQ, True/False)

### Exam Taking
- Secure exam delivery to students
- Answer submission and validation
- Time management for exams

### Grading System
- Automatic grading of objective questions
- Grade calculation and recording
- Performance analytics

## Stored Procedures

The system implements numerous stored procedures to handle various operations:

### User Management Procedures
- `InsertUser` - Adds a new user to the system
- `UpdateUser` - Updates user information
- `DeleteUser` - Removes a user from the system
- `GetUser` - Retrieves user information

### Student Management Procedures
- `InsertStudent` - Registers a new student
- `DeleteStudent` - Removes a student
- `UpdateStudent` - Updates student information
- `GetStudent` - Retrieves student information
- `GetAllStudents` - Lists all students

### Department Management Procedures
- `InsertDepartment` - Creates a new department
- `UpdateDepartment` - Updates department information
- `DeleteDepartment` - Removes a department
- `GetDepartment` - Retrieves department information
- `GetAllDepartments` - Lists all departments

### Instructor Management Procedures
- `sp_InsertInstructor` - Assigns an instructor to a department
- `sp_UpdateInstructor` - Updates instructor information
- `sp_DeleteInstructor` - Removes an instructor
- `sp_GetInstructor` - Retrieves instructor information
- `sp_GetAllInstructors` - Lists all instructors

### Course Management Procedures
- `sp_InsertCourse` - Creates a new course
- `sp_UpdateCourse` - Updates course information
- `sp_DeleteCourse` - Removes a course
- `sp_GetCourse` - Retrieves course information
- `sp_GetAllCourses` - Lists all courses
- `sp_EnrollStudentInCourse` - Enrolls a student in a course
- `sp_UnenrollStudentFromCourse` - Removes a student from a course

### Exam Management Procedures
- `sp_InsertExam` - Creates a new exam
- `sp_UpdateExam` - Updates exam information
- `sp_DeleteExam` - Removes an exam
- `sp_GetExam` - Retrieves exam information
- `sp_GetExamsByCourse` - Lists exams for a specific course
- `sp_GetAllExams` - Lists all exams

### Question Management Procedures
- `InsertQuestion` - Adds a question to an exam
- `UpdateQuestion` - Updates question information
- `DeleteQuestion` - Removes a question
- `GetQuestions` - Lists all questions
- `GetQuestionsByExam` - Lists questions for a specific exam
- `GetQuestionsByType` - Lists questions of a specific type

### Choice Management Procedures
- `InsertChoice` - Adds an answer choice to a question
- `UpdateChoice` - Updates choice information
- `DeleteChoice` - Removes a choice
- `GetChoices` - Lists all choices
- `GetChoicesByQuestion` - Lists choices for a specific question
- `GetCorrectChoices` - Lists all correct choices

### Student Grades Management Procedures
- `InsertStudentGrade` - Records a grade for a student
- `UpdateStudentGrade` - Updates a student's grade
- `DeleteStudentGrade` - Removes a grade record
- `GetStudentGrades` - Lists all grades
- `GetStudentGradesByExam` - Lists grades for a specific exam
- `GetStudentGradesByStudent` - Lists grades for a specific student

### Student Answers Management Procedures
- `InsertStudentAnswer` - Records a student's answer
- `UpdateStudentAnswer` - Updates a student's answer
- `DeleteStudentAnswer` - Removes an answer record
- `GetStudentAnswers` - Lists all student answers
- `GetStudentAnswersByExam` - Lists answers for a specific exam
- `GetCorrectStudentAnswers` - Lists correct answers for a student

### Advanced Procedures
- `GenerateExam` - Automatically generates an exam from a question bank
- `SubmitExamAnswers` - Processes student exam submissions
- `ExamCorrection` - Automatically grades an exam

## System Workflows

### Instructor Workflow
1. Instructor logs into the system
2. Creates/manages courses
3. Creates exams for courses
4. Adds questions and answer choices to exams
5. Reviews student performance and grades

### Student Workflow
1. Student logs into the system
2. Enrolls in courses
3. Takes available exams
4. Submits answers
5. Reviews grades and performance

### Exam Creation Workflow
1. Instructor creates a new exam for a course
2. Adds questions manually or generates from question bank
3. Configures exam settings
4. Makes exam available to enrolled students

### Exam Taking Workflow
1. Student selects an available exam
2. System presents questions one by one or all at once
3. Student submits answers
4. System automatically grades objective questions
5. System records grades and provides feedback

## Technical Implementation

The system is implemented using:
- SQL Server for database management
- Stored procedures for business logic
- Identity columns for automatic ID generation
- Foreign key constraints for data integrity
- User-defined table types for complex data operations
- Transaction management for data consistency

The database schema includes both a basic version and an enhanced version with identity columns for automatic ID generation. The system supports various operations through a comprehensive set of stored procedures that handle everything from basic CRUD operations to complex workflows like exam generation and automatic grading.

## Implementation Guide

To implement the Online Exam System in your environment:

### Using the SQL Script
1. Download the [OnlineExam_Complete.sql](OnlineExam_Complete.sql) file
2. Open SQL Server Management Studio
3. Connect to your SQL Server instance
4. Create a new database named "OnlineExam" (or your preferred name)
5. Open the downloaded SQL script
6. Execute the script to create all tables, constraints, and stored procedures

### Using the Database Backup
1. Download the [online.bak](online.bak) file
2. Open SQL Server Management Studio
3. Connect to your SQL Server instance
4. Right-click on "Databases" and select "Restore Database..."
5. Select "Device" as the source and browse to the downloaded .bak file
6. Specify the database name and click "OK" to restore

### Next Steps
1. Develop a user interface (web or desktop application)
2. Implement authentication and authorization
3. Connect your application to the database
4. Test the system with sample data 