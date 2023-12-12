
DROP TABLE IF EXISTS "Assignment" CASCADE;
DROP TABLE IF EXISTS "Resource" CASCADE;
DROP TABLE IF EXISTS "Session" CASCADE;
DROP TABLE IF EXISTS "Parent" CASCADE;
DROP TABLE IF EXISTS "Tutor" CASCADE;
DROP TABLE IF EXISTS "Student" CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;

-- Drop sequences
DROP SEQUENCE IF EXISTS "user_seq" CASCADE;
DROP SEQUENCE IF EXISTS "student_seq" CASCADE;
DROP SEQUENCE IF EXISTS "tutor_seq" CASCADE;
DROP SEQUENCE IF EXISTS "parent_seq" CASCADE;
DROP SEQUENCE IF EXISTS "assignment_seq" CASCADE;
DROP SEQUENCE IF EXISTS "session_seq" CASCADE;
DROP SEQUENCE IF EXISTS "resource_seq" CASCADE;
DROP SEQUENCE IF EXISTS "reports_seq" CASCADE;
DROP SEQUENCE IF EXISTS "milestones_seq" CASCADE;
DROP SEQUENCE IF EXISTS "uac_seq" CASCADE;
DROP SEQUENCE IF EXISTS "address_seq" CASCADE;
DROP SEQUENCE IF EXISTS "contact_seq" CASCADE;
DROP SEQUENCE IF EXISTS "feedback_seq" CASCADE;
DROP SEQUENCE IF EXISTS "goal_seq" CASCADE;
DROP SEQUENCE IF EXISTS "bookmark_seq" CASCADE;
DROP SEQUENCE IF EXISTS "dashboard_seq" CASCADE;
DROP SEQUENCE IF EXISTS "achievement_seq" CASCADE;
DROP SEQUENCE IF EXISTS "recommendation_seq" CASCADE;

-- "User" Table
CREATE TABLE "User" (
    userID DECIMAL(12) PRIMARY KEY,
    username VARCHAR(100),
    password VARCHAR(100),
    userType VARCHAR(50)
);

-- Student Subtype
CREATE TABLE "Student" (
    userID DECIMAL(12) PRIMARY KEY REFERENCES "User"(userID) ON DELETE CASCADE,
    grade VARCHAR(50),
    coursesEnrolled TEXT
);

-- Tutor Subtype
CREATE TABLE "Tutor" (
    userID DECIMAL(12) PRIMARY KEY REFERENCES "User"(userID) ON DELETE CASCADE,
    subjectsTaught TEXT,
    yearsOfExperience INT
);

-- Parent Subtype
CREATE TABLE "Parent" (
    userID DECIMAL(12) PRIMARY KEY REFERENCES "User"(userID) ON DELETE CASCADE,
    relationshipToStudent VARCHAR(50)
);



-- Assignment Table 
CREATE TABLE "Assignment" (
    assignmentID DECIMAL(12) PRIMARY KEY,
    tutorID DECIMAL(12) REFERENCES "Tutor"(userID) ON DELETE CASCADE

);

-- Session Table
CREATE TABLE "Session" (
    sessionID DECIMAL(12) PRIMARY KEY,
    tutorID DECIMAL(12) REFERENCES "User"(userID) ON DELETE CASCADE,
    studentID DECIMAL(12) REFERENCES "User"(userID) ON DELETE CASCADE,
    assignmentID DECIMAL(12) REFERENCES "Assignment"(assignmentID) ON DELETE CASCADE, 
    sessionStartTime TIMESTAMP,
    sessionEndTime TIMESTAMP,
    sessionTopic VARCHAR(255)
);



-- Resource Table
CREATE TABLE "Resource" (
    resourceID DECIMAL(12) PRIMARY KEY,
    sessionID DECIMAL(12) References "Session"(SessionId) ON DELETE CASCADE
);

-- UserAddressContact Table
DROP TABLE IF EXISTS "UserAddressContact" CASCADE;
CREATE TABLE "UserAddressContact" (
    UAC_ID DECIMAL(12) PRIMARY KEY,
    UserID DECIMAL(12) REFERENCES "User"(userID) ON DELETE CASCADE
);

-- Address Table
DROP TABLE IF EXISTS "Address" CASCADE;
CREATE TABLE "Address" (
    AddressID DECIMAL(12) PRIMARY KEY,
    UserAddressContactID DECIMAL(12) REFERENCES "UserAddressContact"(UAC_ID) ON DELETE CASCADE,
    AddressLine1 VARCHAR(255),
    AddressLine2 VARCHAR(255),
    ZipCode VARCHAR(10),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255)
);

-- StudentAddress Table
DROP TABLE IF EXISTS "StudentAddress" CASCADE;
CREATE TABLE "StudentAddress" (
    AddressID DECIMAL(12) PRIMARY KEY REFERENCES "Address"(AddressID) ON DELETE CASCADE,
    StudentID DECIMAL(12) REFERENCES "Student"(userID) ON DELETE CASCADE
);

-- TutorAddress Table
DROP TABLE IF EXISTS "TutorAddress" CASCADE;
CREATE TABLE "TutorAddress" (
    AddressID DECIMAL(12) PRIMARY KEY REFERENCES "Address"(AddressID) ON DELETE CASCADE,
    TutorID DECIMAL(12) REFERENCES "Tutor"(userID) ON DELETE CASCADE
);

-- ParentAddress Table
DROP TABLE IF EXISTS "ParentAddress" CASCADE;
CREATE TABLE "ParentAddress" (
    AddressID DECIMAL(12) PRIMARY KEY REFERENCES "Address"(AddressID) ON DELETE CASCADE,
    ParentID DECIMAL(12) REFERENCES "Parent"(userID) ON DELETE CASCADE
);

-- Contact Table
DROP TABLE IF EXISTS "Contact" CASCADE;
CREATE TABLE "Contact" (
    UAC_ID DECIMAL(12) PRIMARY KEY REFERENCES "UserAddressContact"(UAC_ID) ON DELETE CASCADE,
    UserID DECIMAL(12) REFERENCES "User"(userID) ON DELETE CASCADE,
    Email VARCHAR(255),
    PhoneNumber DECIMAL(10)
);



-- PDF Subtype
DROP TABLE IF EXISTS "PDF" CASCADE;
CREATE TABLE "PDF" (
    resourceID DECIMAL(12) PRIMARY KEY REFERENCES "Resource"(resourceID) ON DELETE CASCADE,
    FilePath VARCHAR(255)
);

-- Video Subtype
DROP TABLE IF EXISTS "Video" CASCADE;
CREATE TABLE "Video" (
    resourceID DECIMAL(12) PRIMARY KEY REFERENCES "Resource"(resourceID) ON DELETE CASCADE,
    VideoURL VARCHAR(255),
    Duration TIME
);

-- Quiz Subtype
DROP TABLE IF EXISTS "Quiz" CASCADE;
CREATE TABLE "Quiz" (
    resourceID DECIMAL(12) PRIMARY KEY REFERENCES "Resource"(resourceID) ON DELETE CASCADE,
    NumberOfQuestions INT,
    PassMark DECIMAL
);



-- Homework Subtype
DROP TABLE IF EXISTS "Homework" CASCADE;
CREATE TABLE "Homework" (
    assignmentID DECIMAL(12) PRIMARY KEY REFERENCES "Assignment"(assignmentID) ON DELETE CASCADE,
    DueDate DATE
);

-- Project Subtype
DROP TABLE IF EXISTS "Project" CASCADE;
CREATE TABLE "Project" (
    assignmentID DECIMAL(12) PRIMARY KEY REFERENCES "Assignment"(assignmentID) ON DELETE CASCADE,
    DueDate DATE
);

-- Reports Table
DROP TABLE IF EXISTS "Reports" CASCADE;
CREATE TABLE "Reports" (
    reportID DECIMAL(12) PRIMARY KEY,
    parentID DECIMAL(12) REFERENCES "Parent"(userID) ON DELETE CASCADE,
    studentID DECIMAL(12) REFERENCES "Student"(userID) ON DELETE CASCADE,
    content TEXT,
    DateIssued DATE
);

-- Milestones Table
DROP TABLE IF EXISTS "Milestones" CASCADE;
CREATE TABLE "Milestones" (
    milestoneID DECIMAL(12) PRIMARY KEY,
    studentID DECIMAL(12) REFERENCES "Student"(userID) ON DELETE CASCADE,
    description TEXT,
    DateAchieved DATE
);

-- Feedback Table
DROP TABLE IF EXISTS "Feedback" CASCADE;
CREATE TABLE "Feedback" (
    FeedbackID DECIMAL(12) PRIMARY KEY,
    UserID DECIMAL(12) REFERENCES "User"(userID) ON DELETE CASCADE,
    SessionID DECIMAL(12) REFERENCES "Session"(sessionID) ON DELETE CASCADE,
    Content TEXT,
    DateGiven DATE
);

-- Goal Table
DROP TABLE IF EXISTS "Goal" CASCADE;
CREATE TABLE "Goal" (
    GoalID DECIMAL(12) PRIMARY KEY,
    StudentID DECIMAL(12) REFERENCES "Student"(userID) ON DELETE CASCADE,
    Description VARCHAR(255),
    Deadline DATE
);

-- Bookmark Table
DROP TABLE IF EXISTS "Bookmark" CASCADE;
CREATE TABLE "Bookmark" (
    BookmarkID DECIMAL(12) PRIMARY KEY,
    StudentID DECIMAL(12) REFERENCES "Student"(userID) ON DELETE CASCADE,
    ResourceID DECIMAL(12) REFERENCES "Resource"(resourceID) ON DELETE SET NULL,
    SessionID DECIMAL(12) REFERENCES "Session"(sessionID) ON DELETE SET NULL
);

-- Dashboard Table
DROP TABLE IF EXISTS "Dashboard" CASCADE;
CREATE TABLE "Dashboard" (
    DashboardID DECIMAL(12) PRIMARY KEY,
    UserID DECIMAL(12) REFERENCES "User"(userID) ON DELETE CASCADE,
    LastAccessed TIMESTAMP
);

-- Achievement Table
DROP TABLE IF EXISTS "Achievement" CASCADE;
CREATE TABLE "Achievement" (
    AchievementID DECIMAL(12) PRIMARY KEY,
    StudentID DECIMAL(12) REFERENCES "Student"(userID) ON DELETE CASCADE,
    Description VARCHAR(255),
    DateUnlocked DATE
);

-- Recommendation Table
DROP TABLE IF EXISTS "Recommendation" CASCADE;
CREATE TABLE "Recommendation" (
    RecommendationID DECIMAL(12) PRIMARY KEY,
    TutorID DECIMAL(12) REFERENCES "Tutor"(userID) ON DELETE CASCADE,
    StudentID DECIMAL(12) REFERENCES "Student"(userID) ON DELETE CASCADE,
    ResourceID DECIMAL(12) REFERENCES "Resource"(resourceID) ON DELETE SET NULL,
    Content TEXT,
    DateGiven DATE
);


-- Create sequences
CREATE SEQUENCE "user_seq" START WITH 1;
CREATE SEQUENCE "student_seq" START WITH 1;
CREATE SEQUENCE "tutor_seq" START WITH 1;
CREATE SEQUENCE "parent_seq" START WITH 1;
CREATE SEQUENCE "assignment_seq" START WITH 1;
CREATE SEQUENCE "session_seq" START WITH 1;
CREATE SEQUENCE "resource_seq" START WITH 1;
CREATE SEQUENCE "reports_seq" START WITH 1;
CREATE SEQUENCE "milestones_seq" START WITH 1;
CREATE SEQUENCE "uac_seq" START WITH 1;
CREATE SEQUENCE "address_seq" START WITH 1;
CREATE SEQUENCE "contact_seq" START WITH 1;
CREATE SEQUENCE "feedback_seq" START WITH 1;
CREATE SEQUENCE "goal_seq" START WITH 1;
CREATE SEQUENCE "bookmark_seq" START WITH 1;
CREATE SEQUENCE "dashboard_seq" START WITH 1;
CREATE SEQUENCE "achievement_seq" START WITH 1;
CREATE SEQUENCE "recommendation_seq" START WITH 1;




--Stored Procedure Execution and Explanations:Add Student with Address
CREATE OR REPLACE PROCEDURE AddStudentWithAddress(
    p_userID IN DECIMAL,
    p_username IN VARCHAR,
    p_password IN VARCHAR,
    p_grade IN VARCHAR,
    p_coursesEnrolled IN TEXT,
    p_AddressLine1 IN VARCHAR,
    p_AddressLine2 IN VARCHAR,
    p_ZipCode IN VARCHAR,
    p_City IN VARCHAR,
    p_State IN VARCHAR,
    p_Country IN VARCHAR
)
AS
$proc$
BEGIN
    -- Add User
    INSERT INTO "User"(userID, username, password, userType)
    VALUES (p_userID, p_username, p_password, 'Student');
    
    -- Add Student
    INSERT INTO "Student"(userID, grade, coursesEnrolled)
    VALUES (p_userID, p_grade, p_coursesEnrolled);
    
    -- Add Address
    INSERT INTO "Address"(AddressID, AddressLine1, AddressLine2, ZipCode, City, State, Country)
    VALUES (NEXTVAL('address_seq'), p_AddressLine1, p_AddressLine2, p_ZipCode, p_City, p_State, p_Country);
    
    -- Link Address to Student
    INSERT INTO "StudentAddress"(AddressID, StudentID)
    VALUES (CURRVAL('address_seq'), p_userID);
END;
$proc$ LANGUAGE plpgsql;


BEGIN; -- START TRANSACTION;
DO
$$BEGIN
    CALL AddStudentWithAddress(123456789012, 'JohnDoe', 'password123', '10th Grade', 
							   'Math, Science', '5th Avenue', 'Apt 12A', '10001', 'New York', 'New York', 'USA');
END$$;
COMMIT; -- COMMIT TRANSACTION;


--Stored Procedure Execution and Explanations: Assign a Session to a Student
CREATE OR REPLACE PROCEDURE AssignSessionToStudent(
    p_sessionID IN DECIMAL,
    p_tutorID IN DECIMAL,
    p_studentID IN DECIMAL,
    p_sessionStartTime IN TIMESTAMP,
    p_sessionEndTime IN TIMESTAMP,
    p_sessionTopic IN VARCHAR
)
AS
$proc$
BEGIN
    -- Add Session
    INSERT INTO "Session"(sessionID, tutorID, studentID, sessionStartTime, sessionEndTime, sessionTopic)
    VALUES (p_sessionID, p_tutorID, p_studentID,p_sessionStartTime, p_sessionEndTime, p_sessionTopic);
END;
$proc$ LANGUAGE plpgsql;

-- Users
INSERT INTO "User" VALUES(1, 'JohnDoe', 'password123', 'Student');
INSERT INTO "User" VALUES(2, 'JaneTutor', 'password456', 'Tutor');
INSERT INTO "User" VALUES(3, 'RobertParent', 'password789', 'Parent');


-- Student
INSERT INTO "Student" VALUES(1, 'Grade 10', 'Math, English');


-- Tutor
INSERT INTO "Tutor" VALUES(2, 'Math, Physics', 5);


-- UserAddressContact 
INSERT INTO "UserAddressContact" (UAC_ID, UserID) VALUES
(1, 1),
(2, 2);

-- Parent
INSERT INTO "Parent" VALUES(3, 'Father');

-- Assignment
INSERT INTO "Assignment" VALUES(1, 2);

-- Session
INSERT INTO "Session" VALUES(1, 2, 1, 1, '2023-10-10 10:00:00', '2023-10-10 11:00:00', 'Math');
INSERT INTO "Session" (sessionID, tutorID, studentID,sessionStartTime, sessionEndTime, sessionTopic) VALUES
(2, 3, 1, '2023-10-02 10:00:00', '2023-10-02 11:00:00', 'Science');


-- Resource
INSERT INTO "Resource" VALUES(1, 1);

-- PDF
INSERT INTO "PDF" VALUES(1, '/path/to/algebra101.pdf');


-- Feedback
INSERT INTO "Feedback" VALUES(1, 3, 1, 'Great session. My child understood everything.', '2023-10-10');

-- Recommendation
INSERT INTO "Recommendation" VALUES(1, 2, 1, 1, 'This PDF is very helpful for beginners.', '2023-10-11');


--  Contacts 
INSERT INTO "Contact" (UAC_ID, UserID, Email, PhoneNumber) VALUES
(1, 1, 'studentA@example.com', 1234567890),
(2, 2, 'studentB@example.com', 2345678901);



--This Query Answer:Which tutors teaching a specific subject have received feedback, and who are the students involved in those sessions?
SELECT
    t.userID AS TutorID,
    u.username AS TutorName,
    t.subjectsTaught,
    s.studentID AS StudentID,
    f.Content AS FeedbackContent
FROM
    "Tutor" t
JOIN "User" u ON t.userID = u.userID
JOIN "Session" s ON t.userID = s.tutorID
JOIN "Feedback" f ON s.sessionID = f.SessionID
WHERE
    t.subjectsTaught LIKE '%Math%';

--This query Answer:For a specific course, who are the enrolled students and their associated tutors' contact details?
SELECT
    st.userID AS StudentID,
    u.username AS StudentName,
    s.tutorID AS TutorID,
    u2.username AS TutorName,
    c.Email AS TutorEmail,
    c.PhoneNumber AS TutorPhoneNumber
FROM
    "Student" st
JOIN "User" u ON st.userID = u.userID
JOIN "Session" s ON st.userID = s.studentID
JOIN "Tutor" t ON s.tutorID = t.userID
JOIN "User" u2 ON t.userID = u2.userID
JOIN "Contact" c ON t.userID = c.UserID
WHERE
    st.coursesEnrolled LIKE '%Math%';

--This Question Answer:Which resources are frequently recommended by tutors?
CREATE VIEW "RecommendedResourcesView" AS
SELECT
    t.userID AS TutorID,
    r.RecommendationID,
    re.resourceID AS ResourceID,
    CASE 
        WHEN p.resourceID IS NOT NULL THEN 'PDF'
        WHEN v.resourceID IS NOT NULL THEN 'Video'
        WHEN q.resourceID IS NOT NULL THEN 'Quiz'
    END AS ResourceType
FROM
    "Tutor" t
JOIN "Recommendation" r ON t.userID = r.TutorID
JOIN "Resource" re ON r.ResourceID = re.resourceID
LEFT JOIN "PDF" p ON re.resourceID = p.resourceID
LEFT JOIN "Video" v ON re.resourceID = v.resourceID
LEFT JOIN "Quiz" q ON re.resourceID = q.resourceID;


SELECT
    ResourceID,
    ResourceType,
    COUNT(RecommendationID) AS RecommendationCount
FROM
    "RecommendedResourcesView"
GROUP BY
    ResourceID, ResourceType
ORDER BY
    RecommendationCount DESC;
	
--Indexs
CREATE INDEX idx_session_tutor ON "Session" (tutorID);
CREATE INDEX idx_session_student ON "Session" (studentID);
CREATE INDEX idx_assignment_tutor ON "Assignment" (tutorID);
CREATE INDEX idx_resource_session ON "Resource" (sessionID);
CREATE INDEX idx_uac_user ON "UserAddressContact" (UserID);
CREATE INDEX idx_address_uac ON "Address" (UserAddressContactID);
CREATE INDEX idx_studaddress_student ON "StudentAddress" (StudentID);
CREATE INDEX idx_tutoraddress_tutor ON "TutorAddress" (TutorID);
CREATE INDEX idx_parentaddress_parent ON "ParentAddress" (ParentID);
CREATE INDEX idx_contact_user ON "Contact" (UserID);
CREATE INDEX idx_reports_parent ON "Reports" (parentID);
CREATE INDEX idx_reports_student ON "Reports" (studentID);
CREATE INDEX idx_milestones_student ON "Milestones" (studentID);
CREATE INDEX idx_feedback_user ON "Feedback" (UserID);
CREATE INDEX idx_feedback_session ON "Feedback" (SessionID);
CREATE INDEX idx_goal_student ON "Goal" (StudentID);
CREATE INDEX idx_bookmark_student ON "Bookmark" (StudentID);
CREATE INDEX idx_bookmark_resource ON "Bookmark" (ResourceID);
CREATE INDEX idx_bookmark_session ON "Bookmark" (SessionID);
CREATE INDEX idx_dashboard_user ON "Dashboard" (UserID);
CREATE INDEX idx_recommendation_tutor ON "Recommendation" (TutorID);
CREATE INDEX idx_recommendation_student ON "Recommendation" (StudentID);
CREATE INDEX idx_recommendation_resource ON "Recommendation" (ResourceID);	

-- Inserting into "User" for tutor, student, and parent
INSERT INTO "User" (userID, username, password, userType) VALUES (101, 'TutorAlice', 'password101', 'Tutor');
INSERT INTO "User" (userID, username, password, userType) VALUES (201, 'StudentBob', 'password201', 'Student');
INSERT INTO "User" (userID, username, password, userType) VALUES (301, 'ParentCharlie', 'password301', 'Parent');

-- Inserting into subtypes: Tutor, Student, Parent
INSERT INTO "Tutor" (userID, subjectsTaught, yearsOfExperience) VALUES (101, 'Math, Physics', 5);
INSERT INTO "Student" (userID, grade, coursesEnrolled) VALUES (201, 'Grade 10', 'Mathematics, Physics');
INSERT INTO "Parent" (userID, relationshipToStudent) VALUES (301, 'Father');

-- Inserting into "Assignment"
INSERT INTO "Assignment" (assignmentID, tutorID) VALUES (401, 101);

-- Now you can insert into "Session"
INSERT INTO "Session" (sessionID, tutorID, studentID, assignmentID, sessionStartTime, sessionEndTime, sessionTopic)
VALUES (501, 101, 201, 401, '2023-10-14 10:00:00', '2023-10-14 11:00:00', 'Math Basics');


--SessionHistory Table
Drop Table If Exists "SessionHistory" CASCADE;
CREATE TABLE "SessionHistory" (
    historyID DECIMAL(12) PRIMARY KEY,
    sessionID DECIMAL(12) REFERENCES "Session"(sessionID),
    previousStartTime TIMESTAMP,
    newStartTime TIMESTAMP,
    previousEndTime TIMESTAMP,
    newEndTime TIMESTAMP,
    changeTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changedBy DECIMAL(12) REFERENCES "User"(userID)  
);
DROP SEQUENCE IF EXISTS "session_history_seq" CASCADE;
CREATE SEQUENCE "session_history_seq" START WITH 1;


--A trigger to maintain the history table
CREATE OR REPLACE FUNCTION SessionChangeFunction() 
RETURNS TRIGGER LANGUAGE plpgsql 
AS $trigfunc$ 
BEGIN 
    INSERT INTO "SessionHistory"(
        historyID, 
        sessionID, 
        previousStartTime, 
        newStartTime, 
        previousEndTime, 
        newEndTime, 
        changeTimestamp, 
        changedBy
    ) 
    VALUES(
        nextval('"session_history_seq"'), 
        OLD.sessionID, 
        OLD.sessionStartTime, 
        NEW.sessionStartTime, 
        OLD.sessionEndTime, 
        NEW.sessionEndTime, 
        CURRENT_TIMESTAMP,
        NEW.tutorID 
    ); 

    RETURN NEW; 
END; 
$trigfunc$;

CREATE TRIGGER SessionChangeTrigger 
BEFORE UPDATE OF sessionStartTime, sessionEndTime ON "Session" 
FOR EACH ROW 
EXECUTE PROCEDURE SessionChangeFunction();
SELECT * FROM "Session";


UPDATE "Session" 
SET sessionStartTime = '2023-10-14 10:30:00', sessionEndTime = '2023-10-14 11:30:00'
WHERE sessionID = 1;

-- Adding more users
INSERT INTO "User" (userID, username, password, userType) VALUES (102, 'TutorDerek', 'password102', 'Tutor');
INSERT INTO "User" (userID, username, password, userType) VALUES (202, 'StudentEva', 'password202', 'Student');
INSERT INTO "User" (userID, username, password, userType) VALUES (103, 'TutorFiona', 'password103', 'Tutor');
INSERT INTO "User" (userID, username, password, userType) VALUES (203, 'StudentGeorge', 'password203', 'Student');
INSERT INTO "User" (userID, username, password, userType) VALUES (104, 'TutorHarry', 'password104', 'Tutor');

-- Adding more to subtypes
INSERT INTO "Tutor" (userID, subjectsTaught, yearsOfExperience) VALUES (102, 'Chemistry, Biology', 3);
INSERT INTO "Student" (userID, grade, coursesEnrolled) VALUES (202, 'Grade 11', 'Chemistry, Biology');
INSERT INTO "Tutor" (userID, subjectsTaught, yearsOfExperience) VALUES (103, 'English Literature', 6);
INSERT INTO "Student" (userID, grade, coursesEnrolled) VALUES (203, 'Grade 9', 'English Literature');
INSERT INTO "Tutor" (userID, subjectsTaught, yearsOfExperience) VALUES (104, 'History', 4);

-- More Assignments
INSERT INTO "Assignment" (assignmentID, tutorID) VALUES (402, 102);
INSERT INTO "Assignment" (assignmentID, tutorID) VALUES (403, 103);
INSERT INTO "Assignment" (assignmentID, tutorID) VALUES (404, 104);

-- More Sessions
INSERT INTO "Session" (sessionID, tutorID, studentID, assignmentID, sessionStartTime, sessionEndTime, sessionTopic)
VALUES (502, 102, 202, 402, '2023-10-15 10:00:00', '2023-10-15 11:00:00', 'Organic Chemistry Basics');
INSERT INTO "Session" (sessionID, tutorID, studentID, assignmentID, sessionStartTime, sessionEndTime, sessionTopic)
VALUES (503, 103, 203, 403, '2023-10-16 11:00:00', '2023-10-16 12:00:00', 'Shakespearean Literature');
INSERT INTO "Session" (sessionID, tutorID, studentID, assignmentID, sessionStartTime, sessionEndTime, sessionTopic)
VALUES (504, 104, 201, 404, '2023-10-17 13:00:00', '2023-10-17 14:00:00', 'World War I History');
INSERT INTO "Session" (sessionID, tutorID, studentID, assignmentID, sessionStartTime, sessionEndTime, sessionTopic)
VALUES (505, 101, 203, 401, '2023-10-18 09:00:00', '2023-10-18 10:00:00', 'Algebra Concepts');
INSERT INTO "Session" (sessionID, tutorID, studentID, assignmentID, sessionStartTime, sessionEndTime, sessionTopic)
VALUES (506, 102, 201, 402, '2023-10-19 14:00:00', '2023-10-19 15:00:00', 'Introduction to Cells');


SELECT * FROM "Session";

SELECT 
    U.username AS TutorName,
    COUNT(S.sessionID) AS NumberOfSessions
FROM
    "User" U
JOIN
    "Session" S ON U.userID = S.tutorID
WHERE
    U.userType = 'Tutor'
GROUP BY
    U.username
ORDER BY
    NumberOfSessions DESC;

SELECT t.subjectsTaught, COUNT(s.sessionID) AS numberOfSessions
FROM "Tutor" t
JOIN "Session" s ON t.userID = s.tutorID
GROUP BY t.subjectsTaught
ORDER BY numberOfSessions DESC;







