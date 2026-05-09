-- Commented ProjectBuddy MySQL Script
-- CS306 Project

-- creating database ProjectBuddy
CREATE DATABASE ProjectBuddy;
USE ProjectBuddy;

-- Table no.1 'Users' is the central entity of the platform. Stores authentication data only.
CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL, -- unique identifier
    email VARCHAR(255) NOT NULL UNIQUE, -- must be unique
    password_hash VARCHAR(255) NOT NULL, -- hash; not using plain text
    user_role VARCHAR(20) NOT NULL DEFAULT 'student', -- role may be'student', 'instructor' or 'admin'; default 'student'
    is_active BOOLEAN NOT NULL DEFAULT TRUE, -- FALSE if the account is deactivated
    is_banned BOOLEAN NOT NULL DEFAULT FALSE, -- TRUE if the account is banned by an admin
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP -- account creation timestamp
);

-- Table no.2 'User_profiles' extends 'Users' with 1:1 relationship
CREATE TABLE User_profiles (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, -- PK autoincrementing
    user_id INT NOT NULL UNIQUE, -- must be unique
    first_name VARCHAR(100) NOT NULL, -- first name of user
    last_name VARCHAR(100) NOT NULL, -- last name of user
    department VARCHAR(150), -- faculty/department of user
    bio TEXT, -- optional profile biography
    avatar_url VARCHAR(500), -- optional profile picture URL
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE -- integrity constraint and DELETE CASCADE for profile removed with user
);

-- Table no.3 'Password_resets' stores data for users who attempt resetting password
CREATE TABLE Password_resets (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- the requesting user
    token VARCHAR(255) NOT NULL UNIQUE, -- random one-time token
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- timestamp 
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE -- integrity constrint and DELETE CASCADE because tokens without users are meaningless
);

-- Table no.4 'Projects' is 1:1 with Users and Project_settings and stores project dat
CREATE TABLE Projects (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL, -- project title
    project_description TEXT, -- full goals and requirements
    owner_id INT NOT NULL, -- the user who posted the project
    course VARCHAR(150), -- optional related course
    team_size SMALLINT  nOT NULL DEFAULT 1, -- maximum members sought
    project_status VARCHAR(20) NOT NULL DEFAULT 'open', -- can be 'open', 'in_progress', 'completed' or'cancelled'
    deadline DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES Users(id) ON DELETE RESTRICT -- integrity constraint; safety lock on DELETE RESTRICT as owner must first handoff/close project
);

-- Table no.5 'Project_settings' 1:1 with Projects and relate to personal user preferences
CREATE TABLE Project_settings (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL UNIQUE, -- must be unique
    is_public BOOLEAN NOT NULL DEFAULT TRUE, -- is the project visible to non-members
    allow_direct_apply BOOLEAN NOT NULL DEFAULT TRUE, -- open application mode
    notify_on_application BOOLEAN NOT NULL DEFAULT TRUE, -- send email t0 owner on new application
    notify_on_message BOOLEAN NOT NULL DEFAULT TRUE, -- email owner on group chat message
    FOREIGN KEY (project_id) REFERENCES Projects(id) ON DELETE CASCADE -- settings removed with project
);

-- Table no. 6 'Project_tags' for a given project (1:N project-project_tag relationship)
CREATE TABLE Project_tags (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    project_id INT  NOT NULL,
    tag VARCHAR(100) NOT NULL, -- the tag, such as 'machine-learning', 'web'
    UNIQUE (project_id, tag), -- the same project cannot have the same tag twice
    FOREIGN KEY (project_id) REFERENCES Projects(id) ON DELETE CASCADE -- integrity constraint
);

-- Table no. 7 'Project_skills' refers to the skills a given project requires and is kept seperate from tags
CREATE TABLE Project_skills (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    skill VARCHAR(100) NOT NULL, -- e.g. 'Python', 'React', 'JS' etc.
    UNIQUE (project_id, skill), -- a project cannot require the same skill twice
    FOREIGN KEY (project_id) REFERENCES Projects(id) ON DELETE CASCADE -- integrity constraintf
);

-- Table no.8 'Project_members' links many users to many projects and acts as junction
CREATE TABLE Project_members (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    user_id INT NOT NULL,
    project_role VARCHAR(100) NOT NULL DEFAULT 'member', -- role may be 'member' or 'lead'
    joined_at TIMESTAMP nOT NULL DEFAULT CURRENT_TIMESTAMP,
    removed BOOLEAN nOT NULL DEFAULT FALSE,
    removed_at TIMESTAMP,
    UNIQUE (project_id, user_id), -- a project cannot have the same member twice
    FOREIGN KEY (project_id) REFERENCES Projects(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)    REFERENCES Users(id)    ON DELETE CASCADE -- integrity constraints
);

-- Table no. 9 'Applications' relates Users to Projects and is seperate from Project_members; also a junction table
CREATE TABLE Applications (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    applicant_id INT NOT NULL,
    message TEXT, -- optional cover message
    status VARCHAR(20)  NOT NULL DEFAULT 'pending', -- once made must be either 'pending','accepted' or'rejected'
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP,
    UNIQUE (project_id, applicant_id), -- the same applicant cannot apply twice for the same project
    FOREIGN KEY (project_id)   REFERENCES Projects(id) ON DELETE CASCADE,
    FOREIGN KEY (applicant_id) REFERENCES Users(id)    ON DELETE CASCADE -- integrity constrant
);

-- Table no. 10 'Project_messages' conaints datat related to group chat within a project
CREATE TABLE Project_messages (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    project_id INT nOT NULL,
    sender_id INT nOT NULL, -- the member who sent message
    content TEXT NOT NULL, -- message contenct
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES Projects(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id)  REFERENCES Users(id)    ON DELETE CASCADE -- integrity constraints,
);

-- Table no.11 'User_skills' contains the skills a given user has (1:N, a user has many skills)
CREATE TABLE User_skills (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    skill VARCHAR(100) NOT NULL,
    user_level VARCHAR(20)  NOT NULL DEFAULT 'beginner', -- can be ranges from 'beginner', 'intermediate' to 'advanced', and'expert'
    UNIQUE (user_id, skill), -- a user cannot have the same skill twice
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Table no.12: 'User_interests' caontins the information regarding the interest of given user (1:N user has many interest)
CREATE TABLE User_interests (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tag VARCHAR(100) NOT NULL, -- interest tag
    UNIQUE (user_id, tag), -- a user cannot be interested in the same thing twice
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Table 13 'Endorsements acts as a M:N self-referencing junctioln for Users (Users endorse and get endorsed by other Users)
CREATE TABLE Endorsements (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    giver_id int nOT NULL,
    receiver_id INT NOT NULL,
    user_skill   VARCHAR(100) NOT NULL, -- the specific skill being endorsed by other users
    created_at tIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (giver_id, receiver_id, user_skill), -- a user cannot endorse the same skill to the same receiver twice
    FOREIGN KEY (giver_id)REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Table no.14 'Badges' defines the badges that exist in ProjectBuddy platform
CREATE TABLE Badges (
    id INt NOT NULL AUTO_INCREMENT PRIMARY KEY,
    badge_name VARCHAR(150) NOT NULL UNIQUE, -- every badge must be unique
    badge_description TEXT, -- a description of what the badge represenets
    icon VARCHAR(500), -- URL for badge icon image
    badge_condition TEXT -- readbale earning condition for a given badge
);

-- Table no. 15 'User_badges' relates Users to Badges and is a junction for M:N User-Badge relationship
CREATE TABLE User_badges (
    id iNT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INt nOT NULL,
    badge_id INT NOT NULL,
    earned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, badge_id), -- a user cannot earn the same badge twice
    FOREIGN KEY (user_id)  REFERENCES Users(id)   ON DELETE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES Badges(id)  ON DELETE CASCADE -- integrity
);

-- Table no.16 'Feedback' contains the feedback a User gives to many Other users, and receives
CREATE TABLE Feedback (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    giver_id INT NOT NULL,
    receiver_id INT NOT NULL,
    rating SMALLINT  NOT NULL CHECK (rating BETWEEN 1 AND 5), -- when feedback is given rating cannot be null, and must be between 1 and 5
    rating_comment TEXT, -- optional additional comment
    is_instructor_rating BOOLEAN   NOT NULL DEFAULT FALSE, -- is an instructor giving the rating?
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (project_id, giver_id, receiver_id), -- a feedback giver cannot give more than one feedback to a receiver in a given project
    FOREIGN KEY (project_id)  REFERENCES Projects(id) ON DELETE CASCADE,
    FOREIGN KEY (giver_id)    REFERENCES Users(id)    ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES Users(id)    ON DELETE CASCADE -- integrity constraints
);
-- Table mo. 17 'Chats' contains information regarding the chats between users and admin users
-- chat becomes unassigned (not deleted) for another admin to claim.
CREATE TABLE Chats (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id iNT NOT NULL, -- the user who opened the chat
    chat_subject VARCHAR(255), -- optional subject line
    chat_status VARCHAR(20)  NOT NULL DEFAULT 'open', -- status ofa  chat that is made may be 'open' 'assigned' or'closed'
    admin_id  INT, -- set when assigned
    created_at TIMESTAMP nOT NULL DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP,
    FOREIGN KEY (user_id)  REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES Users(id) ON DELETE SET NULL  -- chat becomes unassigned (not deleted), for some other admin to claim.
);

-- Table no.18 'Chat_metadata' stores data related to user-admin chats and are 1:1 with Chats
CREATE TABLE Chat_metadata (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    chat_id INT NOT NULL UNIQUE, -- UNIQUE = 1:1 enforcer
    priority VARCHAR(20) nOT NULL DEFAULT 'normal', -- chat priority can be either 'low', 'normal', 'high', or 'urgent'
    resolution_note TEXT, -- admin summary on close
    resolved_by_id INT, -- admin who closed (nullable)
    resolved_at TIMESTAMP, -- resolution time stamp for historical integrity
    FOREIGN KEY (chat_id)        REFERENCES Chats(id) ON DELETE CASCADE,
    FOREIGN KEY (resolved_by_id) REFERENCES Users(id) ON DELETE SET NULL -- integrity constraint
);
-- Table no.19 'Chat_messages' contains the message contents of chats 1:N (one chat has many messages,)
CREATE TABLE Chat_messages (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    chat_id INT nOT NULL,
    sender_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chat_id)   REFERENCES Chats(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES Users(id) ON DELETE CASCADE
);

-- Table no.20 Admin_messages contains the messages that admins send to a given user, or recipient. sneder is always an admin
CREATE TABLE Admin_messages (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT nOT NULL, -- the recipient
    sender_id INT NOT NULL, -- the admin sending the message
    content TEXT NOT NULL, -- the content of admin's message
    is_read BOOLEAN NOT NULL DEFAULT FALSE, -- has it been read by the recipient
    is_warning BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)   REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES Users(id) ON DELETE CASCADE -- integrity
);
-- Table no. 21 'Reports' contains the User reports of another user and related data and represent an XOR relationship
CREATE TABLE Reports (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    reporter_id INT NOT NULL, -- user who filed a given report
    target_user_id INT, -- null if reporting a project
    target_project_id INT, -- null if reporting a user
    reason VARCHAR(255) NOT NULL, -- reason for writing a report
    report_description TEXT, -- description of violation or other reason for writing report
    report_status VARCHAR(20)  NOT NULL DEFAULT 'pending', -- a report once made must be either 'pending', 'reviewed', 'resolved' or 'dismissed'
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    -- XOR constraint: exactly one target must be set, never both, never neither
    CHECK (
        (target_user_id IS NOT NULL AND target_project_id IS NULL)
        OR								-- exclusive OR (XOR) constraint: exactly one target must exist, either project or user, never both, never neither
        (target_user_id IS NULL AND target_project_id IS NOT NULL)
    ),
    FOREIGN KEY (reporter_id) REFERENCES Users(id)    ON DELETE CASCADE,
    FOREIGN KEY (target_user_id) REFERENCES Users(id)    ON DELETE CASCADE,
    FOREIGN KEY (target_project_id)REFERENCES Projects(id) ON DELETE CASCADE -- integrity constraints
);

