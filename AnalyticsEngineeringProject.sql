





-- Drop the table if it exists
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE tushare_express CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
       IF SQLCODE != -942 THEN -- Error code for "table does not exist"
           RAISE;
       END IF;
END;
/


-- Create the tushare_express table with necessary constraints
CREATE TABLE tushare_express (
   ts_code VARCHAR2(20),
   ann_date VARCHAR2(8),
   end_date VARCHAR2(8),
   revenue NUMBER(18,2),
   operate_profit NUMBER(18,2),
   total_profit NUMBER(18,2),
   n_income NUMBER(18,2),
   total_assets NUMBER(18,2),
   total_hldr_eqy_exc_min_int NUMBER(18,2),
   diluted_roe NUMBER(10,6),
   yoy_net_profit NUMBER(18,2),
   perf_summary VARCHAR2(500),
   created_at TIMESTAMP,
   CONSTRAINT uq_ts_code_end_date UNIQUE (ts_code, end_date)
);


-- Insert sample data (you can extend this with more entries for better testing)
INSERT INTO tushare_express VALUES
('600519.SH', '20240301', '20231231', 120000, 45000, 47000, 35000, 900000, 500000, 15.2, 5.5, 'Strong growth', TO_TIMESTAMP('2024-03-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO tushare_express VALUES
('601398.SH', '20240302', '20231231', 300000, 110000, 115000, 90000, 1500000, 800000, 12.8, 6.2, 'Stable performance', TO_TIMESTAMP('2024-03-02 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));


COMMIT;


-- Enhanced SQL Transformation Query
WITH import AS (
   SELECT * FROM (
       SELECT
           ts_code,
           ann_date,
           end_date,
           revenue,
           operate_profit, total_profit,
           n_income, total_assets,
           total_hldr_eqy_exc_min_int,
           diluted_roe, yoy_net_profit,
           perf_summary, created_at,
           CASE WHEN YOY_NET_PROFIT > 6 THEN 'OK' ELSE 'BAD' END AS Tema,
           ROW_NUMBER() OVER (PARTITION BY ts_code, end_date ORDER BY created_at DESC) AS rn
       FROM tushare_express
   ) WHERE rn = 1
)
,


-- SELECT * FROM import;


formatted AS (
   SELECT
       ts_code,
       TO_DATE(ann_date, 'YYYYMMDD') AS ann_date,
       TO_DATE(end_date, 'YYYYMMDD') AS end_date,
       ROUND(revenue, 2) AS revenue,
       ROUND(operate_profit, 2) AS operate_profit,
       ROUND(total_profit, 2) AS total_profit,
       ROUND(n_income, 2) AS n_income,
       ROUND(total_assets, 2) AS total_assets,
       ROUND(total_hldr_eqy_exc_min_int, 2) AS total_hldr_eqy_exc_min_int,
       ROUND(diluted_roe, 6) AS diluted_roe,
       ROUND(yoy_net_profit, 2) AS yoy_net_profit,
       perf_summary,
       TEMA,
       created_at
   FROM import
),




unit_converted AS (
   SELECT
       ts_code,
       end_date,
       diluted_roe / 100 AS diluted_roe -- Converting percentage to decimal
   FROM formatted
),


financial_ratios AS (
   SELECT
       ts_code,
       end_date,
       revenue / NULLIF(total_assets, 0) AS asset_turnover,  -- Calculate Asset Turnover
       operate_profit / NULLIF(total_assets, 0) AS return_on_assets, -- Calculate ROA
       operate_profit / NULLIF(total_hldr_eqy_exc_min_int, 0) AS return_on_equity -- Calculate ROE
   FROM formatted
),


final AS (
   SELECT
       f.ts_code AS stock_code,
       f.ann_date AS ann_date,
       f.end_date AS end_date,
       f.revenue AS total_revenue,
       f.operate_profit AS operate_profit,
       f.n_income AS net_income,
       f.total_assets AS total_assets,
       f.total_hldr_eqy_exc_min_int AS total_hldr_eqy_exc_min_int,
       u.diluted_roe AS diluted_roe,
       f.yoy_net_profit AS net_income_yoy,
       f.perf_summary AS perf_summary,
       fr.asset_turnover,
       fr.return_on_assets,
       fr.return_on_equity,
       f.TEMA


   FROM formatted f
   LEFT JOIN unit_converted u
       ON f.ts_code = u.ts_code AND f.end_date = u.end_date
   LEFT JOIN financial_ratios fr
       ON f.ts_code = fr.ts_code AND f.end_date = fr.end_date
)


SELECT * FROM final;








