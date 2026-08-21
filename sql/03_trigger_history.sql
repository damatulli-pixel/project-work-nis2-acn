-- 03_trigger_history.sql
-- Storicizzazione applicativa degli UPDATE/DELETE su Asset.

CREATE OR REPLACE FUNCTION archivia_storico_asset()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
        INSERT INTO Asset_History
            (id_asset, nome_asset, stato_precedente, valido_da, tipo_operazione)
        VALUES
            (OLD.id_asset, OLD.nome_asset, OLD.stato, OLD.valido_da, TG_OP);
    END IF;

    IF (TG_OP = 'UPDATE') THEN
        NEW.valido_da = CURRENT_TIMESTAMP;
        RETURN NEW;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_storico_asset
BEFORE UPDATE OR DELETE ON Asset
FOR EACH ROW
EXECUTE FUNCTION archivia_storico_asset();
