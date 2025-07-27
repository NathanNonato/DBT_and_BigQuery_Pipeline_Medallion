
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ReviewId
from `dbtandbigquery-467100`.`raw`.`food_reviews`
where ReviewId is null



  
  
      
    ) dbt_internal_test