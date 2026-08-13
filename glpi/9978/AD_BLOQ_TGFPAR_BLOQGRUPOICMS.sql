CREATE OR REPLACE EDITIONABLE TRIGGER "GRUPOSOULPRD"."AD_BLOQ_TGFPAR_BLOQGRUPOICMS" 
BEFORE UPDATE ON TGFPAR 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW

/*******************************************************************************************
* AUTOR: Alexandre                                                                         *
* DATA: 29/10/2024                                                                         *
* OBJETIVO: Ser obrigado a preencher o campo Grupo de icms                                 *
*******************************************************************************************/
DECLARE
  P_GRUPOICMS VARCHAR2(2);
  P_UF        INT;
BEGIN
   -- IF :NEW.EMAIL <> 'ml@ml.com.br' THEN--QUANDO NÃO FOR PARCEIRO MERCADO LIVRE
      -- Verifica se o cliente é 'S'
      IF :NEW.CLIENTE = 'S'THEN
        -- Busca o GRUPOICMS apenas se o cliente for 'S'
        BEGIN
        SELECT MAX(P.GRUPOICMS)
        INTO P_GRUPOICMS
        FROM TGFPAEM P
        WHERE P.CODPARC = :NEW.CODPARC;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            P_GRUPOICMS := NULL; -- Define como NULL se não encontrar
        END;
        -- Verifica se P_GRUPOICMS é nulo e se não é cliente do mercado livre
        IF P_GRUPOICMS IS NULL THEN
          RAISE_APPLICATION_ERROR(-20201, 'O Grupo ICMS / ISS por empresa precisa ser preenchido, o campo <b>GRUPO DE ICMS</b> não pode estar em branco.');
        END IF;
      END IF;
   -- END IF;
END;

/
ALTER TRIGGER "GRUPOSOULPRD"."AD_BLOQ_TGFPAR_BLOQGRUPOICMS" ENABLE;