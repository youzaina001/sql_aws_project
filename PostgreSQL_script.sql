create schema linkedin;

DROP TABLE IF EXISTS linkedin.jobs_postings CASCADE;
DROP TABLE IF EXISTS linkedin.salaries CASCADE;
DROP TABLE IF EXISTS linkedin.benefits CASCADE;
DROP TABLE IF EXISTS linkedin.companies CASCADE;
DROP TABLE IF EXISTS linkedin.skills CASCADE;
DROP TABLE IF EXISTS linkedin.employee_counts CASCADE;
DROP TABLE IF EXISTS linkedin.job_skills CASCADE;
DROP TABLE IF EXISTS linkedin.industries CASCADE;
DROP TABLE IF EXISTS linkedin.job_industries CASCADE;
DROP TABLE IF EXISTS linkedin.company_specialities CASCADE;
DROP TABLE IF EXISTS linkedin.company_industries CASCADE;

create table linkedin.jobs_postings
(
job_id bigint,
company_id integer,
title varchar,
description varchar,
max_salary float,
med_salary float,
min_salary float,
pay_period varchar,
formatted_work_type varchar,
location varchar,
applies integer,
original_listed_time float,
remote_allowed integer,
views integer,
job_posting_url varchar,
application_url varchar,
application_type varchar,
expiry float,
closed_time float,
formatted_experience_level varchar,
skills_desc varchar,
listed_time float,
posting_domain varchar,
sponsored integer,
work_type varchar,
currency varchar,
compensation_type varchar,
scraped integer
);

select aws_s3.table_import_from_s3
(
'linkedin.jobs_postings',
'',
'(format csv, header)',
'aws-sql-project',
'job_postings.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.jobs_postings;


create table linkedin.salaries
(
salary_id integer,
job_id bigint,
max_salary float,
med_salary float,
min_salary float,
pay_period varchar,
currency varchar,
compensation_type varchar
);

select aws_s3.table_import_from_s3
(
'linkedin.salaries',
'',
'(format csv, header)',
'aws-sql-project',
'salaries.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.salaries;


create table linkedin.benefits
(
job_id bigint,
inferred integer,
type varchar
);

select aws_s3.table_import_from_s3
(
'linkedin.benefits',
'',
'(format csv, header)',
'aws-sql-project',
'benefits.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.benefits;


create table linkedin.companies
(
company_id bigint,
name varchar,
description varchar,
company_size integer,
country varchar,
state varchar,
city varchar,
zip_code varchar,
adress varchar,
url varchar
);

select aws_s3.table_import_from_s3
(
'linkedin.companies',
'',
'(format csv, header)',
'aws-sql-project',
'companies.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.companies;


create table linkedin.skills
(
skill_abr varchar,
skill_name varchar
);

select aws_s3.table_import_from_s3
(
'linkedin.skills',
'',
'(format csv, header)',
'aws-sql-project',
'skills.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.skills;


create table linkedin.employee_counts
(
company_id integer,
employee_count integer,
follower_count bigint,
time_recorded float
);

select aws_s3.table_import_from_s3
(
'linkedin.employee_counts',
'',
'(format csv, header)',
'aws-sql-project',
'employee_counts.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.employee_counts;


create table linkedin.job_skills
(
job_id bigint,
skill_abr varchar
);

select aws_s3.table_import_from_s3
(
'linkedin.job_skills',
'',
'(format csv, header)',
'aws-sql-project',
'job_skills.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.job_skills;


create table linkedin.industries
(
industry_id bigint,
industry_name varchar
);

select aws_s3.table_import_from_s3
(
'linkedin.industries',
'',
'(format csv, header)',
'aws-sql-project',
'industries.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.industries;


create table linkedin.job_industries
(
job_id bigint,
industry_id integer
);

select aws_s3.table_import_from_s3
(
'linkedin.job_industries',
'',
'(format csv, header)',
'aws-sql-project',
'job_industries.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.job_industries;


create table linkedin.company_specialities
(
company_id bigint,
speciality varchar
);

select aws_s3.table_import_from_s3
(
'linkedin.company_specialities',
'',
'(format csv, header)',
'aws-sql-project',
'company_specialities.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.company_specialities;


create table linkedin.company_industries
(
company_id bigint,
industry varchar
);

select aws_s3.table_import_from_s3
(
'linkedin.company_industries',
'',
'(format csv, header)',
'aws-sql-project',
'company_industries.csv',
'eu-west-1',
'aws-access-key',
'aws-secret-key'
);

select * from linkedin.company_industries;

SELECT title, COUNT(*) AS count
FROM linkedin.jobs_postings
GROUP BY title
ORDER BY count DESC
LIMIT 10;


SELECT title, MAX(max_salary) AS max
FROM linkedin.jobs_postings
where max_salary is not null
GROUP BY title
ORDER BY max DESC
LIMIT 1;

SELECT company_size, COUNT(*) AS job_count
FROM linkedin.companies AS companies
JOIN linkedin.jobs_postings AS jobs_postings ON companies.company_id = jobs_postings.company_id
where company_size is not null
GROUP BY company_size;

SELECT industry_name, COUNT(*) AS job_count
FROM linkedin.industries AS industries
JOIN linkedin.job_industries AS job_industries ON industries.industry_id = job_industries.industry_id
JOIN linkedin.jobs_postings AS job_postings ON job_industries.job_id = job_postings.job_id
GROUP BY industry_name;

SELECT formatted_work_type, COUNT(*) AS job_count
FROM linkedin.jobs_postings
GROUP BY formatted_work_type;