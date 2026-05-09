-- Mock Data Insertion Script for ProjectBuddy
-- cs306

USE ProjectBuddy;

-- Table 1: Users (15 rows) 10 studentts, 3 instructors and 2 admins
INSERT INTO Users (email, password_hash, user_role, is_active, is_banned) VALUES
('amina.kovac@uni.ba', '$2b$12$hash01', 'student', TRUE, FALSE),
('damir.hadzic@uni.ba', '$2b$12$hash02', 'student', TRUE, FALSE),
('lena.markovic@uni.ba', '$2b$12$hash03', 'student', TRUE, FALSE),
('kenan.begovic@uni.ba', '$2b$12$hash04', 'student', TRUE, FALSE),
('sara.zukic@uni.ba', '$2b$12$hash05', 'student', TRUE, FALSE),
('tarik.osmanovic@uni.ba', '$2b$12$hash06', 'student', TRUE, FALSE),
('maja.tahirovic@uni.ba', '$2b$12$hash07', 'student', TRUE, FALSE),
('adnan.colic@uni.ba', '$2b$12$hash08', 'student', TRUE, FALSE),
('nina.selimovic@uni.ba', '$2b$12$hash09', 'student', TRUE, FALSE),
('eldin.fejzic@uni.ba', '$2b$12$hash10', 'student', TRUE, FALSE),
('ana.juric@uni.ba', '$2b$12$hash11', 'instructor', TRUE, FALSE),
('mirza.kahriman@uni.ba', '$2b$12$hash12', 'instructor', TRUE, FALSE),
('lejla.softic@uni.ba', '$2b$12$hash13', 'instructor', TRUE, FALSE),
('admin1@uni.ba', '$2b$12$hash14', 'admin', TRUE, FALSE),
('admin2@uni.ba', '$2b$12$hash15', 'admin', TRUE, FALSE);

-- Table 2: User_profiles (15 rows — one per user)
INSERT INTO User_profiles (user_id, first_name, last_name, department, bio, avatar_url) VALUES
(1,  'Amina',  'Kovač', 'Computer Science', 'Passionate about AI and data science.', NULL),
(2,  'Damir',  'Hadžić',    'Software Engineering', 'Full-stack developer, loves open source.', NULL),
(3,  'Lena', 'Marković',  'Computer Science', 'Interested in UX and mobile development.', NULL),
(4,  'Kenan',  'Begović',   'Information Systems',  'Database enthusiast and backend developer.', NULL),
(5,  'Sara', 'Zukić', 'Computer Science', 'Machine learning researcher.', NULL),
(6,  'Tarik',  'Osmanović', 'Software Engineering', 'DevOps and cloud computing.', NULL),
(7,  'Maja',   'Tahirović', 'Information Systems',  'Data analyst and visualization specialist.', NULL),
(8,  'Adnan',  'Čolić', 'Computer Science', 'Cybersecurity student.', NULL),
(9,  'Nina', 'Selimović', 'Software Engineering', 'Game developer and graphics programmer.',NULL),
(10, 'Eldin',  'Fejzić', 'Computer Science', 'Blockchain and distributed systems.', NULL),
(11, 'Prof. Ana', 'Jurić', 'Computer Science', 'Teaches databases and software architecture.', NULL),
(12, 'Prof. Mirza', 'Kahriman', 'Software Engineering', 'Specializes in agile methods and DevOps.',     NULL),
(13, 'Prof. Lejla', 'Softić',   'Information Systems',  'Data science and machine learning courses.',   NULL),
(14, 'Admin',  'One', NULL, 'Platform administrator.',  NULL),
(15, 'Admin',  'Two', nULL, 'Platform administrator.',  NULL);

-- Table 3: Password_resets (5 rows)
INSERT INTO Password_resets (user_id, token) VALUES
(1,  'tok_a1b2c3d4e5f6'),
(3,  'tok_b2c3d4e5f6a1'),
(5,  'tok_c3d4e5f6a1b2'),
(7,  'tok_d4e5f6a1b2c3'),
(10, 'tok_e5f6a1b2c3d4');

--  Table 4: Projects (12 rows)
INSERT INTO Projects (title, project_description, owner_id, course, team_size, project_status, deadline) VALUES
('AI Crop Disease Detector',    'CNN-based app to detect crop diseases from field photos.', 1, 'Machine Learning', 4, 'in_progress', '2025-06-30'),
('UniChat Platform', 'Real-time chat for university clubs and societies.', 2, 'Distributed Systems', 5, 'open', '2025-07-15'),
('Smart Campus IoT', 'IoT dashboard monitoring energy usage across campus.', 3, 'IoT & Embedded Systems',  4, 'open', '2025-08-01'),
('Course Planner App',  'Drag-and-drop semester planner with prerequisite checks.', 4, 'Software Engineering', 3, 'completed','2025-04-01'),
('Fraud Detection System',  'ML model to detect fraudulent transactions in banking data.',5, 'Machine Learning', 4, 'in_progress', '2025-07-01'),
('Blockchain Voting',  'Secure student council voting on Ethereum.',10,  'Blockchain',  3, 'open',  '2025-09-01'),
('AR Campus Tour', 'Augmented reality guided tour of the university.', 9,  'Mobile Development', 4, 'open','2025-08-15'),
('Student Marketplace', 'Buy/sell second-hand textbooks among students.', 2,  'Web Development', 5, 'completed',   '2025-03-15'),
('Cybersecurity CTF Platform',  'CTF platform for hacking challenges and learning.', 8,  'Cybersecurity', 4, 'in_progress', '2025-07-30'),
('Data Viz Dashboard', 'Interactive analytics dashboard for research data.', 7,  'Data Science', 3, 'open', '2025-08-20'),
('E-Learning Module Builder',   'Drag-and-drop tool for instructors to build lessons.',  11,  'Educational Technology',  5, 'in_progress', '2025-09-15'),
('DevOps Pipeline Toolkit', 'Reusable CI/CD pipeline templates for student projects.',  6,  'DevOps',3, 'completed', '2025-02-28');

-- Table 5: Project_settings (12 rows)
INSERT INTO Project_settings (project_id, is_public, allow_direct_apply, notify_on_application, notify_on_message) VALUES
(1, TRUE, TRUE,TRUE, TRUE),
(2, TRUE, TRUE, TRUE,  FALSE),
(3, TRUE, TRUE, TRUE,  TRUE),
(4, FALSE,FALSE,FALSE, FALSE),
(5, TRUE, TRUE, TRUE,  TRUE),
(6, TRUE, FALSE, TRUE, TRUE),
(7, TRUE, TRUE, FALSE, TRUE),
(8, FALSE,FALSE, FALSE, FALSE),
(9, TRUE, TRUE, TRUE, TRUE),
(10,TRUE, TRUE, TRUE, FALSE),
(11,TRUE, TRUE, TRUE, TRUE),
(12, FALSE,FALSE, FALSE, FALSE);

-- Table 6: Project_tags
INSERT INTO Project_tags (project_id, tag) VALUES
(1,'machine-learning'),(1,'python'),(1,'agriculture'),
(2,'real-time'),(2,'web'),(2,'node.js'),
(3,'iot'),(3,'embedded'),(3,'data'),
(4,'web'),(4,'productivity'),
(5,'machine-learning'),(5,'finance'),(5,'python'),
(6,'blockchain'),(6,'security'),
(7,'mobile'),(7,'ar'),(7,'ux'),
(8,'web'),(8,'e-commerce'),
(9,'cybersecurity'),(9,'hacking'),
(10,'data'),(10,'visualization'),
(11,'education'),(11,'web'),
(12,'devops'),(12,'ci-cd');

-- Table 7: Project_skills
INSERT INTO Project_skills (project_id, skill) VALUES
(1,'Python'),(1,'TensorFlow'),(1,'Computer Vision'),
(2,'Node.js'),(2,'React'),(2,'WebSockets'),
(3,'Arduino'),(3,'MQTT'),(3,'React'),
(4,'React'),(4,'TypeScript'),
(5,'Python'),(5,'Scikit-learn'),(5,'SQL'),
(6,'Solidity'),(6,'Ethereum'),
(7,'Unity'),(7,'ARCore'),(7,'Kotlin'),
(8,'Django'),(8,'PostgreSQL'),
(9,'Python'),(9,'Linux'),(9,'Networking'),
(10,'D3.js'),(10,'Python'),(10,'Tableau'),
(11,'React'),(11,'Django'),
(12,'Docker'),(12,'GitHub Actions');

-- Table 8: Project_members (M:N junction)
INSERT INTO Project_members (project_id, user_id, project_role, removed) VALUES
(1, 1, 'lead', FALSE),
(1, 5, 'member', FALSE),
(1, 7, 'member', FALSE),
(2, 2, 'lead', FALSE),
(2, 3, 'member', FALSE),
(2, 6, 'member', FALSE),
(4, 4, 'lead', FALSE),
(4, 3, 'member', FALSE),
(5, 5, 'lead', FALSE),
(5, 1, 'member', FALSE),
(8, 2, 'lead', FALSE),
(8, 4, 'member', FALSE),
(9, 8, 'lead', FALSE),
(12, 6,'lead', FALSE),
(11,11,'lead', FALSE);

-- Table 9: Applications (M:N junction)
INSERT INTO Applications (project_id, applicant_id, message, status) VALUES
(2,  4,  'Strong backend skills in Node.js.', 'pending'),
(2,  8,  'Interested in security aspects of real-time.', 'rejected'),
(3,  6,  'Experience with MQTT and Arduino.','accepted'),
(6,  10, 'Built a Solidity contract last semester.', 'pending'),
(7,  3,  'Love mobile and AR development.', 'accepted'),
(7,  9,  'Game dev background, comfortable with Unity.', 'pending'),
(9,  10, 'CTF participant, interested in challenges.',  'accepted'),
(10, 1,  'ML background suits the data analysis aspect.',  'pending'),
(11, 4,  'Interested in ed-tech tooling.', 'pending'),
(11, 7,  'Data viz specialist — aligns perfectly.',  'accepted'),
(1,  6,  'DevOps support for model deployment pipeline.',  'rejected'),
(12, 4,  'Want to standardize CI/CD for student teams.', 'pending');

-- Table 10: Project_messages
INSERT INTO Project_messages (project_id, sender_id, content) VALUES
(1, 1, 'Welcome to the AI Crop Disease Detector! Lets start with dataset collection.'),
(1, 5, 'Found a great open-source dataset on PlantVillage.'),
(1, 7, 'Should we use ResNet or EfficientNet as the backbone?'),
(2, 2, 'Sprint 1 goal: set up the WebSocket server and basic chat rooms.'),
(2, 3, 'Frontend scaffolding ready — using React + Vite.'),
(5, 5, 'Model accuracy at 87% after feature engineering. Improving recall now.'),
(9, 8, 'First challenge is live — SQL injection category!'),
(11, 11,'Please review the module editor prototype on the dev branch.'),
(4, 4, 'Course Planner v1.0 shipped! Closing out the project.'),
(8, 2, 'Marketplace live at staging. Please complete final UAT.'),
(12,6, 'Pipeline template for Python projects is ready and tested.'),
(3, 3, 'Starting sensor integration for the HVAC monitoring unit.');

-- Table 11: User_skills
INSERT INTO User_skills (user_id, skill, user_level) VALUES
(1, 'Python', 'advanced'),
(1, 'TensorFlow', 'intermediate'),
(2, 'React', 'expert'),
(2, 'Node.js', 'advanced'),
(3, 'Kotlin', 'intermediate'),
(3, 'Figma', 'advanced'),
(4, 'SQL', 'expert'),
(4, 'TypeScript', 'intermediate'),
(5, 'Python', 'expert'),
(5, 'Scikit-learn', 'advanced'),
(6, 'Docker', 'advanced'),
(6, 'GitHub Actions', 'intermediate'),
(7, 'Tableau',  'advanced'),
(8, 'Linux', 'advanced'),
(10,'Solidity', 'beginner');

-- Table 12: User_interests
INSERT INTO User_interests (user_id, tag) VALUES
(1,'AI'),(1,'agriculture'),
(2,'web'),(2,'open-source'),
(3,'mobile-development'),(3,'UX'),
(4,'databases'),(4,'backend'),
(5,'machine-learning'),(5,'finance'),
(6,'cloud'),(6,'devops'),
(7,'data-science'),(7,'visualization'),
(8,'cybersecurity');

-- Table 13: Endorsements (M:N self-referencing
INSERT INTO Endorsements (giver_id, receiver_id, user_skill) VALUES
(2,  1,  'Python'),
(5,  1,  'TensorFlow'),
(1,  2,  'React'),
(4,  2,  'Node.js'),
(2,  3,  'Kotlin'),
(1,  5,  'Python'),
(6,  4,  'SQL'),
(7,  4,  'TypeScript'),
(4,  6,  'Docker'),
(3,  6,  'GitHub Actions'),
(1,  7,  'Tableau'),
(8,  10, 'Solidity');

-- Table 14: Badges
INSERT INTO Badges (badge_name, badge_description, icon, badge_condition) VALUES
('First Project',   'Awarded for posting your first project.',   '/icons/first.svg', 'projects owned >= 1'),
('Team Player', 'Awarded for joining 3 or more projects.', '/icons/team.svg', 'projects joined >= 3'),
('Top Rated', 'Awarded for achieving average rating of 4.5+.', '/icons/rated.svg', 'avg feedback rating >= 4.5'),
('Mentor', 'Awarded for endorsing 10 or more peers.', '/icons/mentor.svg', 'endorsements given >= 10'),
('Completionist', 'Awarded for completing 5 or more projects.',  '/icons/complete.svg', 'completed projects >= 5');

-- Table 15: User_badges (M:N junction)
INSERT INTO User_badges (user_id, badge_id) VALUES
(1, 1),(2, 1),(4, 1),(5, 1),(6, 1),
(2, 2),
(5, 3),
(1, 4),
(2, 5),(4, 5);

-- Table 16: Feedback
INSERT INTO Feedback (project_id, giver_id, receiver_id, rating, rating_comment, is_instructor_rating) VALUES
(4,  3,  4,  5, 'Great team lead, always organized and helpful.', FALSE),
(4,  4,  3,  4, 'Solid contributor, responsive to feedback.', FALSE),
(8,  4,  2,  5, 'Excellent communication and technical skills.', FALSE),
(8,  2,  4,  4, 'Good backend work throughout.', FALSE),
(12, 6,  6,  5, 'Outstanding DevOps architecture.', FALSE),
(1,  5,  1,  5, 'Exceptional ML skills and leadership.', FALSE),
(1,  7,  1,  4, 'Strong project lead, very clear communicator.', FALSE),
(5,  1,  5,  5, 'Best ML engineer I have worked with.',FALSE),
(4,  11, 4,  5, 'Impressive work for a third-year student.', TRUE),
(8,  11, 2,  5, 'Well-structured codebase, good documentation.',  TRUE),
(1,  13, 1,  4, 'Very promising researcher.', TRUE),
(12, 12, 6,  5, 'Excellent grasp of CI/CD practices.',  TRUE);

-- Table 17: Chats
INSERT INTO Chats (user_id, chat_subject, chat_status, admin_id) VALUES
(3,  'Cannot upload avatar image', 'closed', 14),
(8,  'Incorrect badge awarded',  'assigned', 14),
(7,  'Question about feedback visibility',  'open', NULL),
(10, 'Application status not updating', 'closed',   15),
(6,  'Request to archive old project', 'assigned', 15);

-- Table 18: Chat_metadata (1:1 with Chats)
-- [1:1 — exactly one metadata row per chat]
INSERT INTO Chat_metadata (chat_id, priority, resolution_note, resolved_by_id, resolved_at) VALUES
(1, 'normal', 'User resized image below 2 MB limit. Issue resolved.', 14, '2025-04-10 11:30:00'),
(2, 'high',   NULL, NULL, NULL),
(3, 'normal', NULL, NULL, NULL),
(4, 'normal', 'Sent reminder to project owner to review application.', 15, '2025-04-12 09:00:00'),
(5, 'low',    NULL, NULL, NULL);


-- Table 19: Chat_messages
INSERT INTO Chat_messages (chat_id, sender_id, message) VALUES
(1, 3,  'I keep getting a 413 error when uploading my profile photo.'),
(1, 14, 'Please try resizing your image below 2 MB.'),
(1, 3,  'That worked! Thank you.'),
(1, 14, 'Great, marking this as resolved.'),
(2, 8,  'I was awarded the Team Player badge but have only joined 2 projects.'),
(2, 14, 'Thank you for flagging this. We will investigate and correct it.'),
(3, 7,  'Can other project members see the feedback I gave?'),
(4, 10, 'My application still shows pending after a week.'),
(4, 15, 'Owner has not reviewed yet. We will send a reminder.'),
(5, 6,  'I want to archive my DevOps project. How do I do that?');

-- Table 20: Admin_messages
INSERT INTO Admin_messages (user_id, sender_id, content, is_warning) VALUES
(8,  14, 'Badge corrected — apologies for the inconvenience.', FALSE),
(3,  14, 'Reminder: please keep project descriptions clear and professional.', FALSE),
(10, 15, 'Warning: your application message was flagged for inappropriate language.', TRUE),
(2,  15, 'Congratulations! Your Student Marketplace project has been featured on the homepage.', FALSE),
(9,  14, 'Your AR Campus Tour project has had no activity for 30 days. Please update its status.', FALSE);

-- Table 21: Reports
INSERT INTO Reports (reporter_id, target_user_id, target_project_id, reason, report_description, report_status) VALUES
(4,  10, NULL, 'Inappropriate language', 'Applicant used offensive language in application.', 'resolved'),
(7,  NULL,  6, 'Misleading description', 'Blockchain voting project scope is misrepresented.', 'pending'),
(3,  8,  NULL, 'Harassment', 'User sent repeated unsolicited messages.', 'reviewed'),
(5,  NULL,  2, 'Spam', 'Project posted multiple times with duplicate content.', 'dismissed'),
(1,  NULL,  7, 'Inappropriate content', 'Project cover image contains offensive material.', 'pending');
