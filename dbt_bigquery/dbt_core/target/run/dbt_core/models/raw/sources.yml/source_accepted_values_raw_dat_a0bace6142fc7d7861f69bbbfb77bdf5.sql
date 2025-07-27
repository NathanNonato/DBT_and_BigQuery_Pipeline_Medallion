
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        Rating as value_field,
        count(*) as n_records

    from `dbtandbigquery-467100`.`raw`.`food_reviews`
    group by Rating

)

select *
from all_values
where value_field not in (
    '0','1','2','3','4','5'
)



  
  
      
    ) dbt_internal_test