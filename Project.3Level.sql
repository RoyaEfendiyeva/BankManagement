--Burada isə hazırladığım sorğular olacaq
--7
select * from bank.Cards
select *from bank.CardTypes
Select * from bank.CardsReasons
Select * from bank.CardStatuses
Select * from bank.Currencies
Select * from bank.CurrencyRates
Select * from bank.Employees
--15
Select * from bank.Positions
Select * from bank.Departments
Select * from bank.Cities
Select  PostalCode,Count(*) from bank.Cities group by PostalCode   having Count(PostalCode)>1
Select * from bank.Countries
Select ShortName,Count(*) from bank.Countries group by ShortName having Count(ShortName)>1
Select * from bank.Loans
Select * from bank.LoanTypes
Select * from bank.LoanStatuses
Select * from bank.LoansReasons
Select *from bank.LoanPayments
Select * from bank.LoginCredentials
--Select OTP,Count(*) from bank.LoginCredentials  group by OTP having Count(OTP)>1
Select * from bank.LoginCredentials
Select * from bank.UserSessions
Select * from bank.PayeesTypes
Select * from bank.TransactionsStatus
Select * from bank.SendNotifications
Select * from bank.NotificationsReceipts
--15
Select * from bank.NotificationTypes
Select * from bank.NotificationsMethods
Select * from bank.Deposits
Select * from bank.DepositTypes
Select * from bank.DepositStatuses
Select * from bank.DepositReasons
Select * from bank.TransactionTypes
Select * from bank.Transactions
Select * from bank.Customers
--Select Email,Count(*) from bank.Customers group by Email having Count(Email)>1
--Select PhoneNumber,Count(*) from bank.Customers group by PhoneNumber having Count(PhoneNumber)>1
Select * from bank.CustomerTypes
Select * from bank.Accounts
--Select CustomerID,Count(*) from bank.Accounts Group by CustomerID order by CustomerID
Select * from bank.AccountTypes
Select * from bank.AccountStatuses
Select * from bank.Branches
--Select BranchName,Count(*) from bank.Branches group by BranchName having Count(BranchName)>1
--Select PhoneNumber,Count(*) from bank.Branches group by PhoneNumber having Count(PhoneNumber)>1
--Select BranchName,Count(*) from bank.Branches group by BranchName having Count(BranchName)>1
Select * from bank.TransactionsReasons







--Reports
-------------------------------------------------------------------------------------------------------------------------------------------------

--1. Müştərilərin bütün hesablarının cəmi balansını(USD) tapmaq üçün
   create view bank.Balance as
   (
   select 
   c.FirstName,
   c.LastName,
    SUM(
        CASE WHEN a.CurrencyID = 1 THEN a.CurrentBalance  
             WHEN a.CurrencyID = 2 THEN a.CurrentBalance * cr.USD  
             WHEN a.CurrencyID = 3 THEN a.CurrentBalance * cr.USD  
             WHEN a.CurrencyID = 4 THEN a.CurrentBalance * cr.USD  
             ELSE 0  
        END
    ) AS SumBalanceUSD
FROM 
    bank.Accounts a
JOIN 
    bank.Customers c ON c.CustomerID = a.CustomerID
JOIN 
    bank.CurrencyRates cr ON a.CurrencyID = cr.CurrencyID
GROUP BY 
    c.FirstName,
    c.LastName
)
 select * from 
             bank.Balance 
	   order by 
	         SumBalanceUSD Desc

 --------------------------------------------------------------------------------------------------------------------------------------------------


--2. Ən çox tranzaksiya edən 50 müştərinin siyahısı

select * from bank.Transactions
	 with cte_customer as
	 (
	  select 
	        c.FirstName,
			c.LastName,
			Sum(t.Amount) CustomersAmount
	  from 
	       bank.Transactions t 
	  join 
	       bank.Customers c on c.CustomerID=t.CustomerID 
	  group  by 
	        c.FirstName,c.LastName
	 )
	 select TOP 50 
	             FirstName,
				 LastName, 
				 CustomersAmount 
		   from  
		        cte_customer 
		   order by 
		        CustomersAmount DESC

    ----------------------------------------------------------------------------------------------------------------------------------------------------


--3. Müştəri ilə əlaqəli bütün hesablara baxış. Verilən bir müştərinin adı və soyadı ilə bağlı bütün 
--hesablardan ən az və ən çox balansı(USD) olan hesabları seçirik
WITH cte_AccountBalances AS (
   SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    MAX(
        CASE 
            WHEN a.CurrencyID = 1 THEN a.CurrentBalance
            WHEN a.CurrencyID = 2 THEN a.CurrentBalance * cr.USD
            WHEN a.CurrencyID = 3 THEN a.CurrentBalance * cr.USD
            WHEN a.CurrencyID = 4 THEN a.CurrentBalance * cr.USD
            ELSE a.CurrentBalance * 0  
        END
    ) OVER (PARTITION BY c.CustomerID) AS HighestBalance,
    MIN(
        CASE 
            WHEN a.CurrencyID = 1 THEN a.CurrentBalance
            WHEN a.CurrencyID = 2 THEN a.CurrentBalance * cr.USD
            WHEN a.CurrencyID = 3 THEN a.CurrentBalance * cr.USD
            WHEN a.CurrencyID = 4 THEN a.CurrentBalance * cr.USD
            ELSE a.CurrentBalance * 0  
        END
    ) OVER (PARTITION BY c.CustomerID) AS LowestBalance
FROM
    bank.Customers c
JOIN
    bank.Accounts a ON c.CustomerID = a.CustomerID
JOIN 
    bank.CurrencyRates cr ON a.CurrencyID = cr.CurrencyID AND cr.CurrencyID IN (1, 2, 3, 4)
)
SELECT
    CustomerID,
    FirstName,
    LastName,
    HighestBalance,
    LowestBalance
FROM
    cte_AccountBalances


   ---------------------------------------------------------------------------------------------------------------------

--4. Ən son əməliyyatlar tarixçəsi. Verilən bir hesabın son əməliyyatlarının( 2 əməliyyat) tarixçəsini 
--görmək üçün.
WITH cte_transaction AS (
    SELECT t.TransactionID, 
	       t.TransactionTypeID, 
		   t.DebitAccount, 
		   t.CreditAccount,
           t.Amount, 
		   t.CashbackAmount, 
		   t.CurrencyID AS TransactionCurrencyID,
           t.TransactionDate, 
		   t.MerchantProvider, 
		   t.PayeesTypeID, 
		   t.TransactionFee,
           t.BranchID, 
		   t.ReasonID, 
		   t.StatusID
    FROM 
	     bank.Transactions t
    WHERE 
	     t.DebitAccount = 'ACC1014' or t.CreditAccount='ACC1014'
)
SELECT TOP 2 *
        FROM 
		    cte_transaction
       ORDER BY 
	        TransactionDate DESC;



select * from bank.Transactions where DebitAccount='ACC1014 '
--select AccountNumber,Count(*) from bank.Accounts group by AccountNumber having Count(*)=2
--bunada
-------------------------------------------------------------------------------------------------------------------------------------------------

--5. Müəyyən bir ölkədə yerləşən bütün aktiv bank şöbələri  arasından ən çox müştəriyə 
--sahib olan şöbəsinin adını tapmaq üçün.

select * from bank.Countries
create view bank.viewforBranch as 
(
select 
    BranchName,
	COUNT(cust.CustomerID) countBranch 
from 
     bank.Branches b 
JOIN 
     bank.Cities c on c.CityID=b.CityID
JOIN 
     bank.Countries c2 on c2.CountryID=c.CountryID
JOIN 
     bank.Customers cust ON cust.BranchID = b.BranchID
 WHERE 
        c2.LongName = 'Russia'
group by 
         BranchName
 )
 select Top 1 b.BranchName
 from 
      bank.viewBranch b
 order by 
      countBranch Desc

	  select * from bank.Countries
 ---------------------------------------------------------------------------------------------------------------

--6. Filiallar üzrə kreditlərin orta faiz dərəcəsini və ümumi kredit məbləğini(USD) gətirin
select * from bank.Loans
WITH cte_BranchLoans AS (
    SELECT 
        b.BranchName,
        AVG(l.InterestRate) AS AvgInterestRate,
        SUM(DATEDIFF(MONTH, l.StartDate, l.EndDate) * lp.PaidAmount) AS TotalLoanAmount
    FROM 
        bank.Loans l
    JOIN
        bank.LoanPayments lp ON l.LoanID = lp.LoanID
    JOIN
        bank.Branches b ON l.BranchID = b.BranchID
    GROUP BY 
        b.BranchName
),

cte_BranchLoans2 AS (
    SELECT
        bl.BranchName,
        bl.AvgInterestRate,
        SUM(
            CASE 
                WHEN cr.CurrencyID = 1 THEN bl.TotalLoanAmount 
                WHEN cr.CurrencyID = 2 THEN bl.TotalLoanAmount * cr.USD
                WHEN cr.CurrencyID = 3 THEN bl.TotalLoanAmount * cr.USD
                WHEN cr.CurrencyID = 4 THEN bl.TotalLoanAmount * cr.USD
                ELSE 0  
            END
        ) AS TotalLoanAmountUSD
    FROM  
        cte_BranchLoans bl
    JOIN
        bank.CurrencyRates cr ON cr.CurrencyRateID = 1 
    GROUP BY
        bl.BranchName,
        bl.AvgInterestRate
)

SELECT
    BranchName,
    AvgInterestRate,
    TotalLoanAmountUSD
FROM  
    cte_BranchLoans2;
-------------------------------------------------------------------------------------------------------------------------------------

--7. Son 1 ayda ən çox tranzaksiyada iştirak edən İşçi
WITH cte_EmployeeTransactionCounts AS (
    SELECT
        e.FirstName,
        e.LastName,
        COUNT(t.TransactionID) AS TransactionCount,
        RANK() OVER (ORDER BY COUNT(t.TransactionID) DESC) AS TransactionRank
    from
        bank.Employees e
    join
        bank.Transactions t ON e.EmployeeID = t.CreatedUser or e.EmployeeID = t.UpdatedUser
    group by
        e.FirstName,
        e.LastName
)
--SELECT
--    FirstName,
--    LastName,
--    TransactionCount,
--    CASE 
--	WHEN TransactionRank = 1 THEN 'The best Employee' 
--	ELSE '' 
--    END  AS StatusforPerf
--FROM
--    cte_EmployeeTransactionCounts;
SELECT Top 1
    FirstName,
    LastName,
    TransactionCount
FROM
    cte_EmployeeTransactionCounts
order by 
    TransactionCount DESC;
--------------------------------------------------------------------------------------------------------------------------------------------

--8. Filiallar,Müştərilər,Kreditlər,Ödədikləri məbləğlər(USD ilə),Depositlər haqqında məlumat
select * from bank.LoanPayments
create view bank.VwforReport as
(
  SELECT 
    b.BranchName,
    c.FirstName,
    c.LastName,
    l.LoanID,
    SUM(DATEDIFF(MONTH, l.StartDate, l.EndDate) * lp.PaidAmount-DateDIFF(Month,l.StartDate,GetDate())*lp.PaidAmount) AS TotalPaidAmount,
    d.DepositAmount*cr.USD as AmountwithUSD
FROM 
    bank.Branches b
JOIN 
    bank.Loans l ON b.BranchID = l.BranchID
JOIN 
    bank.Customers c ON l.CustomerID = c.CustomerID
JOIN 
    bank.LoanPayments lp ON l.LoanID = lp.LoanID
JOIN 
    bank.CurrencyRates cr ON l.CurrencyID = cr.CurrencyID
JOIN 
   bank.Deposits d ON c.CustomerID = d.CustomerID
GROUP BY 
    b.BranchName, c.FirstName, c.LastName, l.LoanID, d.DepositAmount*cr.USD
Having
     SUM(DATEDIFF(MONTH, l.StartDate, l.EndDate) * lp.PaidAmount-DateDIFF(Month,l.StartDate,GetDate())+lp.PaidAmount) IS NOT NULL

)
select * from bank.VWforReport

------------------------------------------------------------------------------------------------------------------------------------

--9. Müştərilər üzrə son 10 gündə hesablarında olunan tranzaksiyaların məbləğinə görə ilk 3lük
select * from bank.Transactions

create view  bank.ConvertedT AS (
    SELECT
        c.FirstName,
        c.LastName,
        SUM(
            CASE
                WHEN cr.CurrencyID = 1 THEN t.Amount  -- USD
                WHEN cr.CurrencyID = 2 THEN t.Amount * cr.USD  -- AZN
                WHEN cr.CurrencyID = 3 THEN t.Amount * cr.USD   -- TL
                WHEN cr.CurrencyID = 4 THEN t.Amount * cr.USD -- EURO
             ELSE 0
            END
        ) AS TotalAmountUSD
    FROM 
        bank.Transactions t
    JOIN 
        bank.Accounts a ON t.DebitAccount= a.AccountNumber OR t.CreditAccount = a.AccountNumber
    JOIN 
        bank.Customers c ON a.CustomerID = c.CustomerID
    JOIN 
        bank.CurrencyRates cr ON cr.CurrencyID = a.CurrencyID 
    WHERE 
        t.TransactionDate >= DATEADD(DAY, -10, GETDATE())  
    GROUP BY 
        c.FirstName, c.LastName
)

SELECT 
    FirstName,
    LastName,
    TotalAmountUSD
FROM 
    bank.ConvertedT
ORDER BY 
    TotalAmountUSD DESC
OFFSET 0 ROWS 
FETCH FIRST 3 ROWS ONLY;

---------------------------------------------------------------------------------------------------------------------------------

--10.Mobil tətbiqlərdən ortalama istifadə müddətinə görə hər ölkənin Top 1 şəhəri
WITH SessionDurations AS (
    SELECT 
        lc.UserID,
        lc.UserName,
        us.StartDateTime AS SessionStart,
        us.EndDateTime AS SessionEnd,
        ci.CityName,
        co.LongName AS CountryName,
        DATEDIFF(MINUTE, us.StartDateTime, us.EndDateTime) AS SessionDurationMinutes
    FROM 
        bank.UserSessions us
    JOIN 
        bank.LoginCredentials lc ON us.UserID = lc.UserID
    JOIN 
        bank.Customers cu ON lc.UserID = cu.CustomerID
    JOIN 
        bank.Cities ci ON cu.CityID = ci.CityID
    JOIN 
        bank.Countries co ON ci.CountryID = co.CountryID
    WHERE 
        us.StartDateTime IS NOT NULL
        AND us.EndDateTime IS NOT NULL
)
, RankedSessionDurations AS (
    SELECT 
        CountryName,
        CityName,
        AVG(SessionDurationMinutes) AS AverageSessionDuration,
        ROW_NUMBER() OVER (PARTITION BY CountryName ORDER BY AVG(SessionDurationMinutes) DESC) AS Rank
    FROM 
        SessionDurations
    GROUP BY 
        CountryName, CityName
)
SELECT 
    CountryName,
    CityName AS TopCity,
    AverageSessionDuration AS AverageSessionDurationMinutes
FROM 
    RankedSessionDurations
WHERE 
    Rank = 1;

-------------------------------------------------------------------------------------------------------------------------------------------------

--11.Hər bir müştəri üçün ən son istifadə etdiyi kartın məlumatları
create view bank.LastUsedCards AS (
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        cr.CardNumber,
        cr.LastUsedDate,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY cr.LastUsedDate DESC) AS RowNumber
    FROM
        bank.Customers c
    JOIN
        bank.Cards cr ON c.CustomerID = cr.CustomerID
)
SELECT
    CustomerID,
    FirstName,
    LastName,
    CardNumber,
    LastUsedDate AS LastTransactionDate
FROM
    bank.LastUsedCards
WHERE
    RowNumber = 1;

-----------------------------------------------------------------------------------------------------------------------------
--12.Sorğunuz müştərilərdən bildirişlərə geri dönüş etməyən ve 
--kredit ödəmə tarixini gecikdirənləri tapmaq üçündür. 
WITH DelayedPaymentCustomers AS (
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        l.LoanID,
        lp.PaymentDate,
        DATEDIFF(DAY, lp.PaymentDate, lp.PaidDate) AS DaysLate
    FROM
        bank.Customers c
    JOIN
        bank.Loans l ON c.CustomerID = l.CustomerID
    JOIN
        bank.LoanPayments lp ON lp.LoanID = l.LoanID
    WHERE
        DATEDIFF(DAY, lp.PaymentDate, lp.PaidDate) > 0 
)
SELECT
    dpc.FirstName,
    dpc.LastName,
    SUM(dpc.DaysLate) AS SumDaysLate
FROM
    DelayedPaymentCustomers dpc

WHERE
    EXISTS (
        SELECT 1
        FROM
            bank.SendNotifications sn
        WHERE
            sn.CustomerID = dpc.CustomerID
            AND NOT EXISTS (
                SELECT 1
                FROM
                    bank.NotificationsReceipts nr
                WHERE
                    nr.NotificationID = sn.NotificationID
            )
    )
GROUP BY
    dpc.FirstName,
    dpc.LastName
ORDER BY
    SumDaysLate DESC;
--Select * from bank.Customers  where FirstName='Zoe14' and LastName='Gonzalez14'
--Select * from bank.Countries where ShortName='SSD'
----------------------------------------------------------------------------------------------------------------------------------------------

--13. Hər bir müştəri üçün müxtəlif depozit növləri 
--üzrə ən yüksək məbləğli depozit hesabının,növünün təyini
create view bank.CustomerDepositTypes AS (
    SELECT 
        c.CustomerID,
        c.FirstName,
        c.LastName,
        dt.DepositTypeName,
        SUM(
            CASE 
                WHEN d.CurrencyID = 1 THEN d.DepositAmount 
                WHEN d.CurrencyID = 2 THEN d.DepositAmount * cr.USD  
                WHEN d.CurrencyID = 3 THEN d.DepositAmount * cr.USD  
                WHEN d.CurrencyID = 4 THEN d.DepositAmount * cr.USD  
                ELSE 0  
            END
        ) AS TotalDepositAmountUSD,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY SUM(
            CASE 
                WHEN d.CurrencyID = 1 THEN d.DepositAmount  
                WHEN d.CurrencyID = 2 THEN d.DepositAmount * cr.USD  
                WHEN d.CurrencyID = 3 THEN d.DepositAmount * cr.USD  
                WHEN d.CurrencyID = 4 THEN d.DepositAmount * cr.USD  
                ELSE 0  
            END
        ) DESC) AS forRank
    FROM 
        bank.Customers c
    JOIN 
        bank.Deposits d ON c.CustomerID = d.CustomerID
    JOIN 
        bank.DepositTypes dt ON d.DepositTypeID = dt.DepositTypeID
    JOIN
        bank.CurrencyRates cr ON d.CurrencyID = cr.CurrencyID 
    GROUP BY 
        c.CustomerID, c.FirstName, c.LastName, dt.DepositTypeName
)
SELECT 
    CustomerID,
    FirstName,
    LastName,
    DepositTypeName,
    TotalDepositAmountUSD
FROM 
    bank.CustomerDepositTypes
WHERE 
    forRank = 1
order by 
    TotalDepositAmountUSD desc
----------------------------------------------------------------------------------------------------------------------------------------

--14.Bankın transfer tranzaksiyasında iştirak edən 2 müştərisinin telefon nömrəsinə əsasən onlara 
--göndərilən bildirişlərin növləri və sayları

WITH TransferTransactions AS (
    SELECT 
        t.TransactionID, 
        t.DebitAccount, 
        t.CreditAccount
    FROM 
        bank.Transactions t
    JOIN 
        bank.TransactionTypes tt ON t.TransactionTypeID = tt.TransactionTypeID
    WHERE 
        tt.TransactionTypeName = 'Transfer'
)
SELECT 
    sn.CustomerID,
    tc.PhoneNumber,
	sn.NotificationID,
    nt.NotificationTypeName
FROM 
    bank.Customers tc
JOIN 
    bank.SendNotifications sn ON sn.CustomerID = tc.CustomerID
JOIN 
    bank.NotificationTypes nt ON sn.NotificationTypeID = nt.NotificationTypeID
WHERE 
    tc.PhoneNumber IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM 
		    bank.NotificationsReceipts nr
        WHERE 
		    nr.NotificationID = sn.NotificationID
    )
    AND EXISTS (
        SELECT 1
        FROM 
		    bank.Accounts a1
        JOIN 
		    bank.Accounts a2 ON a1.AccountNumber <> a2.AccountNumber 
		join 
		    bank.Transactions t on a1.AccountNumber = t.DebitAccount 
		and 
		    a2.AccountNumber= t.CreditAccount
    );


------------------------------------------------------------------------------------------------------------------------------------------

/*15.Bu sorğu müəyyən müştərinin kredit hesabları, hesab statusları, 
əməliyyat növləri, məzənnəyə çevrilmiş məbləğ, filial adı və işçi məlumatı ilə əlaqəli əməliyyatları qaytarır. 
Əlavə olaraq, sorğu nəticəsini müştəri soyadı, müştəri adı, hesab nömrəsi və əməliyyat tarixi sırasına görə sıralayır.*/

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    a.AccountNumber,
    a.CurrentBalance,
    ast.AccountStatusName,
    t.TransactionID,
    t.TransactionDate,
    tt.TransactionTypeName,
    COALESCE(bank.ConvertCurrency(t.Amount, 'USD', 'EUR',GetDate()), t.Amount) AS AmountInEUR,
    b.BranchName,
    e.EmployeeID,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName
FROM
    bank.Customers c
JOIN
    bank.Accounts a ON c.CustomerID = a.CustomerID
JOIN
    bank.AccountStatuses ast ON a.AccountStatusID = ast.AccountStatusID
LEFT JOIN
    bank.Transactions t ON a.AccountNumber = t.DebitAccount OR a.AccountNumber = t.CreditAccount
LEFT JOIN
    bank.TransactionTypes tt ON t.TransactionTypeID = tt.TransactionTypeID
JOIN
    bank.Branches b ON c.BranchID = b.BranchID
JOIN
    bank.Employees e ON b.BranchID = e.BranchID
WHERE
    a.AccountTypeID = 1 
    AND ast.IsActive = 1 
	AND e.İsActive= 1
ORDER BY
    c.LastName,
    c.FirstName,
    a.AccountNumber,
    t.TransactionDate;


--------------------------------------------------------------------------------------------------------------------------------------------
select * from bank.Cards
--16.Hər müştəri və kart tipinə əsasən edilən alış verişlərdən sonra borcun son ödənilmə tarixi
WITH CardTransactions AS (
    SELECT
        c.CustomerID,
        cat.CardTypeID,
        t.Amount,
        t.TransactionDate
    FROM
        bank.Customers c
    JOIN
        bank.Cards ca ON c.CustomerID = ca.CustomerID
    JOIN
	   bank.CardTypes cat on cat.CardTypeID=ca.CardTypeID
	JOIN
        bank.Transactions t ON ca.CustomerID= t.CustomerID
    JOIN
        bank.TransactionTypes tt ON t.TransactionTypeID = tt.TransactionTypeID
    WHERE
        tt.TransactionTypeName = 'Purchase' 
),

CardTransactionTotals AS (
    SELECT
        CustomerID,
        CardTypeID,
        SUM(Amount) AS TotalAmount
    FROM
        CardTransactions
    GROUP BY
        CustomerID,
        CardTypeID
)

SELECT
    ctt.CustomerID,
    ctt.CardTypeID,
    ctt.TotalAmount,
    MAX(ct.TransactionDate) AS TransactionDate,
    DATEADD(DAY, 25, MAX(ct.TransactionDate)) AS DueDate  
FROM
    CardTransactionTotals ctt
JOIN
    CardTransactions ct ON ctt.CustomerID = ct.CustomerID AND ctt.CardTypeID = ct.CardTypeID
GROUP BY
    ctt.CustomerID,
    ctt.CardTypeID,
    ctt.TotalAmount
ORDER BY
    ctt.CustomerID,
    ctt.CardTypeID;


---------------------------------------------------------------------------------------------------------------------------
--17.Bu sorğu müştərilərin kredit kartlarından istifadəsinə və kartların cashback statusunun "Təzə", "Köhnə" və ya "Müddəti bitmiş" kimi
--olmasını təyin edir.


select * from bank.Cards
WITH CachedCardUsage AS (
    SELECT
        cs.CustomerID,
        cd.CardNumber,
        cd.ExpiryDate,
        SUM(t.Amount) AS TotalSpent,
        COUNT(t.TransactionID) AS TransactionCount,
        MAX(t.TransactionDate) AS LastTransactionDate
    FROM
        bank.Customers cs
    JOIN
        bank.Cards cd ON cs.CustomerID = cd.CustomerID
    JOIN
        bank.Transactions t ON cd.CustomerID= t.CustomerID
    JOIN
        bank.TransactionTypes tt ON t.TransactionTypeID = tt.TransactionTypeID
    WHERE
        tt.TransactionTypeName = 'Purchase'  
    GROUP BY
        cs.CustomerID, cd.CardNumber, cd.ExpiryDate
)

SELECT
    CustomerID,
    CardNumber,
    ExpiryDate,
    TotalSpent,
    TransactionCount,
    LastTransactionDate,
    CASE
        WHEN DATEDIFF(day, LastTransactionDate, GETDATE()) <= 30 THEN 'Fresh'
        WHEN DATEDIFF(day, LastTransactionDate, GETDATE()) > 30 AND DATEDIFF(day, LastTransactionDate, GETDATE()) <= 90 THEN 'Stale'
        ELSE 'Expired'
    END AS CacheStatus
FROM
    CachedCardUsage
ORDER BY
    CustomerID, CardNumber;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--18.Tranzaksiya tiplərinə görə aqreqat funksiyalar və filtrləmə
select * from bank.Departments
select * from bank.Positions
select * from bank.Employees

create view bank.ViewForTType as(
SELECT
    tt.TransactionTypeName,
    COUNT(t.TransactionID) AS TransactionCount,
    AVG(t.Amount) AS AverageTransactionAmount,
    MAX(t.Amount) AS MaxTransactionAmount,
    MIN(t.Amount) AS MinTransactionAmount
FROM
    bank.TransactionTypes tt
LEFT JOIN 
	bank.Transactions t ON tt.TransactionTypeID = t.TransactionTypeID
LEFT JOIN 
    bank.PayeesTypes p on p.PayeesTypeID=t.PayeesTypeID where p.PayeesTypeName Like '%Institution'
GROUP BY  
    tt.TransactionTypeName
Having 
   COUNT(t.TransactionID) IS NOT NULL );

Select * from bank.ViewForTType

--------------------------------------------------------------------------------------------------------------------------------

--19.Hal-hazırda sistemdə aktiv olan user'lar
select * from bank.UserSessions
select * from bank.LoginCredentials
SELECT 
     us.SessionID, 
	 lc.UserName, 
	 us.StartDateTime, 
	 lc.Password, 
	 us.DeviceInfo,
	 c.FirstName+' '+c.LastName as [Name]
FROM 
      bank.UserSessions us
  JOIN 
      bank.LoginCredentials lc ON us.UserID = lc.UserID
  JOIN 
      bank.Customers c on c.CustomerID=us.UserID
WHERE 
     us.EndDateTime IS NULL and lc.UserName is NOT NULL;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--20.Hər bir Departamentin ən çox işçi olan Pozisiyası
   WITH PositionCounts AS (
    SELECT 
	      PositionID, 
		  COUNT(EmployeeID) AS EmployeeCount
    FROM 
	      bank.Employees
    GROUP BY 
	      PositionID
),
DepartmentPositions AS (
    SELECT 
	      p.PositionID, 
		  p.PositionName, 
		  p.DepartmentID, 
		  pc.EmployeeCount
    FROM 
	      bank.Positions p
     JOIN 
	      PositionCounts pc ON p.PositionID = pc.PositionID
),
MaxDepartmentPositions AS (
    SELECT 
	       DepartmentID, 
		   MAX(EmployeeCount) AS MaxEmployeeCount
    FROM 
	       DepartmentPositions
    GROUP BY 
	       DepartmentID
)
SELECT TOP 1
       d.DepartmentName, 
	   dp.PositionName, 
	   Max(dp.EmployeeCount) AS EmployeeCount
FROM 
       MaxDepartmentPositions mdp
JOIN 
       DepartmentPositions dp ON mdp.DepartmentID = dp.DepartmentID --AND mdp.MaxEmployeeCount = dp.EmployeeCount
JOIN 
       bank.Departments d ON dp.DepartmentID = d.DepartmentID

group by 
       d.DepartmentName, 
	   dp.PositionName
order by
      Max(dp.EmployeeCount) DESC







---------------------------------------------------------------------------------------------------------------------------------------------------------
