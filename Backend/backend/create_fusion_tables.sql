-- Essential Fusion tables for System Administrator app
-- This creates minimal table structure for the app to function

-- Department Information
CREATE TABLE IF NOT EXISTS globals_departmentinfo (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Designations/Roles
CREATE TABLE IF NOT EXISTS globals_designation (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    type VARCHAR(30) NOT NULL,
    basic BOOLEAN DEFAULT FALSE NOT NULL,
    category VARCHAR(20),
    dept_if_not_basic_id INTEGER REFERENCES globals_departmentinfo(id)
);

-- Extra Info (User profiles)
CREATE TABLE IF NOT EXISTS globals_extrainfo (
    id VARCHAR(100) PRIMARY KEY,
    title VARCHAR(20),
    sex VARCHAR(1),
    date_of_birth DATE,
    user_status VARCHAR(30),
    address TEXT,
    phone_no VARCHAR(20),
    about_me TEXT,
    user_type VARCHAR(30),
    profile_picture VARCHAR(200),
    date_modified DATE,
    department_id INTEGER REFERENCES globals_departmentinfo(id),
    user_id INTEGER REFERENCES auth_user(id)
);

-- Holds Designation (User roles)
CREATE TABLE IF NOT EXISTS globals_holdsdesignation (
    id SERIAL PRIMARY KEY,
    held_at TIMESTAMP,
    designation_id INTEGER REFERENCES globals_designation(id),
    user_id INTEGER REFERENCES auth_user(id),
    working_id INTEGER REFERENCES auth_user(id)
);

-- Module Access
CREATE TABLE IF NOT EXISTS globals_moduleaccess (
    id SERIAL PRIMARY KEY,
    designation VARCHAR(50) UNIQUE NOT NULL,
    program_and_curriculum BOOLEAN DEFAULT FALSE,
    course_registration BOOLEAN DEFAULT FALSE,
    course_management BOOLEAN DEFAULT FALSE,
    other_academics BOOLEAN DEFAULT FALSE,
    spacs BOOLEAN DEFAULT FALSE,
    department BOOLEAN DEFAULT FALSE,
    examinations BOOLEAN DEFAULT FALSE,
    hr BOOLEAN DEFAULT FALSE,
    iwd BOOLEAN DEFAULT FALSE,
    complaint_management BOOLEAN DEFAULT FALSE,
    fts BOOLEAN DEFAULT FALSE,
    purchase_and_store BOOLEAN DEFAULT FALSE,
    rspc BOOLEAN DEFAULT FALSE,
    hostel_management BOOLEAN DEFAULT FALSE,
    mess_management BOOLEAN DEFAULT FALSE,
    gymkhana BOOLEAN DEFAULT FALSE,
    placement_cell BOOLEAN DEFAULT FALSE,
    visitor_hostel BOOLEAN DEFAULT FALSE,
    phc BOOLEAN DEFAULT FALSE,
    inventory_management BOOLEAN DEFAULT FALSE
);

-- Programme
CREATE TABLE IF NOT EXISTS programme_curriculum_programme (
    id SERIAL PRIMARY KEY,
    category VARCHAR(3) NOT NULL,
    name VARCHAR(70) UNIQUE NOT NULL,
    programme_begin_year INTEGER NOT NULL
);

-- Discipline
CREATE TABLE IF NOT EXISTS programme_curriculum_discipline (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    acronym VARCHAR(10) NOT NULL DEFAULT ''
);

-- Curriculum
CREATE TABLE IF NOT EXISTS programme_curriculum_curriculum (
    id SERIAL PRIMARY KEY,
    programme_id INTEGER REFERENCES programme_curriculum_programme(id),
    name VARCHAR(100) NOT NULL,
    version DECIMAL(5,1) DEFAULT 1.0,
    working_curriculum BOOLEAN DEFAULT TRUE,
    no_of_semester INTEGER DEFAULT 1,
    min_credit INTEGER DEFAULT 0,
    latest_version BOOLEAN DEFAULT TRUE,
    UNIQUE(name, version)
);

-- Batch
CREATE TABLE IF NOT EXISTS programme_curriculum_batch (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    discipline_id INTEGER REFERENCES programme_curriculum_discipline(id),
    year INTEGER NOT NULL,
    curriculum_id INTEGER REFERENCES programme_curriculum_curriculum(id),
    running_batch BOOLEAN DEFAULT TRUE,
    UNIQUE(name, discipline_id, year)
);

-- Student Information
CREATE TABLE IF NOT EXISTS academic_information_student (
    id VARCHAR(100) PRIMARY KEY REFERENCES globals_extrainfo(id),
    programme VARCHAR(50),
    batch INTEGER,
    batch_id INTEGER REFERENCES programme_curriculum_batch(id),
    cpi DECIMAL(3,2) DEFAULT 0.0,
    category VARCHAR(10) DEFAULT 'GEN',
    father_name VARCHAR(100),
    mother_name VARCHAR(100),
    hall_no INTEGER,
    room_no VARCHAR(20),
    specialization VARCHAR(100),
    curr_semester_no INTEGER
);

-- Faculty Information
CREATE TABLE IF NOT EXISTS academic_information_faculty (
    id VARCHAR(100) PRIMARY KEY REFERENCES globals_extrainfo(id)
);

-- Staff Information
CREATE TABLE IF NOT EXISTS academic_information_staff (
    id VARCHAR(100) PRIMARY KEY REFERENCES globals_extrainfo(id)
);

-- Insert default data
INSERT INTO globals_departmentinfo (name) VALUES 
('CSE'), ('ECE'), ('ME'), ('CE'), ('Physics'), ('Chemistry'), ('Mathematics'), ('Humanities')
ON CONFLICT (name) DO NOTHING;

INSERT INTO globals_designation (name, full_name, type, basic, category) VALUES
('student', 'Student', 'academic', TRUE, 'student'),
('faculty', 'Faculty Member', 'academic', TRUE, 'faculty'),
('staff', 'Staff', 'administrative', TRUE, 'staff'),
('system_administrator', 'System Administrator', 'administrative', TRUE, 'admin')
ON CONFLICT (name) DO NOTHING;

INSERT INTO programme_curriculum_programme (category, name, programme_begin_year) VALUES
('UG', 'B.Tech', 2005),
('PG', 'M.Tech', 2005),
('PG', 'M.Des', 2010),
('PHD', 'Ph.D', 2005)
ON CONFLICT (name) DO NOTHING;
