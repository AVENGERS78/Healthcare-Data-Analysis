# 🏥 Healthcare Data Analysis | SQL Server & Power BI

## 📌 Project Overview

This project focuses on analyzing healthcare data to understand hospital operations, patient admissions, financial performance, and laboratory test results.

Using **SQL Server** and **Power BI**, I performed data cleaning, exploratory data analysis, and business analysis to transform raw healthcare data into meaningful insights.

The project demonstrates practical skills in SQL querying, data quality management, analytical functions, healthcare data analysis, and interactive dashboard development.

## 🎯 Project Objectives

- Analyze patient demographics and admission patterns
- Understand hospital revenue and billing performance
- Identify high-revenue departments and doctors
- Analyze patient readmissions and diagnosis frequency
- Evaluate payment modes and insurance providers
- Monitor laboratory test abnormalities
- Explore city-wise patient distribution and revenue

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL Server | Data cleaning and analysis |
| SQL | Querying and business analysis |
| Power BI | Interactive dashboard and visualization |
| Power Query | Data transformation |
| DAX | Measures and analytical calculations |

## 🗂️ Dataset Overview

The healthcare database contains the following tables:

| Table | Description |
|---|---|
| `patients` | Patient information, demographics, age, city, and registration date |
| `admissions` | Admission details, diagnosis, doctor, department, and discharge information |
| `doctors` | Doctor information, specialization, and department |
| `departments` | Hospital department details |
| `billing` | Consultation fees, treatment costs, medicine costs, room charges, and total bills |
| `lab_results` | Laboratory test names and result status |

## 🧹 Data Cleaning & Preparation

Before performing the analysis, I conducted data quality checks and cleaning operations using SQL.

The cleaning process included:

- Checking record counts across healthcare tables
- Identifying missing phone numbers, emails, and gender values
- Checking duplicate doctor records
- Standardizing patient registration dates into a date format
- Cleaning inconsistent city names
- Identifying invalid discharge dates
- Handling doctor IDs that did not exist in the doctors table
- Validating total billing amounts against individual bill components
- Standardizing inconsistent gender values

These steps helped improve data consistency and reliability before analysis.

## 📊 SQL Analysis

### 1. Hospital Overview

- Total unique patients
- Total admissions
- Total hospital revenue
- Average revenue per patient

### 2. Revenue & Financial Analysis

- Monthly hospital revenue
- Month-over-month revenue growth
- Department-wise revenue and patient count
- Revenue by payment mode
- Revenue contribution percentage by payment mode
- Insurance provider revenue
- Average insurance claim value

### 3. Doctor & Department Analysis

- Top 10 doctors by revenue generated
- Patients treated by each doctor
- Average revenue per patient
- Doctor ranking within each department
- Department-wise financial performance

### 4. Patient & Admission Analysis

- Patient age-group segmentation
- Top 10 diagnoses by frequency
- Average treatment cost by diagnosis
- Average hospital stay by diagnosis
- Patient readmission analysis within 30 days
- Readmission rate calculation

### 5. Laboratory Test Analysis

- Total tests performed
- Abnormal test count
- Abnormality rate by test type
- Laboratory tests ranked by abnormality rate

### 6. City-wise Analysis

- Top 10 cities by hospital revenue
- Unique patients by city
- Total admissions by city
- Average revenue by city

## 📈 Power BI Dashboard

The Power BI report provides interactive visualizations to explore healthcare performance across different analytical areas.

The report focuses on:

- Healthcare overview and key performance indicators
- Patient and admission analysis
- Billing and revenue analysis
- Department and doctor performance
- Payment mode and insurance analysis
- Laboratory test results and abnormality analysis

Interactive filters and visualizations help users explore the healthcare data and identify patterns in hospital operations.

## 💡 Key Business Questions

This project helps answer questions such as:

- How many unique patients and admissions does the hospital have?
- How does hospital revenue change over time?
- Which departments generate the highest revenue?
- Which doctors generate the most revenue?
- Which diagnoses occur most frequently?
- What percentage of patients are readmitted within 30 days?
- Which payment modes contribute the most revenue?
- Which insurance providers have the highest billed amounts?
- Which laboratory tests have the highest abnormality rate?
- Which cities contribute the most patients and revenue?

## 📁 Project Files

| File | Description |
|---|---|
| `healthcare.sql` | SQL Server data cleaning and analysis queries |
| `Health_care report.pbix` | Interactive Power BI healthcare report |

## 🚀 How to Use This Project

1. Download the SQL script from this repository.
2. Open SQL Server Management Studio.
3. Execute the SQL script against the healthcare database.
4. Review the data cleaning and analysis queries.
5. Download the Power BI report.
6. Open the `.pbix` file using Power BI Desktop.
7. Explore the report and interact with the available visualizations.

## 📌 Conclusion

This project demonstrates the practical application of SQL Server and Power BI in healthcare data analytics.

Through data cleaning, SQL-based business analysis, and interactive dashboard development, the project explores patient admissions, hospital revenue, doctor performance, billing patterns, and laboratory test results.

It reflects my ability to work with structured data, perform analytical queries, and develop business intelligence reports to support data-driven decision-making.

---

**Author:** Saurabh Kumar Singh

**Role:** Data Analyst

**Skills:** SQL Server | Power BI | Data Cleaning | Data Analysis | Data Visualization | Business Intelligence
