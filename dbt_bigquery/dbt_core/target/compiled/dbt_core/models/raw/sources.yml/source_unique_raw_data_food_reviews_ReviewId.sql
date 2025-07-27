
    
    

with dbt_test__target as (

  select ReviewId as unique_field
  from `dbtandbigquery-467100`.`raw`.`food_reviews`
  where ReviewId is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


