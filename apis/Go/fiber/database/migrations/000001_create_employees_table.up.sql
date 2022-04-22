BEGIN;
CREATE TABLE IF NOT EXISTS employee(
                                    employee_id      uuid         not null
                                        constraint employee_pk
                                            primary key,
                                    first_name   varchar(200),
                                    last_name    varchar(200) not null,
                                    email        varchar(200) not null,
                                    phone_number varchar(15)  not null,
                                    hire_date    date         not null,
                                    salary       numeric
    );
COMMIT;
