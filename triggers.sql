SET FOREIGN_KEY_CHECKS=0;

-- Se um hospital for eliminado, eliminar o medico, comparacao e classificacao assossiado(s) a esse hospital

DELIMITER $$
CREATE TRIGGER EliminarHospitalAssociados
AFTER DELETE ON hospital
FOR EACH ROW
BEGIN
    DELETE FROM medico 
		WHERE id_hospital = OLD.id_hospital;
	DELETE FROM comparacao 
		WHERE id_hospital=OLD.id_hospital;
	DELETE FROM classificacao
		WHERE id_hospital=OLD.id_hospital;
END$$
delimiter ;

DELETE FROM hospital WHERE id_hospital=10005;

-- Depois de inserir na classificacao, verificar se ja ha um hospital com essa classificacao, 
-- Se ja houver comparamos e adicionamos um comentario a dizer se se manteve, se aumentou ou se diminuiu. 
DELIMITER $$
CREATE TRIGGER InserirClassificacao 
BEFORE INSERT ON classificacao
FOR EACH ROW
BEGIN
    DECLARE antigo_rating INT DEFAULT 0;
    DECLARE existir_hospital INT DEFAULT 0;
    DECLARE novo_comentario LONGTEXT DEFAULT NULL;
    
    -- Verificar se existe uma classificação anterior para o mesmo hospital
    SELECT COUNT(*) INTO existir_hospital FROM classificacao WHERE id_hospital = NEW.id_hospital;
    IF existir_hospital > 0 THEN
        -- Obter o rating da classificação mais recente para o mesmo hospital
        SELECT rating INTO antigo_rating FROM classificacao
        WHERE id_hospital = NEW.id_hospital AND data_classificacao=(SELECT MAX(data_classificacao) FROM classificacao);
			-- ORDER BY data_classificacao DESC
			-- LIMIT 1;
	
        -- Comparar o novo rating com o rating anterior e atualizar o comentário
        IF NEW.rating > antigo_rating THEN
            SET novo_comentario = 'O Hospital melhorou o seu rating';
        ELSEIF NEW.rating = antigo_rating THEN
            SET novo_comentario = 'O Hospital manteve o seu rating';
        ELSE
            SET novo_comentario = 'O Hospital piorou o seu rating';
        END IF;
    END IF;
    
    -- Atribuir o novo comentário ao registro a ser inserido
    SET NEW.comentario = novo_comentario;
END $$
DELIMITER ;

INSERT INTO classificacao(id_hospital,rating,data_classificacao) VALUES (31308,2,curdate());
INSERT INTO classificacao(id_hospital,rating,data_classificacao) VALUES (21309,2,curdate());
