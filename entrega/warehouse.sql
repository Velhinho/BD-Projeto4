BEGIN;

CREATE TYPE user_type AS ENUM ('regular', 'qualificado');
CREATE TYPE week_day AS ENUM (
    'Segunda', 'Terca', 'Quarta', 'Quinta', 'Sexta', 'Sabado', 'Domingo');

CREATE TABLE d_utilizador (
    id_utilizador integer NOT NULL,
    email varchar(254) NOT NULL,
    tipo user_type NOT NULL,

    PRIMARY KEY (id_utilizador)
);

CREATE TABLE d_tempo (
    id_tempo integer NOT NULL,
    dia integer NOT NULL,
    dia_da_semana week_day NOT NULL,
    semana integer NOT NULL,
    mes integer NOT NULL,
    trimestre integer NOT NULL,
    ano integer NOT NULL,

    PRIMARY KEY(id_tempo),

    CONSTRAINT invalid_day CHECK (dia BETWEEN 0 AND 31),
    CONSTRAINT invalid_week CHECK (semana BETWEEN 0 AND 52),
    CONSTRAINT invalid_month CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT invalid_trimestre CHECK (trimestre BETWEEN 1 AND 4),
    CONSTRAINT invalid_year CHECK (ano > 0)
);

CREATE TABLE d_local (
    id_local integer NOT NULL,
    latitude numeric(9, 6) NOT NULL,
    longitude numeric(8, 6) NOT NULL,

    PRIMARY KEY (id_local)
);

CREATE TABLE d_lingua (
    id_lingua integer NOT NULL,
    lingua char(3) NOT NULL,

    PRIMARY KEY (id_lingua)
);

CREATE TABLE f_anomalia (
    id_utilizador integer NOT NULL,
    id_tempo integer NOT NULL,
    id_local integer NOT NULL,
    id_lingua integer NOT NULL,

    FOREIGN KEY (id_utilizador) REFERENCES d_utilizador(id_utilizador),
    FOREIGN KEY (id_tempo) REFERENCES d_tempo(id_tempo),
    FOREIGN KEY (id_local) REFERENCES d_local(id_local),
    FOREIGN KEY (id_lingua) REFERENCES d_lingua(id_lingua)
);

COMMIT;
