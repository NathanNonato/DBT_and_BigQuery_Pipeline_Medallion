
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select author_id
from `dbtandbigquery-467100`.`marts`.`mart_author_insights`
where author_id is null



  
  
      
    ) dbt_internal_test