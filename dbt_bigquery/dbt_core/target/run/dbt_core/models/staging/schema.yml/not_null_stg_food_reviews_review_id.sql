
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select review_id
from `dbtandbigquery-467100`.`staging`.`stg_food_reviews`
where review_id is null



  
  
      
    ) dbt_internal_test