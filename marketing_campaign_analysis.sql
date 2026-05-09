SELECT COUNT(*) AS total_rows
FROM marketing_campaign;

SELECT * FROM projects.marketing_campaign;

# Best Performing Platform
SELECT 
    campaign_type,
    SUM(revenue) AS total_revenue,
    SUM(acquisition_cost) AS total_spend,
    ROUND(SUM(revenue) / SUM(acquisition_cost), 2) AS return_on_ad_spend
FROM projects.marketing_campaign
GROUP BY campaign_type
ORDER BY return_on_ad_spend DESC;


#worst campaign memory drain
SELECT 
    campaign_id,
    campaign_type,
    company,
    customer_segment
    acquisition_cost,
    revenue,

    ROUND(revenue/acquisition_cost,2) AS roas

FROM projects.marketing_campaign
ORDER BY roas ASC
LIMIT 10;


# audience analysis
SELECT 
	campaign_type,
	avg(revenue),
    target_audience

FROM projects.marketing_campaign
GROUP BY target_audience,campaign_type;


# Rank Campaigns by Performance
SELECT 
    campaign_id,
    campaign_type,
    company,
    revenue,

    RANK() OVER(
         partition by campaign_type 
         ORDER BY revenue DESC
    ) AS campaign_rank

FROM projects.marketing_campaign;


# revenue contribuition by company
SELECT 
	company,
    SUM(revenue) AS revenue,

    ROUND(
        SUM(revenue)*100.0/
        SUM(SUM(revenue)) OVER(),
    2) AS contribution_pct

FROM projects.marketing_campaign
GROUP BY company
order by revenue desc;


#Best Platform by ROI
SELECT
    channel_used,
    ROUND(SUM(revenue),2) AS total_revenue,
    ROUND(SUM(acquisition_cost),2) AS total_spend,
    ROUND(SUM(revenue)/SUM(acquisition_cost),2) AS roas
FROM projects.marketing_campaign
GROUP BY channel_used
ORDER BY roas DESC;


#Conversion Funnel Analysis
#Which channels get traffic but fail to convert?
SELECT channel_used,ROUND(AVG(conversion_rate),5) AS AVERAGE_CVR
FROM marketing_campaign
GROUP BY channel_used
order by AVERAGE_CVR DESC;


#Audience Segment Performance(MEN AUDIENCE GIGVING HIGHEST REVENUE)
SELECT
    target_audience,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(AVG(conversion_rate)*100,2) AS avg_conversion_rate
FROM projects.marketing_campaign
GROUP BY target_audience
ORDER BY revenue DESC;


#Campaign Fatigue Analysis
#Q-Do longer campaigns perform worse?
#A-INDEED LONGER CAMPAIGN HAS AVG PERFORMANCE/ENGAGEMENT COMPARED TO OTHER CAMPAIGN DURATION
SELECT
    duration,
    ROUND(AVG(roi),2) AS avg_roi,
    ROUND(AVG(engagement_score),2) AS avg_engagement
FROM projects.marketing_campaign
GROUP BY duration
ORDER BY duration DESC;


#Top Performing Campaign per Channel
WITH ranked_campaigns AS (

SELECT
    campaign_id,
    company,
    channel_used,
    revenue,

    ROW_NUMBER() OVER(
        PARTITION BY channel_used
        ORDER BY revenue DESC
    ) AS rn

FROM projects.marketing_campaign
)

SELECT *
FROM ranked_campaigns
WHERE rn =1;

