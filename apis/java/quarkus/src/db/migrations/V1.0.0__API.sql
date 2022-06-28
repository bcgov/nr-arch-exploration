CREATE TABLE IF NOT EXISTS EMPLOYEE
(
    EMPLOYEE_ID      uuid         not null
        constraint EMPLOYEE_PK
            primary key,
    FIRST_NAME   varchar(200),
    LAST_NAME    varchar(200) NOT NULL,
    EMAIL        varchar(200) not null,
    PHONE_NUMBER varchar(15)  not null,
    HIRE_DATE    date         not null,
    SALARY       numeric
);
