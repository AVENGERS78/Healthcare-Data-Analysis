create database Health_care;
use health_care;

select * from doctors;
select * from billing;
select * from admissions;
select * from departments
select * from patients;
select * from lab_results;

-----------  Data Cleaning ---------
select 'Departments' as Table_name, count(*) as row_number from departments
union all 
select 'Doctors', count(*) from doctors
union all 
select 'Patients', count(*) from patients
union all
select 'Admissions', count(*) from admissions
union all
select 'Billing', count(*) from billing
union all 
select 'Lab_results', count(*) from lab_results;

---------- Checkig null value ----------
select 
   sum ( case when phone = '' or phone is null then 1  else 0 end) as null_phone,
   sum (case when email = '' or email is null then 1 else 0 end) as null_email,
   sum (case when gender = '' or gender is null then 1 else 0 end) as null_gender
from doctors;

--- discovering inconsistent gender values
select gender, count(*) as counts from doctors group by gender;

----- checking duplicates values
select first_name, last_name, department_id, count(*) from doctors 
group by first_name, last_name, department_id having count(*) > 1;

------------- cleaning patients column ---------
---- Adding column   
alter table patients add clean_reg_date date;

update patients
set clean_reg_date = case
when registration_date like '____-__-__'
then try_convert (date,Registration_date, 23) --- 23 means --- yyyy/mm/dd
when registration_date like '__-__-____'
then try_convert (date,registration_date, 105) --- 105 ---> dd/mm/yyyy
when registration_date like '__/__/____'
then try_convert (date,registration_date, 103)  --- 103---> dd/mm/yyyy
else null
end;
select * from patients;

select distinct city from patients;

update patients set city = 'Bangalore' where city = 'Bengaluru';
update patients set city = 'Mumbai' where city = 'Bombay';
update patients set city = 'Kolkata' where city = 'Calcutta';

-------------- Cleaning admission table ----------
select admission_id,  admission_date, discharge_date from admissions 
where discharge_date != '' and discharge_date < admission_date;

update admissions set discharge_date = null where discharge_date != '' and discharge_date < admission_date;

------- Finding admission with non existence doctor_id ------
select admission_id, doctor_id from admissions
where doctor_id not in ( select doctor_id from doctors);

update admissions set doctor_id = 26 
where doctor_id not in ( select doctor_id from doctors);

---- Mismatch in bill total ----
select bill_id, consultation_fee + treatment_cost + medicine_cost + room_charges as calcualted_bill, total_bill,
total_bill - (consultation_fee + treatment_cost + medicine_cost + room_charges) as Difference_bill
from billing where total_bill != consultation_fee + treatment_cost + medicine_cost + room_charges;

update billing set total_bill = consultation_fee + treatment_cost + medicine_cost + room_charges
where total_bill != consultation_fee + treatment_cost + medicine_cost + room_charges;

-----Analysis part ------
/*
1. Hospital dashboard summary
2. Monthly revenue
3. month over month revenue growth
4. Department wise revenue, patients count
5. Top doctors by revenue generating
6. Doctors rank within each department
7. Aggrigating patient on the basis of their age
8. Top diagnosis 
9. Patients readmission analysis
*/
---- 1. total patients, total revenue, average revenue per patient---
select count(distinct a.patient_id) as total_patient, count(*) as total_admission,
round(sum(b.total_bill), 2) as total_revenue,
round(sum(b.total_bill)/count(distinct a.patient_id), 2) as average_revenue_per_patient
from admissions a join billing b 
on a.admission_id = b.admission_id 
where a.status = 'Discharged';

---- Monthly trend ----
select FORMAT(a.admission_date, 'yyyy-MM') as month, 
count(distinct a.admission_id) as total_admission,
round(sum(b.total_bill), 2) as Monthly_revenue
from admissions a join billing b 
on a.admission_id = b.admission_id where a.status = 'Discharged'
group by FORMAT(a.admission_date, 'yyyy-MM')
order by month;

----- Month over month revenue growth----
with monthly_rev as (
select FORMAT(a.admission_date, 'yyyy-MM') as month, 
round(sum(b.total_bill), 2) as revenue
from admissions a 
join billing b 
on a.admission_id = b.admission_id where a.status = 'Discharged'
group by FORMAT(a.admission_date, 'yyyy-MM'))
select month, revenue,
LAG(revenue) over (order by month) as prev_month_rev,
ROUND((revenue - LAG(revenue) over (order by month))*100.0/
nullif(
LAG(revenue) over (order by month),0),2) as month_growth_pct
from monthly_rev order by month;

-----DOCTORS AND DEPARMENTS ANALYSIS--------

---dept wise revenue and patient count----
select d.department_name, count(distinct a.patient_id) as unique_patient,
count(*) as total_admission,
round(sum(b.total_bill), 2) as dept_revenue,
ROUND(AVG(b.total_bill), 2) as avg_bill_per_pat
from departments d 
join admissions a 
on d.department_id = a.department_id
join billing b
on a.admission_id = b.admission_id
where a.status = 'discharged'
group by d.department_name order by dept_revenue desc;

----- Top doctors by revenue generated----
select top 10 
CONCAT(d.first_name, ' ' , d.last_name) as doctors_name, d.specialization, 
count(distinct a.patient_id) as pat_treated,
ROUND(sum(b.total_bill),2 ) as total_revenue,
ROUND(sum(b.total_bill)*1.0/
nullif(COUNT(distinct a.patient_id),0),2) as avg_rev_per_pat
from doctors d 
join admissions a 
on d.doctor_id = a.doctor_id
join billing b 
on a.admission_id = b.admission_id
where a.status = 'discharged'
group by d.doctor_id, d.first_name, d.last_name, d.specialization
order by total_revenue desc;

----Ranking the Doctors by each Department ----
with doc_rev as (
select d.department_name, dr.doctor_id , 
CONCAT(dr.first_name, ' ' , dr.last_name) as doct_name,
count(distinct a.patient_id) as pat_treated,
ROUND(sum(b.total_bill),2 ) as total_revenue
from doctors dr
join departments d 
on dr.department_id = d.department_id
join admissions a 
on dr.doctor_id = a.doctor_id
join billing b 
on a.admission_id = b.admission_id
where a.status = 'discharged' 
group by d.department_name, dr.doctor_id, dr.first_name, dr.last_name)
select department_name, doct_name, pat_treated, total_revenue,
rank() over (partition by department_name order by total_revenue desc) as rank_in_dept
from doc_rev;

----------PATIENT ANALYSIS---------
-- Patient readmission analysis
-- Top 10 diagonasis by frequency 
-- Patient segementation by age group

select distinct gender from patients;
update patients set gender = 'Male' where gender = 'M';
update patients set gender = 'Female' where gender = 'f';

-- Patient readmission analysis

with pat_visit as (
select patient_id, admission_id, admission_date,
lag(discharge_date) over (partition by patient_id order by admission_date,admission_id) as prev_discharge
from admissions where status = 'discharged'
and discharge_date is not null)
select COUNT(*) as total_discharged,
sum(case 
when prev_discharge is not null
and DATEDIFF(day,prev_discharge,admission_date)
between 0 and 30
then 1 
else 0
end) as readmission_30days,
round(sum(case 
when prev_discharge is not null
and DATEDIFF(day,prev_discharge,admission_date)
between 0 and 30
then 1 
else 0
end)*100.0/nullif (count(*),0),2) as readmission_rate_pat
from pat_visit;

-- Top 10 diagonasis by frequency 
select top 10 a.diagnosis,
COUNT( distinct a.admission_id) as total_cases,
ROUND(avg(cast(b.total_bill as decimal(18,2))),2) as avg_treatment_cost,
round(avg(case 
when a.discharge_date is not null then cast(datediff(day,a.admission_date,a.discharge_date)
as decimal(10,2)) else null end),1) as avg_stay_day
from admissions a join billing b
on a.admission_id = b.admission_id
where a.status = 'discharged'
group by a.diagnosis
order by total_cases desc;

-- Patient segementation by age group
SELECT
    CASE
        WHEN age BETWEEN 0 AND 17 THEN 'Children'
        WHEN age BETWEEN 18 AND 29 THEN 'Young Adults'
        WHEN age BETWEEN 30 AND 44 THEN 'Adults'
        WHEN age BETWEEN 45 AND 59 THEN 'Middle-Aged'
        WHEN age >= 60 THEN 'Senior Citizens'
        ELSE 'Unknown'
    END AS age_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY
    CASE
        WHEN age BETWEEN 0 AND 17 THEN 'Children'
        WHEN age BETWEEN 18 AND 29 THEN 'Young Adults'
        WHEN age BETWEEN 30 AND 44 THEN 'Adults'
        WHEN age BETWEEN 45 AND 59 THEN 'Middle-Aged'
        WHEN age >= 60 THEN 'Senior Citizens'
        ELSE 'Unknown'
    END
ORDER BY total_patients DESC;

--- BILLING ANALYSIS AND FINANCIAL -----
select b.payment_mode,
count(*) as bill_count,
ROUND(sum(b.total_bill),2) as total_revenue,
ROUND(sum(b.total_bill)*100.0/
sum(sum(b.total_bill)) over(), 2
) as rev_pct
from billing b join admissions a 
on b.admission_id = a.admission_id
where a.status = 'discharged' and b.payment_mode is not null
group by b.payment_mode
order by total_revenue desc;

---- Insurance provider revenue analysis ----------
select b.insurance_provider,
count(*) as Claims,
ROUND(sum(b.total_bill),2) as total_billed,
ROUND(avg(b.total_bill),2) as Avg_claim_value
from billing b join admissions a 
on b.admission_id = a.admission_id
where a.status = 'discharged' and b.insurance_provider != 'None' and b.insurance_provider is not null
group by b.insurance_provider
order by total_billed desc;

--- Test Analysis ------
select test_name, count(*) as total_tests,
sum(case when result_status = 'abnormal' then 1 else 0 end) as Abnormal_count,
ROUND(sum(case when result_status = 'abnormal' then 1 else 0 end )*100.0/ count(*),2)
as Abnormality_rate_pct
from lab_results
where result_status in ('abnormal','normal')
group by test_name
order by Abnormality_rate_pct desc;

---- City wise Revenue and Patient Distrubution -----
select top 10 p.city,
count(distinct p.patient_id) as total_patient,
count(distinct a.admission_id) as total_admission,
round(sum(b.total_bill),2) as total_revenue,
round(avg(b.total_bill),2) as Avg_revenue
from patients p 
join admissions a 
on p.patient_id = a.patient_id
join billing b
on b.admission_id = a.admission_id
where a.status = 'discharged'
group by p.city
order by total_revenue desc;