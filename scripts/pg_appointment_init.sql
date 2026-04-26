\c db_appointment_management;

create extension if not exists "pgcrypto";

create table if not exists tb_user_account (
    id uuid default gen_random_uuid() primary key,
    document_number varchar(20) not null unique,
    full_name varchar(120) not null,
    email varchar(120) not null unique,
    password_hash varchar(250) not null,
    enabled boolean not null default true,
    enabled_for_appointment boolean not null default true,
    created_at timestamp default current_timestamp,
    updated_at timestamp
);

create table if not exists tb_patient (
    id uuid default gen_random_uuid() primary key,
    user_account_id uuid not null unique,
    document_number varchar(20) not null unique,
    full_name varchar(120) not null,
    email varchar(120),
    created_at timestamp default current_timestamp,
    updated_at timestamp,
    constraint fk_patient_user_account
        foreign key (user_account_id) references tb_user_account(id)
);

create table if not exists tb_specialty (
    id uuid default gen_random_uuid() primary key,
    name varchar(100) not null unique,
    description varchar(250),
    active boolean not null default true,
    created_at timestamp default current_timestamp
);

create table if not exists tb_therapy_service (
    id uuid default gen_random_uuid() primary key,
    specialty_id uuid not null,
    name varchar(120) not null,
    description varchar(250),
    price decimal(10,2) not null,
    active boolean not null default true,
    created_at timestamp default current_timestamp,
    constraint fk_service_specialty
        foreign key (specialty_id) references tb_specialty(id)
);

create table if not exists tb_physiotherapist (
    id uuid default gen_random_uuid() primary key,
    full_name varchar(120) not null,
    email varchar(120) unique,
    phone varchar(20),
    active boolean not null default true,
    created_at timestamp default current_timestamp
);

create table if not exists tb_physiotherapist_specialty (
    id uuid default gen_random_uuid() primary key,
    physiotherapist_id uuid not null,
    specialty_id uuid not null,
    created_at timestamp default current_timestamp,
    constraint fk_physio_specialty_physio
        foreign key (physiotherapist_id) references tb_physiotherapist(id),
    constraint fk_physio_specialty_specialty
        foreign key (specialty_id) references tb_specialty(id),
    constraint uk_physio_specialty unique (physiotherapist_id, specialty_id)
);

create table if not exists tb_appointment (
    id uuid default gen_random_uuid() primary key,
    patient_id uuid not null,
    therapy_service_id uuid not null,
    physiotherapist_id uuid not null,
    appointment_date timestamp not null,
    status varchar(30) not null default 'SCHEDULED',
    notes varchar(300),
    created_at timestamp default current_timestamp,
    updated_at timestamp,
    constraint fk_appointment_patient
        foreign key (patient_id) references tb_patient(id),
    constraint fk_appointment_service
        foreign key (therapy_service_id) references tb_therapy_service(id),
    constraint fk_appointment_physiotherapist
        foreign key (physiotherapist_id) references tb_physiotherapist(id)
);

create table if not exists tb_appointment_event_log (
    id uuid default gen_random_uuid() primary key,
    appointment_id uuid,
    event_type varchar(50) not null,
    event_status varchar(30) not null,
    payload text,
    error_message varchar(500),
    processed_at timestamp default current_timestamp,
    constraint fk_event_log_appointment
        foreign key (appointment_id) references tb_appointment(id)
);

insert into tb_specialty (name, description)
values
('Recuperación muscular', 'Tratamientos enfocados en lesiones musculares y recuperación funcional.'),
('Terapia postquirúrgica', 'Rehabilitación posterior a cirugías o procedimientos médicos.'),
('Masoterapia', 'Técnicas manuales y masajes terapéuticos.'),
('Fisioterapia deportiva', 'Atención de lesiones relacionadas al deporte.'),
('Rehabilitación neurológica', 'Terapias orientadas a recuperación neurológica y funcional.')
on conflict (name) do nothing;

insert into tb_therapy_service (specialty_id, name, description, price)
select id, 'Evaluación fisioterapéutica', 'Evaluación inicial del paciente.', 60.00
from tb_specialty where name = 'Recuperación muscular'
on conflict do nothing;

insert into tb_therapy_service (specialty_id, name, description, price)
select id, 'Sesión de recuperación muscular', 'Tratamiento para dolor o lesión muscular.', 80.00
from tb_specialty where name = 'Recuperación muscular'
on conflict do nothing;

insert into tb_therapy_service (specialty_id, name, description, price)
select id, 'Terapia postquirúrgica', 'Sesión de rehabilitación posterior a cirugía.', 120.00
from tb_specialty where name = 'Terapia postquirúrgica'
on conflict do nothing;

insert into tb_therapy_service (specialty_id, name, description, price)
select id, 'Masoterapia terapéutica', 'Masajes y técnicas manuales.', 90.00
from tb_specialty where name = 'Masoterapia'
on conflict do nothing;

insert into tb_therapy_service (specialty_id, name, description, price)
select id, 'Fisioterapia deportiva', 'Tratamiento para lesiones deportivas.', 100.00
from tb_specialty where name = 'Fisioterapia deportiva'
on conflict do nothing;

insert into tb_physiotherapist (full_name, email, phone)
values
('Mary Peralta', 'mary.physio@test.com', '999111222'),
('Jose Castillo', 'jose.physio@test.com', '999333444'),
('Luis Acuña', 'luis.physio@test.com', '999555666')
on conflict (email) do nothing;

insert into tb_physiotherapist_specialty (physiotherapist_id, specialty_id)
select p.id, s.id
from tb_physiotherapist p, tb_specialty s
where p.email = 'mary.physio@test.com'
  and s.name in ('Recuperación muscular', 'Masoterapia')
on conflict do nothing;

insert into tb_physiotherapist_specialty (physiotherapist_id, specialty_id)
select p.id, s.id
from tb_physiotherapist p, tb_specialty s
where p.email = 'jose.physio@test.com'
  and s.name in ('Terapia postquirúrgica', 'Fisioterapia deportiva')
on conflict do nothing;

insert into tb_physiotherapist_specialty (physiotherapist_id, specialty_id)
select p.id, s.id
from tb_physiotherapist p, tb_specialty s
where p.email = 'luis.physio@test.com'
  and s.name in ('Rehabilitación neurológica', 'Recuperación muscular')
on conflict do nothing;