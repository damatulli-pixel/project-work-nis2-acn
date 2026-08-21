-- 01_schema.sql
-- Schema relazionale del prototipo NIS2 / ACN
-- Target: PostgreSQL 15+

CREATE TABLE Azienda (
    id_azienda SERIAL PRIMARY KEY,
    ragione_sociale VARCHAR(255) NOT NULL,
    partita_iva VARCHAR(16) UNIQUE NOT NULL,
    settore_nis2 VARCHAR(100) NOT NULL
);

CREATE TABLE Contatto (
    id_contatto SERIAL PRIMARY KEY,
    id_azienda INT NOT NULL
        REFERENCES Azienda(id_azienda) ON DELETE CASCADE,
    nome_cognome VARCHAR(255) NOT NULL,
    ruolo_nis2 VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE Servizio_Critico (
    id_servizio SERIAL PRIMARY KEY,
    id_azienda INT NOT NULL
        REFERENCES Azienda(id_azienda) ON DELETE CASCADE,
    nome_servizio VARCHAR(255) NOT NULL,
    livello_criticita VARCHAR(50) NOT NULL
        CHECK (livello_criticita IN ('Basso','Medio','Critico'))
);

CREATE TABLE Asset (
    id_asset SERIAL PRIMARY KEY,
    id_azienda INT NOT NULL
        REFERENCES Azienda(id_azienda) ON DELETE CASCADE,
    nome_asset VARCHAR(255) NOT NULL,
    tipologia VARCHAR(100) NOT NULL
        CHECK (tipologia IN ('Hardware/IT','Hardware/OT','Network','Software','Cloud')),
    stato VARCHAR(50) NOT NULL DEFAULT 'Attivo'
        CHECK (stato IN ('Attivo','Dismesso','Compromesso','In Manutenzione')),
    valido_da TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Fornitore_Terzo (
    id_fornitore SERIAL PRIMARY KEY,
    nome_fornitore VARCHAR(255) NOT NULL,
    tipologia_fornitura VARCHAR(100)
);

CREATE TABLE Asset_Servizio (
    id_asset INT NOT NULL
        REFERENCES Asset(id_asset) ON DELETE CASCADE,
    id_servizio INT NOT NULL
        REFERENCES Servizio_Critico(id_servizio) ON DELETE CASCADE,
    PRIMARY KEY (id_asset, id_servizio)
);

CREATE TABLE Asset_Fornitore (
    id_asset INT NOT NULL
        REFERENCES Asset(id_asset) ON DELETE CASCADE,
    id_fornitore INT NOT NULL
        REFERENCES Fornitore_Terzo(id_fornitore) ON DELETE CASCADE,
    livello_dipendenza VARCHAR(50) NOT NULL DEFAULT 'Critico'
        CHECK (livello_dipendenza IN ('Basso','Medio','Critico')),
    PRIMARY KEY (id_asset, id_fornitore)
);

CREATE TABLE Asset_History (
    id_history SERIAL PRIMARY KEY,
    id_asset INT NOT NULL,
    nome_asset VARCHAR(255),
    stato_precedente VARCHAR(50),
    valido_da TIMESTAMPTZ,
    modificato_il TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_operazione VARCHAR(10) NOT NULL
        CHECK (tipo_operazione IN ('UPDATE','DELETE'))
);
