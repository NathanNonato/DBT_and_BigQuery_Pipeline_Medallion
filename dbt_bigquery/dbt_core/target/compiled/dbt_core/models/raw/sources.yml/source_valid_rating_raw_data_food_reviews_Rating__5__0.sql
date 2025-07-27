

    select count(*)
    from `dbtandbigquery-467100`.`raw`.`food_reviews`
    where Rating is not null
      and (Rating < 0 or Rating > 5)

