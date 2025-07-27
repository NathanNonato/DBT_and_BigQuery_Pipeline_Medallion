
    
    

with dbt_test__target as (

  select recipe_id as unique_field
  from `dbtandbigquery-467100`.`marts`.`mart_review_metrics`
  where recipe_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


