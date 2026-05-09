-- Information Report Generation script for ProjectBuddy Mock Data

-- REPORT 1: Student Reputation Leaderboard
SELECT
    u.id AS user_id,
    CONCAT(up.first_name, ' ', up.last_name) AS student_name,
    up.department,
    COUNT(DISTINCT pm.id) AS projects_joined,
    ROUND(AVG(f.rating), 2) AS avg_feedback_rating,
    COUNT(DISTINCT e.id) AS endorsements_received,
    COUNT(DISTINCT ub.id) AS badges_earned,
    -- Composite reputation score: weighted sum of signals
    ROUND(
        COALESCE(AVG(f.rating), 0) * 3
        + COUNT(DISTINCT e.id)     * 1
        + COUNT(DISTINCT pm.id)    * 2
        + COUNT(DISTINCT ub.id)    * 2,
    2) AS reputation_score
FROM Users u
INNER JOIN User_profiles  up ON up.user_id = u.id -- 1:1 join to get name + department
LEFT JOIN  Project_members pm ON pm.user_id = u.id
AND pm.removed = FALSE
LEFT JOIN  Feedback f ON f.receiver_id = u.id
LEFT JOIN  Endorsements    e  ON e.receiver_id = u.id
LEFT JOIN  User_badges     ub ON ub.user_id    = u.id
WHERE u.user_role = 'student'
GROUP BY u.id, up.first_name, up.last_name, up.department
ORDER BY reputation_score DESC;

-- REPORT 2: ProjectStatus report
SELECT
    p.id AS project_id,
    p.title,
    p.project_status,
    CONCAT(up.first_name, ' ', up.last_name) AS owner_name,
    ROUND(AVG(f.rating), 2) AS avg_team_rating,
    ps.is_public,
    DATEDIFF(p.deadline, CURDATE()) AS days_until_deadline
FROM Projects p
INNER JOIN Users u   ON p.owner_id     = u.id    -- get owner record
INNER JOIN User_profiles   up  ON up.user_id     = u.id    -- 1:1 join for owner name
LEFT JOIN  Project_settings ps  ON ps.project_id  = p.id   -- 1:1 join for settings
LEFT JOIN  Project_members  pm  ON pm.project_id  = p.id
AND pm.removed    = FALSE
LEFT JOIN  Project_messages msg ON msg.project_id = p.id
LEFT JOIN  Applications     ap  ON ap.project_id  = p.id
LEFT JOIN  Feedback         f   ON f.project_id   = p.id
GROUP BY
    p.id, p.title, p.project_status,
    up.first_name, up.last_name, p.deadline
ORDER BY days_until_deadline ASC;

-- REPORT 3: Skill Gap Analysis — Demand vs Supply
SELECT
    skill_name,
    SUM(projects_requiring)  AS projects_requiring,
    SUM(students_with_skill) AS students_with_skill,
    SUM(times_endorsed)      AS times_endorsed,
    CASE
        WHEN SUM(projects_requiring) > SUM(students_with_skill) THEN 'Under-supplied'
        WHEN SUM(projects_requiring) < SUM(students_with_skill) THEN 'Well-supplied'
        ELSE 'Balanced'
    END AS supply_status
FROM (
    -- Project demand
    SELECT skill          AS skill_name,
           COUNT(*)       AS projects_requiring,
           0              AS students_with_skill,
           0              AS times_endorsed
    FROM Project_skills
    GROUP BY skill
    UNION ALL
    -- Student supply (join to Users to ensure only students counted)
    SELECT us.skill       AS skill_name,
           0,
           COUNT(*)       AS students_with_skill,
           0
    FROM User_skills us
    INNER JOIN Users u ON u.id = us.user_id
    WHERE u.user_role = 'student'
    GROUP BY us.skill
    UNION ALL
    -- Endorsement depth
    SELECT user_skill     AS skill_name,
           0,
           0,
           COUNT(*)       AS times_endorsed
    FROM Endorsements
    GROUP BY user_skill
) combined
GROUP BY skill_name
ORDER BY projects_requiring DESC, students_with_skill DESC;

-- REPORT 4: Admin & Moderation Activity Summary
SELECT
    u.id AS admin_id,
    CONCAT(up.first_name, ' ', up.last_name) AS admin_name,
    COUNT(DISTINCT c.id) AS chats_handled,
    COUNT(DISTINCT cm_msg.id) AS chat_messages_sent,
    COUNT(DISTINCT am.id) AS admin_messages_sent,
    SUM(CASE WHEN am.is_warning = TRUE THEN 1 ELSE 0 END)  AS warnings_issued,
    COUNT(DISTINCT r.id) AS reports_resolved,
    -- From Chat_metadata (1:1 join) — resolution insight
    COUNT(DISTINCT CASE WHEN cmd.priority = 'high'
	OR cmd.priority = 'urgent'
	THEN cmd.id END) AS high_priority_chats,
    ROUND( 100.0 * COUNT(DISTINCT CASE WHEN c.chat_status = 'closed' THEN c.id END) / NULLIF(COUNT(DISTINCT c.id), 0), 1)                                                      AS chat_resolution_rate_pct
FROM Users u
INNER JOIN User_profiles   up  ON up.user_id     = u.id    -- 1:1 join for admin name
LEFT JOIN  Chats           c   ON c.admin_id     = u.id    -- chats this admin handled
LEFT JOIN  Chat_metadata   cmd ON cmd.chat_id    = c.id    -- 1:1 join for priority/resolution data
LEFT JOIN  Chat_messages   cm_msg ON cm_msg.sender_id = u.id
AND cm_msg.chat_id   = c.id
LEFT JOIN  Admin_messages  am  ON am.sender_id   = u.id
LEFT JOIN  Reports         r   ON r.report_status = 'resolved'
AND (
-- count reports where this admin resolved via chat
cmd.resolved_by_id = u.id
)
WHERE u.user_role = 'admin'
GROUP BY u.id, up.first_name, up.last_name
ORDER BY chats_handled DESC;
