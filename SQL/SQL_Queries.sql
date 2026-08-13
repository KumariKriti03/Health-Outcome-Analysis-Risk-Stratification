CREATE DATABASE healthcare;

USE healthcare;

CREATE TABLE Diagnoses(
	DiagnosisID INT PRIMARY KEY,
    DiagnosisName VARCHAR (255)
);

CREATE TABLE Outcomes(
	OutcomeID INT PRIMARY KEY,
    OutcomeName VARCHAR(255)
);

CREATE TABLE Patients(
	PatientID INT PRIMARY KEY,
    Name VARCHAR(255),
    Age INT,
    Gender CHAR(1),
    DiagnosisID INT,
    AdmissionDate DATE,
    DischargeDate DATE,
    OutcomeID INT,
    TreatmentCost DECIMAL(10,2),
    FOREIGN KEY (DiagnosisID) REFERENCES diagnoses(DiagnosisID),
    FOREIGN KEY (OutcomeID) REFERENCES Outcomes(OutcomeID)
);

CREATE TABLE Labs(
	LabID INT PRIMARY KEY,
    PatientID INT,
    TestName VARCHAR(255),
    Result DECIMAL(10,2),
    NormalRange VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES patients(PatientID)
);

SELECT * FROM Patients;
SELECT * FROM Outcomes;
SELECT * FROM Diagnoses;
SELECT * FROM Labs;

-- Retrieve Detailed Patient Lab History
SELECT p.patientID, p.name, d.diagnosisname, o.outcomename, l.testname, l.result, l.normalrange
FROM patients p
JOIN diagnoses d ON p.diagnosisID = d.diagnosisID
JOIN outcomes o ON p.outcomeID = o.outcomeID
JOIN labs l ON p.patientID = l.patientID
ORDER BY p.patientID, l.testname;

-- Average Lab Results By Diagnosis
SELECT d.diagnosisname, l.testname, AVG(l.result) AS AvgResult
FROM patients p
JOIN diagnoses d ON p.diagnosisID = d.diagnosisID
JOIN labs l ON p.patientID = l.patientID
GROUP BY d.diagnosisname, l.testname;

-- Count of Abnormal lab Results
SELECT p.patientID, p.name, COUNT(*) AS Abnormalcount 
FROM patients p
JOIN labs l ON p.patientID = l.patientID
WHERE (l.Testname = 'Blood Sugar' AND l.result > 120) 
OR (l.Testname = 'Cholestrol' AND l.result > 200)
OR (l.Testname = 'Hemoglobin' AND l.result > 13)
GROUP BY p.patientID, p.name
ORDER BY Abnormalcount DESC;

-- Diagnoses With Highest Treatment Costs
SELECT d.diagnosisname, SUM(p.treatmentcost) as TotalCost
FROM patients p
JOIN diagnoses d ON p.diagnosisID = d.diagnosisID
GROUP BY d.diagnosisname
ORDER BY TotalCost DESC;

-- Patients at Risk by Age and Gender
SELECT p.patientID, p.name, p.age, d.diagnosisname, o.outcomename
FROM patients p
JOIN diagnoses d ON p.diagnosisID = d.diagnosisID
JOIN outcomes o ON p.outcomeID = o.outcomeID
WHERE p.age > 65 AND o.outcomename != 'Recovered';

-- Lab Trends over Time for a specific Patient
SELECT l.testname, l.result, p.admissiondate
FROM labs l
JOIN patients p ON l.patientID = p.patientID
WHERE p.patientID in (2,4,6,8,10,12)
ORDER BY p.admissiondate;

-- Distribution of Outcomes by Diagnosis
SELECT d.diagnosisname, o.outcomename, COUNT(*) AS OutcomeCount
FROM patients p
JOIN diagnoses d ON p.diagnosisID = d.diagnosisID
JOIN outcomes o ON p.outcomeID = o.outcomeID 
GROUP BY d.diagnosisname, o.outcomename
ORDER BY d.diagnosisname, o.outcomename DESC;
