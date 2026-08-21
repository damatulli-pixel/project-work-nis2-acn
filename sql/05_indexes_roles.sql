-- 05_indexes_roles.sql
-- Indici, retention e ruoli di autorizzazione.

CREATE INDEX idx_asset_stato ON Asset(stato);
CREATE INDEX idx_asset_azienda ON Asset(id_azienda);
CREATE INDEX idx_history_asset ON Asset_History(id_asset);
CREATE INDEX idx_servizio_criticita ON Servizio_Critico(livello_criticita);

CREATE OR REPLACE PROCEDURE applica_data_retention(anni_retention INT)
LANGUAGE plpgsql
AS $$
DECLARE
    record_eliminati INT;
BEGIN
    IF anni_retention <= 0 THEN
        RAISE EXCEPTION 'anni_retention deve essere maggiore di zero';
    END IF;

    DELETE FROM Asset_History
    WHERE modificato_il <
          (CURRENT_TIMESTAMP - (anni_retention || ' years')::INTERVAL);

    GET DIAGNOSTICS record_eliminati = ROW_COUNT;
    RAISE NOTICE 'Policy applicata: eliminati % record di storico.',
                 record_eliminati;
END;
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ciso_admin') THEN
        CREATE ROLE ciso_admin NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auditor_acn') THEN
        CREATE ROLE auditor_acn NOLOGIN;
    END IF;
END
$$;

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ciso_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ciso_admin;

GRANT SELECT ON Vista_Profilo_ACN TO auditor_acn;
GRANT SELECT ON Vista_Profilo_ACN_JSON TO auditor_acn;

-- Esempio di associazione a un eventuale utente LOGIN:
-- GRANT auditor_acn TO nome_utente;
