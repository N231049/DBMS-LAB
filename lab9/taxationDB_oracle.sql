CREATE TABLE taxpayer (
    taxpayer_id   NUMBER NOT NULL,
    pan_number    VARCHAR2(10) NOT NULL,
    full_name     VARCHAR2(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    occupation    VARCHAR2(150),
    annual_income NUMBER(12,2) NOT NULL,
    email         VARCHAR2(100),
    is_active     NUMBER(1),
    phone_number  VARCHAR2(15),

    CONSTRAINT pk_taxpayer
        PRIMARY KEY (taxpayer_id),

    CONSTRAINT uq_taxpayer_pan
        UNIQUE (pan_number),

    CONSTRAINT uq_taxpayer_email
        UNIQUE (email)
);

CREATE TABLE income_category (
    category_id   NUMBER NOT NULL,
    category_name VARCHAR2(50) NOT NULL,
    description   VARCHAR2(200) NOT NULL,
    taxable       NUMBER(1) NOT NULL,

    CONSTRAINT pk_income_category
        PRIMARY KEY (category_id),

    CONSTRAINT uq_income_category_name
        UNIQUE (category_name)
);

CREATE TABLE financial_year (
    year_id          NUMBER NOT NULL,
    year_label       VARCHAR2(9) NOT NULL,
    start_date       DATE NOT NULL,
    end_date         DATE NOT NULL,
    filing_deadline  DATE,
    is_current       NUMBER(1) NOT NULL,

    CONSTRAINT pk_financial_year
        PRIMARY KEY (year_id),

    CONSTRAINT uq_financial_year_label
        UNIQUE (year_label)
);

CREATE TABLE income_record (
    income_id      NUMBER NOT NULL,
    taxpayer_id    NUMBER NOT NULL,
    income_source  VARCHAR2(100) NOT NULL,
    amount         NUMBER(12,2) NOT NULL,
    received_date  DATE NOT NULL,
    remarks        VARCHAR2(200),
    category_id    NUMBER NOT NULL,
    year_id        NUMBER NOT NULL,

    CONSTRAINT pk_income_record
        PRIMARY KEY (income_id),

    CONSTRAINT fk_income_taxpayer
        FOREIGN KEY (taxpayer_id)
        REFERENCES taxpayer(taxpayer_id),

    CONSTRAINT fk_income_category
        FOREIGN KEY (category_id)
        REFERENCES income_category(category_id),

    CONSTRAINT fk_income_year
        FOREIGN KEY (year_id)
        REFERENCES financial_year(year_id)
);

INSERT INTO taxpayer
    (taxpayer_id, pan_number, full_name, date_of_birth,
     occupation, annual_income, email, is_active, phone_number)
VALUES
    (101, 'ABCDE1234F', 'Test', DATE '1995-06-15',
     'Software Engineer', 950000.00, 'ravi.kumar@example.com', 1, NULL),
    (102, 'BCDEF2345G', 'Priya Sharma', DATE '1992-11-22',
     'Doctor', 120000.00, 'priya.sharma@example.com', 1, NULL),
    (103, 'cdefg3456h', 'Arjun Reddy', DATE '1988-03-10',
     'Bussiness Owner', 180000.00, 'arjun.reddy@example.com', 1, NULL),
    (104, 'DEFGH4567J', 'Sneha Patel', DATE '1988-08-05',
     'Teacher', 620000.00, 'sneha.patel.example.com', 1, NULL),
    (105, 'EFGHJ5678K', 'Kiran Rao', DATE '1990-01-18',
     'Software Consultant', 750000.00, 'kiran.rao@example.com', 1, NULL),
    (106, 'FGHJK6789L', 'Meera Singh', DATE '1985-12-30',
     'Consultant', 150000.00, 'meera.singh@example.com', 1, NULL);

SELECT * FROM taxpayer;

INSERT INTO income_category
    (category_id, category_name, description, taxable)
VALUES
    (1, 'Salary', 'Income receives from employment', 1),
    (2, 'Bussiness', 'Income earned from business activities', 1),
    (3, 'House Property', 'Income recived from property or rent', 1),
    (4, 'Capital Gains', 'Income from transfer of eligible assests', 1),
    (5, 'Other Sources', 'Income such as bank interest', 1),
    (6, 'Agricultural Income', 'Incomefrom eligible agricultural activities', 0),
    (7, 'Rental Income', 'Income receives from tenants', 1);
     
SELECT * FROM income_category;

INSERT INTO financial_year
    (year_id, year_label, start_date, end_date, filing_deadline, is_current)
VALUES
    (1, '2020-2021', DATE '2020-04-01', DATE '2021-03-31',
     DATE '2021-07-31', 0),
    (2, '2021-2022', DATE '2021-04-01', DATE '2022-03-31',
     DATE '2022-07-31', 0),
    (3, '2022-2023', DATE '2022-04-01', DATE '2023-03-31',
     DATE '2023-07-31', 0),
    (4, '2023-2024', DATE '2023-04-01', DATE '2024-03-31',
     DATE '2023-07-31', 0),
    (5, '2024-2025', DATE '2024-04-01', DATE '2025-03-31',
     DATE '2025-07-31', 0),
    (6, '2025-2026', DATE '2025-04-01', DATE '2026-03-31',
     DATE '2026-07-31', 1);

SELECT * FROM financial_year;

INSERT INTO income_record
    (income_id, taxpayer_id, income_source, amount, received_date, remarks, category_id, year_id)
VALUES
    (1001, 101, 'TechNova Sloutions', 76000.00, DATE '2026-03-31',
     NULL, 1, 6),
    (1003, 103, 'Reddy Enterprises', 1800000.00, DATE '2026-03-31',
     NULL, 2, 6),
    (1004, 104, 'Sunrise School', 620000.00, DATE '2026-03-31',
     NULL, 1, 6),
     (1005, 105, 'Web Design Projects', 750000.00, DATE '2026-03-31',
     NULL, 2, 6),
    (1006, 106, 'Professional Consulting', 1500000.00, DATE '2026-03-31',
     NULL, 2, 6),
      (1007, 101, 'villa', 850000.00, DATE '2025-03-31',
     NULL, 3, 5),
     (1008, 102, 'house', 1200000.00, DATE '2025-03-31',
     NULL, 3, 5),
    (1009, 103, 'Reddy Enterprises', 1800000.00, DATE '2024-03-31',
     NULL, 4, 4),
      (1010, 104, 'Sunrise School', 620000.00, DATE '2024-03-31',
     NULL, 4, 4),
    (1011, 105, 'Web Design Projects', 750000.00, DATE '2023-03-31',
     NULL, 5, 3),
   (1012, 106, 'Professional Consulting', 1500000.00, DATE '2023-03-31',
     NULL, 5, 3),
     (1014, 101, 'Combined Test Income', 700000.00, DATE '2026-10-13',
     'Commit test', 1, 6),
    (1015, 101, 'Savepoint Income', 650000.00, DATE '2026-10-13',
     'Savepoint test', 1, 6),
    (1016, 101, 'Integrated Income', 500000.00, DATE '2026-10-13',
     'Integrated test', 1, 6),
    (1017, 101, 'Annual Income', 750000.00, DATE '2026-10-13',
     'Annual income test', 1, 6),
     (2002, 101, 'combined test income', 700000.00, DATE '2026-10-13',
     'commit test', 1, 6),
     (2003, 101, 'intergrated Income', 500000.00, DATE '2026-10-14',
     'integrated test', 1, 6),
      (9995, 101, 'Annual Income', 76000.00, DATE '2026-10-14',
     'TCL + DCL test', 1, 1),
     (9996, 101, 'Data Entry Test', 45000.00, DATE '2026-10-14',
     'Testing minimum privilege', 1, 1),
     (9997, 101, 'Officer Test Income', 50000.00, DATE '2026-10-14',
     'Testing INSERT after UPDATE revoke', 1, 1),
     (9999, 101, 'DCL test income', 600100.00, DATE '2026-10-14',
     'insert privilege test', 3, 2);

SELECT * FROM income_record;