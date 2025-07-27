
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select Rating
from `dbtandbigquery-467100`.`raw`.`food_reviews`
where Rating is null



  
  
      
    ) dbt_internal_test