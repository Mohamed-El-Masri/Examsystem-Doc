# Online Exam System - User Guide

## Introduction

Welcome to the Online Exam System! This comprehensive platform is designed to streamline the examination process for educational institutions. This guide will help you navigate the system based on your role as either a student or an instructor.

![Database Diagram](db%20daigram.png)

## Getting Started

### System Access

1. **Login**: Access the system using your provided credentials
   - Username: Your registered email address
   - Password: Your secure password

2. **User Types**:
   - **Student**: Access to course enrollment, exam taking, and grade viewing
   - **Instructor**: Access to course management, exam creation, and student performance monitoring

### Navigation

The system provides an intuitive interface with the following main sections:
- Dashboard
- Courses
- Exams
- Grades
- Profile

## For Students

### Course Enrollment

1. Navigate to the "Courses" section
2. Browse available courses
3. Click "Enroll" for courses you wish to join
4. Enrolled courses will appear in your dashboard

### Taking Exams

1. From your dashboard, select a course
2. Navigate to the "Exams" tab
3. Available exams will be listed with their status (upcoming, available, completed)
4. Click on an available exam to begin

### Exam Interface

![ER Diagram](erd.jpg)

When taking an exam:
1. Read each question carefully
2. Select your answer from the provided choices
3. Use the navigation buttons to move between questions
4. Submit your exam when complete
5. Confirm submission when prompted

### Viewing Grades

1. Navigate to the "Grades" section
2. View your grades by course or by exam
3. Detailed breakdowns show your performance on individual questions
4. Compare your performance to class averages (if enabled by instructor)

## For Instructors

### Department and Course Management

1. Navigate to the "Departments" section to view or manage your department
2. Access the "Courses" section to:
   - Create new courses
   - Modify existing courses
   - View enrolled students

### Creating Exams

1. Select a course from your dashboard
2. Navigate to the "Exams" tab
3. Click "Create New Exam"
4. Provide exam details:
   - Name
   - Description
   - Time limit (optional)
   - Availability window

### Adding Questions

![Mapping Diagram](mapping.jpg)

1. From the exam creation page, click "Add Questions"
2. Choose question type:
   - Multiple Choice (MCQ)
   - True/False
3. Enter question text
4. For MCQ questions:
   - Add multiple answer choices
   - Mark the correct answer(s)
5. For True/False questions:
   - Select the correct answer

### Exam Generation

For quick exam creation:
1. Click "Generate Exam"
2. Select the course
3. Specify the number of questions by type
4. The system will automatically create an exam from the question bank

### Reviewing Student Performance

1. Navigate to the "Grades" section
2. View grades by:
   - Course
   - Exam
   - Student
3. Access detailed analytics:
   - Average scores
   - Question difficulty
   - Performance trends

## System Features

### Automatic Grading

The system automatically grades objective questions (MCQ, True/False) upon exam submission:
1. Correct answers are compared to student selections
2. Points are awarded for correct answers
3. Final grade is calculated as a percentage
4. Results are immediately available to students (if enabled)

### Question Bank

The system maintains a question bank for each course:
1. Questions are categorized by type and topic
2. Instructors can reuse questions across exams
3. Questions can be modified or updated as needed

### Performance Analytics

Both students and instructors have access to performance analytics:
1. Students can track their progress across courses
2. Instructors can identify:
   - Challenging topics
   - High-performing students
   - Areas for curriculum improvement

## Best Practices

### For Students

1. **Regular Access**: Check the system regularly for new exams and announcements
2. **Time Management**: Note exam availability windows and allocate sufficient time
3. **Technical Preparation**: Ensure stable internet connection before starting exams
4. **Academic Integrity**: Adhere to institutional policies regarding exam taking

### For Instructors

1. **Question Variety**: Include different question types to assess various skills
2. **Clear Instructions**: Provide clear exam instructions and expectations
3. **Regular Updates**: Keep course materials and question banks current
4. **Performance Review**: Regularly review student performance to identify improvement areas

## Troubleshooting

### Common Issues

1. **Login Problems**:
   - Verify your credentials
   - Use the "Forgot Password" feature if needed
   - Contact system administrator for account issues

2. **Exam Access Issues**:
   - Confirm the exam is within its availability window
   - Verify course enrollment
   - Check for any prerequisites

3. **Submission Errors**:
   - Save answers regularly during the exam
   - If disconnected, reconnect and continue where you left off
   - Contact support if unable to submit

### Getting Help

For additional assistance:
- Use the in-system help feature
- Contact your institution's technical support
- Refer to this user guide for reference

## Conclusion

The Online Exam System is designed to provide a seamless examination experience for both students and instructors. By following this guide, you'll be able to effectively utilize the system's features to enhance the teaching and learning process.

For technical details about the system's architecture and implementation, please refer to the Technical Documentation. 