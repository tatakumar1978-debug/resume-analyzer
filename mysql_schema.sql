-- Reference schema for the Resume Analyzer project.
-- You do NOT need to run this by hand: Hibernate (spring.jpa.hibernate.ddl-auto=update)
-- creates and updates all of these tables automatically on startup.
-- Kept here so you can show/explain the underlying MySQL structure in your demo/viva.

CREATE DATABASE IF NOT EXISTS resume_analyzer;
USE resume_analyzer;

CREATE TABLE IF NOT EXISTS app_user (
    user_id    BIGINT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(255),
    email      VARCHAR(255),
    phone      VARCHAR(50),
    education  VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS resume (
    resume_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    qualification VARCHAR(255),
    experience    VARCHAR(255),
    user_id       BIGINT,
    FOREIGN KEY (user_id) REFERENCES app_user(user_id)
);

CREATE TABLE IF NOT EXISTS resume_skills (
    resume_id BIGINT,
    skill     VARCHAR(255),
    FOREIGN KEY (resume_id) REFERENCES resume(resume_id)
);

CREATE TABLE IF NOT EXISTS resume_projects (
    resume_id BIGINT,
    project   VARCHAR(255),
    FOREIGN KEY (resume_id) REFERENCES resume(resume_id)
);

CREATE TABLE IF NOT EXISTS resume_certifications (
    resume_id     BIGINT,
    certification VARCHAR(255),
    FOREIGN KEY (resume_id) REFERENCES resume(resume_id)
);

-- Single-table inheritance: JobRole / TechnicalRole / ManagerialRole
CREATE TABLE IF NOT EXISTS job_role (
    role_id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_type         VARCHAR(31) NOT NULL,   -- discriminator: TECHNICAL / MANAGERIAL
    role_name         VARCHAR(255),
    tech_stack        VARCHAR(255),           -- only used by TechnicalRole rows
    team_size_managed INT                     -- only used by ManagerialRole rows
);

CREATE TABLE IF NOT EXISTS job_role_skills (
    role_id BIGINT,
    skill   VARCHAR(255),
    FOREIGN KEY (role_id) REFERENCES job_role(role_id)
);

CREATE TABLE IF NOT EXISTS report (
    report_id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    candidate_name   VARCHAR(255),
    target_role      VARCHAR(255),
    match_percentage DOUBLE,
    report_text      VARCHAR(2000),
    generated_at     DATETIME
);
