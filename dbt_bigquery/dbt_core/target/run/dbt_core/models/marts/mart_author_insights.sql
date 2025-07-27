
  
    

    create or replace table `dbtandbigquery-467100`.`marts`.`mart_author_insights`
      
    
    

    
    OPTIONS()
    as (
      -- 🥇 MARTS LAYER (Gold)
-- Author Insights - Reviewer Behavior and Patterns



WITH author_behavior AS (
    SELECT
        author_id,
        author_name,
        
        -- Activity Metrics
        COUNT(*) AS total_reviews_written,
        COUNT(DISTINCT recipe_id) AS unique_recipes_reviewed,
        
        -- Rating Metrics
        ROUND(AVG(rating), 2) AS avg_rating_given,
        STDDEV(rating) AS rating_variability,
        
        -- Rating Patterns
        COUNTIF(rating = 5) AS five_star_reviews,
        COUNTIF(rating = 1) AS one_star_reviews,
        ROUND(COUNTIF(rating >= 4) / COUNT(*) * 100, 1) AS positive_review_rate,
        
        -- Text Metrics
        ROUND(AVG(review_length), 0) AS avg_review_length,
        MAX(review_length) AS longest_review,
        COUNTIF(has_review_text) AS reviews_with_text,
        
        -- Temporal Metrics
        MIN(submitted_at) AS first_review_date,
        MAX(submitted_at) AS latest_review_date,
        DATE_DIFF(MAX(submitted_at), MIN(submitted_at), DAY) AS reviewing_span_days,
        
        -- Activity Categorization
        CASE 
            WHEN COUNT(*) >= 50 THEN 'Super Active'
            WHEN COUNT(*) >= 20 THEN 'Very Active'
            WHEN COUNT(*) >= 10 THEN 'Active'
            WHEN COUNT(*) >= 5 THEN 'Moderate'
            ELSE 'Casual'
        END AS activity_level,
        
        -- Behavior Categorization
        CASE 
            WHEN AVG(rating) >= 4.5 THEN 'Optimistic'
            WHEN AVG(rating) <= 2.5 THEN 'Critical'
            WHEN STDDEV(rating) <= 0.5 THEN 'Consistent'
            ELSE 'Varied'
        END AS rating_behavior,
        
        -- Metadata
        CURRENT_TIMESTAMP() AS calculated_at
        
    FROM `dbtandbigquery-467100`.`staging`.`stg_food_reviews`
    WHERE author_id IS NOT NULL
      AND rating IS NOT NULL
    GROUP BY author_id, author_name
)

SELECT *
FROM author_behavior
WHERE total_reviews_written >= 3  -- Only authors with at least 3 reviews
ORDER BY total_reviews_written DESC
    );
  