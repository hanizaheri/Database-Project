-- create 'user' table
create table user(
    name varchar(512),
    last_name varchar(512),
    gender varchar(6),
    date_of_birth date,
    special_disease varchar(3),
    ID char(10) primary key ,
    password varchar(512),
    creation_date timestamp
);

-- create constraint on 'user' table
DELIMITER $$
CREATE TRIGGER check_user BEFORE INSERT ON user FOR EACH ROW
BEGIN
    IF NEW.gender not in ('male','female')THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'gender is not correct';
    END IF;

    IF NEW.special_disease not in ('yes','no')THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'disease is not correct';
    END IF;

    IF length(NEW.ID) <> 10 or new.id RLIKE '[a-zA-Z]' or NEW.ID RLIKE '[!@#$%a^&*()-_+=.,;:]'THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'not suitable ID';
    END IF;

    if new.password not rlike '[0-9]' or new.password not rlike '[a-z]' or length(new.password) < 8 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'not suitable password';
    else
        set new.password = md5(new.password);
    end if;
END; $$

-- create 'doctor' table
create table doctor(
    ID char(10) primary key ,
    doctor_ID char(5) not null unique ,
    foreign key(ID) references user(ID) on delete cascade
);

-- create constraint on 'doctor' table
DELIMITER $$
CREATE TRIGGER check_doctor BEFORE INSERT ON doctor FOR EACH ROW
BEGIN
    IF length(NEW.doctor_ID) <> 5 or NEW.doctor_ID RLIKE '[a-zA-Z]' or NEW.doctor_ID RLIKE '[!@#$%a^&*()-_+=.,;:]'THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'not suitable doctor_ID';
    END IF;
END; $$

-- create 'nurse' table
create table nurse(
    ID char(10) primary key ,
    nurse_ID char(8) not null unique ,
    level varchar(10),
    foreign key(ID) references user(ID) on delete cascade
);

-- create constraint on 'nurse' table
DELIMITER $$
CREATE TRIGGER check_nurse BEFORE INSERT ON nurse FOR EACH ROW
BEGIN
    IF NEW.level not in ('matron','supervisor','nurse','practical') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'not suitable level';
    END IF;

    IF length(NEW.nurse_ID) <> 8 or NEW.nurse_ID RLIKE '[a-zA-Z]' or NEW.nurse_ID RLIKE '[!@#$%a^&*()-_+=.,;:]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'not suitable nurse ID';
    END IF;
END; $$

-- create 'tag_feature' table
create table tag_feature(
     tag float PRIMARY KEY,
     ID char(10),
     login_time timestamp,
     foreign key (ID) references user(ID) on delete cascade
);

-- create 'brand' table
create table brand(
    name varchar(512) primary key,
    dose int,
    gap_days int ,
    doctor_ID char(10),
    foreign key (doctor_ID) references doctor(ID) on delete cascade
);

-- create 'centre' table
create table center(
    name varchar(512) primary key,
    address varchar(512)
);

-- create 'brands_in_centre' table
create table brands_in_centre(
    centre_name varchar(512),
    brand_name varchar(512),
    foreign key (centre_name) references center(name),
    foreign key (brand_name) references brand(name),
    primary key (centre_name,brand_name)
);

-- create 'vial' table
create table vial(
    serial_number varchar(512) primary key,
    brand varchar(512),
    production_date date,
    dose int,
    foreign key (brand) references brand (name)
);

-- create constraint on 'vial' table
DELIMITER $$
CREATE TRIGGER check_vial before INSERT ON vial FOR EACH ROW
BEGIN
    if new.serial_number RLIKE '[a-zA-Z]' or NEW.serial_number RLIKE '[!@#$%a^&*()-_+=.,;:]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'not suitable serial number';
    end if;
END; $$

-- create 'injection' table
create table injection (
    vaccinated_ID char(10),
    center varchar(512),
    serial varchar(512),
    date date,
    nurse_ID char(8),
    foreign key (vaccinated_ID) references user (ID) on delete cascade ,
    foreign key (center) references center (name),
    foreign key (serial) references vial (serial_number),
    foreign key (nurse_ID) references nurse (nurse_ID) on delete cascade,
    primary key (vaccinated_id, serial)
);

-- create 'rate' table
create table rate(
    rate int,
    vaccinated_ID char(10) ,
    centre varchar(512),
    foreign key (vaccinated_ID) references user(ID),
    foreign key (centre) references center(name),
    primary key (vaccinated_ID, centre)
);

-- create constraint on 'rate' table
DELIMITER $$
CREATE TRIGGER check_rate before INSERT ON rate FOR EACH ROW
BEGIN
    if new.rate > 5 or NEW.rate < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'not suitable rate';
    end if;
END; $$

-- create constraint on update on changing password
DELIMITER $$
CREATE TRIGGER check_pass_change before update ON user FOR EACH ROW
BEGIN
    if new.password not rlike '[0-9]' or new.password not rlike '[a-z]' or length(new.password) < 8 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'not suitable password';
    else
        set new.password = md5(new.password);
    end if;
END; $$

-- insert user function
delimiter $$
create procedure user_reg (
	in name varchar(512),
    in last_name varchar(512),
    in gender varchar(6),
    in date_of_birth date,
    in special_disease varchar(3),
    in ID char(10) ,
    in password varchar(512),
    in creation_date timestamp
)
begin
	insert into user values(name,last_name,gender,date_of_birth,special_disease,ID,password,creation_date);
end $$
delimiter ;

-- insert doctor function
delimiter $$
create procedure doctor_reg (
	in name varchar(512),
    in last_name varchar(512),
    in gender varchar(6),
    in date_of_birth date,
    in special_disease varchar(3),
    in ID char(10) ,
    in password varchar(512),
    in creation_date timestamp,
    in doctor_ID char(5)
)
begin
	insert into user values(name,last_name,gender,date_of_birth,special_disease,ID,password,creation_date);
	insert into doctor values (ID,doctor_ID);
end $$
delimiter ;

-- insert nurse function
delimiter $$
create procedure nurse_reg (
	in name varchar(512),
    in last_name varchar(512),
    in gender varchar(6),
    in date_of_birth date,
    in special_disease varchar(3),
    in ID char(10) ,
    in password varchar(512),
    in creation_date timestamp,
    in nurse_ID char(8) ,
    in level varchar(10)
)
begin
	insert into user values(name,last_name,gender,date_of_birth,special_disease,ID,password,creation_date);
	insert into nurse values (ID,nurse_ID,level);
end $$
delimiter ;

-- create login check function
delimiter $$
create procedure successful_login (
    in ID char(10) ,
    in password varchar(512)
)
begin
	if not exists(select * from user where user.ID = ID and user.password = md5(password)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'incorrect username or password';
    end if;
end $$
delimiter ;

-- define the type of the user
delimiter $$
create procedure user_type (
    in ID char(10),
    out type varchar(10)
)
begin
	if exists(select * from doctor where doctor.ID = ID ) THEN
        set type = 'doctor';
    end if;
	if exists(select * from nurse where nurse.ID = ID ) THEN
       set type = 'nurse';
	else
	    set type = 'user';
	end if;
end $$
delimiter ;

-- insert brand function
delimiter $$
create procedure insert_brand (
    in name varchar(512),
    in dose int,
    in gap_days int ,
    in doctor_ID char(10)
)
begin
	insert into brand values(name, dose, gap_days, doctor_ID);
end
$$
delimiter ;

-- insert centre function
delimiter $$
create procedure create_centre (
    in name varchar(512),
    in address varchar(512)
)
begin
	insert into center values(name,address) ;
end
$$
delimiter ;

-- delete a user
delimiter $$
create procedure delete_user (
    in id varchar(10)
)
begin
    delete from user where user.id = id;
end $$
delimiter ;

-- define the level of the nurse
delimiter $$
create procedure nurse_type (
    in ID char(10),
    out type varchar(10)
)
begin
	if exists(select * from nurse where nurse.ID = ID and nurse.level = 'matron') THEN
        set type = 'matron';
	else
	    set type = 'not matron';
	end if;
end $$
delimiter ;

-- create vial function
delimiter $$
create procedure create_vial (
    in serial_number varchar(512),
    in brand varchar(512),
    in production_date date,
    in dose int
)
begin
    insert into vial values (serial_number,brand,production_date,dose);
end $$
delimiter ;

-- create new injection function
delimiter $$
create procedure new_injection (
    vaccinated_ID char(10),
    center varchar(512),
    serial varchar(512),
    date date,
    nurse_ID char(8)
)
begin
    if not exists(select * from user where user.id = vaccinated_id) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'this user is not registered';
    elseif (select count(injection.serial) from injection where serial = injection.serial) > (select finalproject.vial.dose from vial where serial_number = serial) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'can not inject more than dose numbers';
    elseif exists(select * from injection where vaccinated_ID = injection.vaccinated_ID) THEN
        if (select finalproject.vial.brand from vial where serial_number = serial) <>
           (select finalproject.vial.brand from vial where serial_number = (select finalproject.injection.serial from injection where injection.vaccinated_ID = vaccinated_ID)) THEN
           SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'next doses must be like the first one';
        end if;
    else
        insert into injection values (vaccinated_id,center,serial,date,nurse_ID);
    end if;
end
$$
delimiter ;

-- get the information of the user
delimiter $$
create procedure getInfo (
	in id varchar(10)
)
begin
    select * from user where user.id = id;
end
$$
delimiter ;

-- create get information function
delimiter $$
create procedure getInfo (
	in id varchar(10)
)
begin
    select * from user where user.id = id;
end
$$
delimiter ;

-- change password
delimiter $$
create procedure changePassword (
	in user_id varchar(10),
	in newPassword varchar(64)
)
begin
    update user
    set
        password = newPassword
    where user.id = user_id;
end
$$
delimiter ;

-- rate to the vaccination centre function
delimiter $$
create procedure rate_center (
	in id varchar(10),
	in center varchar(64),
	in rate int
)
begin
    if not exists(select * from injection where injection.vaccinated_id = id and injection.center = center)then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'can not rate';
    elseif exists(select * from rate where finalproject.rate.vaccinated_ID = id and finalproject.rate.centre = center) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'you rated before';
    else
        insert into rate values (rate, id, center);
    end if;
end
$$
delimiter ;

-- get the rate of vaccination centres
delimiter $$
create procedure view_rate (

)
begin
    select centre, round(avg(rate), 1)
        as rate_avg from rate group by centre order by rate_avg desc limit 5 ;
end
$$
delimiter ;

-- get the number of injections per day
delimiter $$
create procedure view_number_of_injections (
)
begin
    select injection.date, count(injection.vaccinated_id)
    from injection group by date order by date desc;
end
$$
delimiter ;










