-- 🥇 MARTS LAYER (Gold)
-- Review Metrics by Recipe - Ready for BI/Dashboards



WITH recipe_metrics AS (
    SELECT
        recipe_id,
        
        -- Volume Metrics
        COUNT(*) AS total_reviews,
        COUNT(DISTINCT author_id) AS unique_reviewers,
        
        -- Rating Metrics
        ROUND(AVG(rating), 2) AS avg_rating,
        MIN(rating) AS min_rating,
        MAX(rating) AS max_rating,
        
        -- Rating Distribution
        COUNTIF(rating = 5) AS rating_5_count,
        COUNTIF(rating = 4) AS rating_4_count,
        COUNTIF(rating = 3) AS rating_3_count,
        COUNTIF(rating = 2) AS rating_2_count,
        COUNTIF(rating = 1) AS rating_1_count,
        
        -- Text Metrics
        ROUND(AVG(review_length), 0) AS avg_review_length,
        COUNTIF(has_review_text) AS reviews_with_text,
        ROUND(COUNTIF(has_review_text) / COUNT(*) * 100, 1) AS text_completion_rate,
        
        -- Temporal Metrics
        MIN(submitted_at) AS first_review_date,
        MAX(submitted_at) AS latest_review_date,
        DATE_DIFF(MAX(submitted_at), MIN(submitted_at), DAY) AS review_span_days,
        
        -- Popularity Categorization
        CASE 
            WHEN COUNT(*) >= 100 THEN 'High'
            WHEN COUNT(*) >= 50 THEN 'Medium'
            WHEN COUNT(*) >= 10 THEN 'Low'
            ELSE 'Very Low'
        END AS popularity_category,
        
        -- Quality Categorization
        CASE 
            WHEN AVG(rating) >= 4.5 THEN 'Excellent'
            WHEN AVG(rating) >= 4.0 THEN 'Very Good'
            WHEN AVG(rating) >= 3.5 THEN 'Good'
            WHEN AVG(rating) >= 3.0 THEN 'Fair'
            ELSE 'Poor'
        END AS quality_category,
        
        -- Metadata
        CURRENT_TIMESTAMP() AS calculated_at
        
    FROM `dbtandbigquery-467100`.`staging`.`stg_food_reviews`
    WHERE rating IS NOT NULL
    GROUP BY recipe_id
)

SELECT *
FROM recipe_metrics
ORDER BY total_reviews DESC