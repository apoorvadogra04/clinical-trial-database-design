CREATE DATABASE iihmrpill_clinical_trial;
USE iihmrpill_clinical_trial;

CREATE TABLE subjects (
    subject_id VARCHAR(20) PRIMARY KEY,
    screening_id VARCHAR(20),
    site_number VARCHAR(10),
    initials VARCHAR(10),
    visit_date DATE,
    consent_obtained BOOLEAN,
    screening_status VARCHAR(50),
    fail_reason TEXT
);



CREATE TABLE eligibility (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),
    
    inc_age_18 BOOLEAN,
    inc_htn_dx BOOLEAN,
    inc_sbp_baseline BOOLEAN,
    inc_dbp_baseline BOOLEAN,

    exc_secondary_htn BOOLEAN,
    exc_pregnant BOOLEAN,
    exc_drug_allergy BOOLEAN,
    exc_malignancy BOOLEAN,

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE randomisation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),

    rand_date DATE,
    rand_time TIME,
    rand_number VARCHAR(20),
    treat_arm VARCHAR(50),
    stratum VARCHAR(20),
    rand_status VARCHAR(20),

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE visits (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),

    visit_name VARCHAR(50),
    visit_date DATE,

    sbp1 INT,
    dbp1 INT,
    sbp2 INT,
    dbp2 INT,
    sbp3 INT,
    dbp3 INT,

    sbp_mean FLOAT,
    dbp_mean FLOAT,
    
    heart_rate INT,
    weight FLOAT,
    height FLOAT,
    bmi FLOAT,

    physical_exam_abnormal BOOLEAN,
    abnormal_desc TEXT,

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


CREATE TABLE medical_history (
    mh_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),

    condition_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    ongoing BOOLEAN,
    comments TEXT,

    hypertension_duration INT,
    prior_antihyp BOOLEAN,
    prior_therapy TEXT,

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE follow_up (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),

    fu_date DATE,
    sbp_mean FLOAT,
    dbp_mean FLOAT,
    heart_rate INT,

    compliance_pct FLOAT,
    missed_doses INT,

    visit_completed BOOLEAN,
    reason_missed VARCHAR(100),

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE adverse_events (
    ae_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),

    ae_term TEXT,
    start_date DATE,
    end_date DATE,
    ongoing BOOLEAN,

    severity VARCHAR(20),
    action_taken VARCHAR(50),
    outcome VARCHAR(50),

    sae_flag BOOLEAN,

    -- SAE fields
    hospitalisation BOOLEAN,
    life_threat BOOLEAN,
    death_date DATE,
    causality VARCHAR(50),
    expedited_report BOOLEAN,

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE concomitant_medications (
    cm_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),

    drug_name VARCHAR(100),
    indication VARCHAR(100),
    start_date DATE,
    end_date DATE,

    ongoing BOOLEAN,
    antihypertensive BOOLEAN,

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


CREATE TABLE lab_tests (
    lab_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),

    visit VARCHAR(20),
    lab_date DATE,

    creatinine FLOAT,
    egfr FLOAT,
    potassium FLOAT,
    sodium FLOAT,
    alt FLOAT,
    ast FLOAT,

    abnormal_flag BOOLEAN,
    ae_link VARCHAR(20),

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


CREATE TABLE trial_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id VARCHAR(20),

    completion_status VARCHAR(50),
    discontinuation_reason VARCHAR(100),

    primary_endpoint_available BOOLEAN,
    protocol_deviation BOOLEAN,

    pd_prohibited_drug BOOLEAN,
    pd_missed_dose BOOLEAN,
    pd_missed_visit BOOLEAN,

    itt_population BOOLEAN,
    pp_population BOOLEAN,

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


INSERT INTO subjects VALUES
('SUBJ001','SCR001','S01','AD','2026-04-01',TRUE,'Enrolled',NULL),
('SUBJ002','SCR002','S01','RK','2026-04-01',TRUE,'Enrolled',NULL),
('SUBJ003','SCR003','S02','MS','2026-04-02',TRUE,'Enrolled',NULL),
('SUBJ004','SCR004','S02','PK','2026-04-02',TRUE,'Screen Fail','High BP out of range'),
('SUBJ005','SCR005','S03','NT','2026-04-03',TRUE,'Enrolled',NULL);


SELECT * FROM subjects;


INSERT INTO eligibility (subject_id,inc_age_18,inc_htn_dx,inc_sbp_baseline,inc_dbp_baseline,
exc_secondary_htn,exc_pregnant,exc_drug_allergy,exc_malignancy)
VALUES
('SUBJ001',TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE),
('SUBJ002',TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE),
('SUBJ003',TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE),
('SUBJ004',TRUE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE),
('SUBJ005',TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE);


SELECT * FROM eligibility;


INSERT INTO randomisation (subject_id,rand_date,rand_time,rand_number,treat_arm,stratum,rand_status)
VALUES
('SUBJ001','2026-04-01','10:30:00','R001','IIHMRPILL','<160','Randomised'),
('SUBJ002','2026-04-01','11:00:00','R002','Amlodipine','≥160','Randomised'),
('SUBJ003','2026-04-02','09:45:00','R003','IIHMRPILL','<160','Randomised'),
('SUBJ004','2026-04-02','10:15:00','R004','Amlodipine','≥160','Not randomised'),
('SUBJ005','2026-04-03','11:20:00','R005','IIHMRPILL','<160','Randomised');


SELECT * FROM randomisation;



INSERT INTO visits (subject_id,visit_name,visit_date,sbp1,dbp1,sbp2,dbp2,sbp3,dbp3,
sbp_mean,dbp_mean,heart_rate,weight,height,bmi,physical_exam_abnormal,abnormal_desc)
VALUES
('SUBJ001','Baseline','2026-04-01',150,95,148,92,149,93,149,93,72,70,170,24.2,FALSE,NULL),
('SUBJ002','Baseline','2026-04-01',165,100,162,98,164,99,163.7,99,78,75,172,25.3,FALSE,NULL),
('SUBJ003','Baseline','2026-04-02',155,96,153,95,154,94,154,95,76,68,168,24.1,FALSE,NULL),
('SUBJ004','Screening','2026-04-02',185,110,182,108,183,109,183.3,109,80,82,175,26.7,TRUE,'High BP'),
('SUBJ005','Baseline','2026-04-03',145,92,143,90,144,91,144,91,70,65,165,23.9,FALSE,NULL);

SELECT * FROM visits;


INSERT INTO medical_history (subject_id,condition_name,start_date,end_date,ongoing,comments,
hypertension_duration,prior_antihyp,prior_therapy)
VALUES
('SUBJ001','Diabetes','2020-01-01',NULL,TRUE,'Controlled',5,TRUE,'ACE inhibitors'),
('SUBJ002','CAD','2019-05-01',NULL,TRUE,'Stable',6,TRUE,'Beta blockers'),
('SUBJ003','None',NULL,NULL,FALSE,NULL,3,FALSE,NULL),
('SUBJ004','Hypertension','2018-02-01',NULL,TRUE,'Severe',8,TRUE,'Multiple drugs'),
('SUBJ005','Thyroid','2021-03-01',NULL,TRUE,'On meds',4,TRUE,'ARB');

SELECT * FROM medical_history;



INSERT INTO follow_up (subject_id,fu_date,sbp_mean,dbp_mean,heart_rate,
compliance_pct,missed_doses,visit_completed,reason_missed)
VALUES
('SUBJ001','2026-04-21',135,85,70,95,1,TRUE,NULL),
('SUBJ002','2026-04-21',140,88,75,90,2,TRUE,NULL),
('SUBJ003','2026-04-22',138,87,72,92,1,TRUE,NULL),
('SUBJ004','2026-04-22',NULL,NULL,NULL,NULL,NULL,FALSE,'Screen Fail'),
('SUBJ005','2026-04-23',130,82,68,98,0,TRUE,NULL);

SELECT * FROM follow_up;



INSERT INTO adverse_events (subject_id,ae_term,start_date,end_date,ongoing,severity,
action_taken,outcome,sae_flag,hospitalisation,life_threat,death_date,causality,expedited_report)
VALUES
('SUBJ001','Headache','2026-04-05','2026-04-07',FALSE,'Mild','None','Recovered',FALSE,FALSE,FALSE,NULL,'Unlikely',FALSE),
('SUBJ002','Dizziness','2026-04-06','2026-04-08',FALSE,'Moderate','Dose reduced','Recovered',FALSE,FALSE,FALSE,NULL,'Possible',FALSE),
('SUBJ003','Nausea','2026-04-07',NULL,TRUE,'Mild','None','Recovering',FALSE,FALSE,FALSE,NULL,'Possible',FALSE),
('SUBJ004','Severe hypertension','2026-04-02','2026-04-03',FALSE,'Severe','Stopped','Recovered',TRUE,TRUE,FALSE,NULL,'Probable',TRUE),
('SUBJ005','Fatigue','2026-04-08','2026-04-10',FALSE,'Mild','None','Recovered',FALSE,FALSE,FALSE,NULL,'Unrelated',FALSE);




INSERT INTO concomitant_medications (subject_id,drug_name,indication,start_date,end_date,
ongoing,antihypertensive)
VALUES
('SUBJ001','Metformin','Diabetes','2020-01-01',NULL,TRUE,FALSE),
('SUBJ002','Aspirin','Heart','2019-05-01',NULL,TRUE,FALSE),
('SUBJ003','Vitamin D','Supplement','2025-01-01',NULL,TRUE,FALSE),
('SUBJ004','Losartan','Hypertension','2022-01-01',NULL,TRUE,TRUE),
('SUBJ005','Thyroxine','Thyroid','2021-03-01',NULL,TRUE,FALSE);

SELECT * FROM concomitant_medications;


INSERT INTO lab_tests (subject_id,visit,lab_date,creatinine,egfr,potassium,sodium,alt,ast,abnormal_flag,ae_link)
VALUES
('SUBJ001','Screening','2026-04-01',1.0,90,4.2,140,25,22,FALSE,NULL),
('SUBJ002','Screening','2026-04-01',1.2,85,4.5,138,30,28,FALSE,NULL),
('SUBJ003','Screening','2026-04-02',0.9,95,4.1,142,22,20,FALSE,NULL),
('SUBJ004','Screening','2026-04-02',1.5,70,5.2,135,40,38,TRUE,'AE004'),
('SUBJ005','Screening','2026-04-03',1.1,88,4.3,139,27,25,FALSE,NULL);

SELECT * FROM lab_tests;



INSERT INTO trial_status (subject_id,completion_status,discontinuation_reason,
primary_endpoint_available,protocol_deviation,
pd_prohibited_drug,pd_missed_dose,pd_missed_visit,
itt_population,pp_population)
VALUES
('SUBJ001','Completed Week 3',NULL,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE),
('SUBJ002','Completed Week 3',NULL,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE),
('SUBJ003','Completed Week 3',NULL,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE),
('SUBJ004','Early discontinuation','Screen failure',FALSE,TRUE,TRUE,TRUE,TRUE,TRUE,FALSE),
('SUBJ005','Completed Week 3',NULL,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE);

SELECT * FROM trial_status;




