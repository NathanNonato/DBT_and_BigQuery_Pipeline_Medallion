
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

    select count(*)
    from `dbtandbigquery-467100`.`raw`.`food_reviews`
    where Rating is not null
      and (Rating < 0 or Rating > 5)


  
  
      
    ) dbt_internal_test