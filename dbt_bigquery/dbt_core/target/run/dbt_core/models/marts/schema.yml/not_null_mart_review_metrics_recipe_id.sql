
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select recipe_id
from `dbtandbigquery-467100`.`marts`.`mart_review_metrics`
where recipe_id is null



  
  
      
    ) dbt_internal_test