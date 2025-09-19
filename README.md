# TSA Claims Analysis (2002–2017)

This project was completed as part of the final case study for the [SAS Programmer Professional Certificate](https://www.coursera.org/professional-certificates/sas-programming) on Coursera.

The dataset includes claims submitted to the TSA between 2002 and 2017. This analysis focuses on data preparation, cleanup, and reporting using SAS Studio.

---

## Files Included

| File Name           | Description                                  |
|--------------------|----------------------------------------------|
| `case_study.sas`   | Complete SAS code used in this analysis       |
| `ClaimReports.pdf` | Final exported report using ODS PDF           |
| `outputs/`         | Charts, screenshots, and tables   |

---

## Methods and Techniques

- **Data Import:** `PROC IMPORT`, `GUESSINGROWS=MAX` for full read-in
- **Data Cleaning:** `IF`, `LABEL`, `FORMAT`, date handling, missing value treatment
- **Data Wrangling:** Duplicate removal, sorting, creating new variables
- **Data Analysis:** `PROC FREQ`, `PROC MEANS`, `PROC SGPLOT`
- **Report Export:** `ODS PDF` to create a formal report

---

## Sample Insights

- Claims peaked in certain years and declined later.
- Many claims had missing or invalid dates.
- A large proportion of claims were processed at airports (Claim Site).
- Several entries required review due to date issues.

---

## Tools Used

- SAS Studio (via Coursera)
- ODS PDF Reporting

---

## Author

**Jameson Ellis**  
M.S. in Data Science Candidate  
UNC Charlotte  
www.linkedin.com/in/jamesonellis112269144
