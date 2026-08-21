-- 06_tests.sql
-- Test ripetibili del prototipo.
-- Eseguire dopo 01..05.

-- TEST 1: verifica vista principale
SELECT * FROM Vista_Profilo_ACN;

-- TEST 2: verifica JSON
SELECT jsonb_pretty(payload_istituzionale::jsonb)
FROM Vista_Profilo_ACN_JSON;

-- TEST 3: storico su UPDATE
UPDATE Asset
SET stato = 'In Manutenzione'
WHERE nome_asset = 'Server Cluster SCADA';

SELECT *
FROM Asset_History
ORDER BY id_history DESC;

-- TEST 4: integrità referenziale.
-- L'errore è atteso e viene intercettato per permettere allo script di proseguire.
DO $$
BEGIN
    BEGIN
        INSERT INTO Asset_Servizio (id_asset, id_servizio)
        VALUES (999999, 1);
        RAISE EXCEPTION 'TEST FALLITO: la FK non ha bloccato l''inserimento';
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'TEST SUPERATO: foreign key violation rilevata come previsto';
    END;
END
$$;

-- TEST 5: unicità della chiave composta.
DO $$
DECLARE
    v_asset INT;
    v_servizio INT;
BEGIN
    SELECT a.id_asset, s.id_servizio
      INTO v_asset, v_servizio
    FROM Asset a
    JOIN Asset_Servizio aps ON aps.id_asset = a.id_asset
    JOIN Servizio_Critico s ON s.id_servizio = aps.id_servizio
    WHERE a.nome_asset = 'Server Cluster SCADA'
    LIMIT 1;

    BEGIN
        INSERT INTO Asset_Servizio (id_asset, id_servizio)
        VALUES (v_asset, v_servizio);
        RAISE EXCEPTION 'TEST FALLITO: duplicato accettato';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE NOTICE 'TEST SUPERATO: duplicato rifiutato come previsto';
    END;
END
$$;

-- TEST 6: controllo finale sintetico
SELECT
    (SELECT COUNT(*) FROM Azienda) AS aziende,
    (SELECT COUNT(*) FROM Asset) AS asset,
    (SELECT COUNT(*) FROM Servizio_Critico) AS servizi,
    (SELECT COUNT(*) FROM Fornitore_Terzo) AS fornitori,
    (SELECT COUNT(*) FROM Contatto) AS contatti,
    (SELECT COUNT(*) FROM Asset_History) AS record_storico;
