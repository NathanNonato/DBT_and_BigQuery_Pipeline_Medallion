
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

    select count(*)
    from `dbtandbigquery-467100`.`staging`.`stg_food_reviews`
    where rating is not null
      and (rating < 1 or rating > 5)


  
  
      
    ) dbt_internal_test