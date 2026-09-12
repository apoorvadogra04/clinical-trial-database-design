# Clinical Trial Database Design (eCRF Schema)

MBA-HA coursework project designing a relational database that models an electronic case report form (eCRF) system for a clinical trial, similar to structures used in real clinical data management.

## Objective
Design a normalized, relational schema capable of tracking a patient's full journey through a clinical trial — from screening through follow-up — while preserving data integrity via foreign key relationships.

## Tools
MySQL

## Structure
10 linked tables, each representing a stage or data domain of the trial:
- `subjects` — screening and enrollment status
- `eligibility` — inclusion/exclusion criteria checks
- `randomisation` — treatment arm assignment
- `visits` — vitals recorded at each visit (blood pressure, heart rate, BMI)
- `medical_history` — pre-existing conditions
- `follow_up` — post-randomization tracking and medication compliance
- `adverse_events` — safety events, including serious adverse event (SAE) flags
- `concomitant_medications` — other medications taken during the trial
- `lab_tests` — lab values (creatinine, eGFR, electrolytes, liver enzymes) with abnormal flagging
- `trial_status` — completion status and protocol deviation tracking

All patient-linked tables reference `subjects` via `subject_id` as a foreign key, ensuring every record traces back to a single enrolled participant.

## Key Design Decisions
- Used `BOOLEAN` fields for all yes/no clinical flags (consent, eligibility criteria, SAE indicators) to keep the schema queryable and analysis-ready
- Separated `adverse_events` from `trial_status` so safety reporting and protocol-deviation tracking can be queried independently — reflecting how real trial data management separates safety and operational data

## Files
- `eCRF_clinical_trial_schema.sql` — full schema (CREATE TABLE statements) with sample data (INSERT statements) for 5 mock subjects
