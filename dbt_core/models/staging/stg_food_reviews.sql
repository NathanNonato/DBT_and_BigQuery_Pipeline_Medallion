-- 🥈 STAGING LAYER (Silver)
-- Responsible for: Cleaning, Standardization, Renaming, Validation

{{ config(
    materialized='table',
    description='Clean and standardized review data'
) }}

WITH source_data AS (
    SELECT *
    FROM {{ source('raw_data', 'food_reviews') }}
),

cleaned_data AS (
    SELECT
        -- Standardized IDs
        ReviewId AS review_id,
        RecipeId AS recipe_id,
        AuthorId AS author_id,
        
        -- String cleaning
        TRIM(AuthorName) AS author_name,
        TRIM(Review) AS review_text,
        
        -- Rating standardization
        CASE 
            WHEN Rating BETWEEN 1 AND 5 THEN Rating
            WHEN Rating = 0 THEN NULL  -- Rating 0 is invalid
            ELSE NULL
        END AS rating,
        
        -- Date standardization
        CASE 
            WHEN DateSubmitted IS NOT NULL 
            THEN CAST(DateSubmitted AS TIMESTAMP)
            ELSE NULL
        END AS submitted_at,
        
        CASE 
            WHEN DateModified IS NOT NULL 
            THEN CAST(DateModified AS TIMESTAMP)
            ELSE NULL
        END AS modified_at,
        
        -- Calculated fields
        LENGTH(TRIM(Review)) AS review_length,
        
        -- Quality flags
        CASE 
            WHEN TRIM(Review) = '' OR Review IS NULL THEN FALSE
            ELSE TRUE
        END AS has_review_text,
        
        -- Metadata
        CURRENT_TIMESTAMP() AS loaded_at
        
    FROM source_data
)

SELECT *
FROM cleaned_data
-- Filter only valid reviews
WHERE review_id IS NOT NULL
  AND recipe_id IS NOT NULL 