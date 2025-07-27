

    select count(*)
    from `dbtandbigquery-467100`.`staging`.`stg_food_reviews`
    where rating is not null
      and (rating < 1 or rating > 5)

