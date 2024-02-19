SET GLOBAL event_scheduler=ON;
SET @@global.event_scheduler=ON;
SET GLOBAL event_scheduler=1;
SET @@global.event_scheduler=1;


DELIMITER //
CREATE EVENT AtualizarIdade
	ON SCHEDULE EVERY 1 YEAR STARTS '2024-01-01 00:00:00'
	DO BEGIN 
		UPDATE Medico SET idade=idade+1;
END //
DELIMITER ;


-- Atualizar o serviço de emergencia no hospital

DELIMITER //
CREATE PROCEDURE AtualizarEmergencia(
     IN id INT,
     IN sos_novo VARCHAR(45))
BEGIN
     DECLARE sos_atual VARCHAR(45) DEFAULT NULL;

     -- Verifica se o novo servico de emergencia foi fornecido
     IF sos_novo IS NOT NULL THEN
         -- Atualiza o servico de emergencia do hospital com o novo valor
         UPDATE hospital SET emergencia = sos_novo WHERE id_hospital = id;
    ELSE
         -- Obtém o servico de emergencia atual do hospital
         SELECT emergencia INTO sos_atual FROM hospital WHERE id_hospital = id;

        -- Atualiza o servico atual, mantendo-o inalterado
        UPDATE hospital SET emergencia = sos_atual WHERE id_hospital = id;
    END IF;
END //
DELIMITER ;

CALL AtualizarEmergencia('10001','VERDADEIRO');


-- Atualizar a morada do médico
DELIMITER //
CREATE PROCEDURE AtualizarMoradaMed(
     IN id INT,
     IN morada_nova VARCHAR(500))
BEGIN
     DECLARE morada_atual VARCHAR(500) DEFAULT NULL;

     IF morada_nova IS NOT NULL THEN
         UPDATE medico SET morada = morada_nova WHERE id_medico = id;
    ELSE
         SELECT morada INTO morada_atual FROM medico WHERE id_medico = id;
         
         UPDATE medico SET morada = morada_atual WHERE id_medico = id;
    END IF;
END //
DELIMITER ;

CALL AtualizarMoradaMed('2','Rua Quintinha de S.Joao, Ap.V, Bloco AA');

-- Atualizar o telemóvel do médico

DELIMITER //
CREATE PROCEDURE AtualizarTelMed(
     IN id INT,
     IN tel_novo VARCHAR(12))
BEGIN
     DECLARE tel_atual VARCHAR(12) DEFAULT NULL;

     IF tel_novo IS NOT NULL THEN
         UPDATE medico SET telemovel = tel_novo WHERE id_medico = id;
    ELSE
         SELECT telemovel INTO tel_atual FROM medico WHERE id_medico = id;
         
         UPDATE medico SET telemovel = tel_atual WHERE id_medico = id;
    END IF;
END //
DELIMITER ;

CALL AtualizarTelMed('2','962403189');		


-- Atualizar o servico EHR de um hospital

DELIMITER //
CREATE PROCEDURE AtualizarEHR(
    IN id INT,
    IN novo_ehr VARCHAR(45))
BEGIN
    DECLARE ehr_atual LONGTEXT;
    IF ehr_atual IS NOT NULL THEN
        UPDATE hospital SET ehr_atual = novo_ehr WHERE id_hospital = id;
    ELSE
        UPDATE hospital SET ehr = novo_ehr WHERE id_hospital = id;
    END IF;
END //
DELIMITER ;

-- Comparar nº de hospitais com cuidados “Above Average..” com “Same as…” “Below…”?
DELIMITER //
CREATE PROCEDURE CuidadosHospitais()
BEGIN
    DECLARE acima_da_media INT;
    DECLARE abaixo_da_media INT;
    DECLARE mesma_media INT;

    -- Contagem dos hospitais acima da média
    SELECT COUNT(*) INTO acima_da_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.cuidados = 'Above the national average';

    -- Contagem dos hospitais abaixo da média
    SELECT COUNT(*) INTO abaixo_da_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.cuidados = 'Below the national average';
    
	-- Contagem dos hospitais abaixo da média
    SELECT COUNT(*) INTO mesma_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.cuidados = 'Same as the national average';

    -- Resultado
    SELECT acima_da_media AS hospitais_acima_media, abaixo_da_media AS hospitais_abaixo_media, mesma_media AS hospitais_com_mesma_media;
END //
delimiter ;

-- Comparar nº de hospitais com a experiência do paciente  “Above Average..” com “Same as…” “Below…”?
delimiter //
CREATE PROCEDURE ExpPacienteHospitais()
BEGIN
    DECLARE acima_da_media INT;
    DECLARE abaixo_da_media INT;
    DECLARE mesma_media INT;

    -- Contagem dos hospitais acima da média
    SELECT COUNT(*) INTO acima_da_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.exp_pacientes = 'Above the national average';

    -- Contagem dos hospitais abaixo da média
    SELECT COUNT(*) INTO abaixo_da_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.exp_pacientes = 'Below the national average';
    
	-- Contagem dos hospitais com a mesma média 
    SELECT COUNT(*) INTO mesma_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.exp_pacientes = 'Same as the national average';

    -- Resultado
    SELECT acima_da_media AS hospitais_acima_media, abaixo_da_media AS hospitais_abaixo_media, mesma_media AS hospitais_com_mesma_media;
END //
delimiter ;

-- Comparar nº de hospitais com mortalidade “Above Average..” com “Same as…” “Below…”?
DELIMITER //
CREATE PROCEDURE MortalidadeHospitais()
BEGIN
    DECLARE acima_da_media INT;
    DECLARE abaixo_da_media INT;
    DECLARE mesma_media INT;

    -- Contagem dos hospitais acima da média
    SELECT COUNT(*) INTO acima_da_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.mortalidade_nac = 'Above the national average';

    -- Contagem dos hospitais abaixo da média
    SELECT COUNT(*) INTO abaixo_da_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.mortalidade_nac = 'Below the national average';
    
	-- Contagem dos hospitais com a mesma média
    SELECT COUNT(*) INTO mesma_media
    FROM hospital h
    JOIN comparacao c ON h.id_hospital = c.id_hospital
    WHERE c.mortalidade_nac = 'Same as the national average';

    -- Resultado
    SELECT acima_da_media AS hospitais_acima_media, abaixo_da_media AS hospitais_abaixo_media, mesma_media AS hospitais_com_mesma_media;
END //
delimiter ;


CALL AtualizarEHR(10001, "VERDADEIRO");
CALL MortalidadeHospitais();
CALL ExpPacienteHospitais();
CALL CuidadosHospitais();

-- Percentagem de hospitais com rating 0,1,2,3,4,5

DELIMITER //
CREATE PROCEDURE CalcularPercentagemRating()
BEGIN
    DECLARE total_hospitais INT;
    DECLARE rating_0_percentagem DECIMAL(5, 2);
    DECLARE rating_1_percentagem DECIMAL(5, 2);
    DECLARE rating_2_percentagem DECIMAL(5, 2);
    DECLARE rating_3_percentagem DECIMAL(5, 2);
    DECLARE rating_4_percentagem DECIMAL(5, 2);
    DECLARE rating_5_percentagem DECIMAL(5, 2);

    -- Total de hospitais
    SELECT COUNT(*) INTO total_hospitais FROM hospital;

    -- Percentagem de hospitais com rating 0
    SELECT (COUNT(*) / total_hospitais) * 100 INTO rating_0_percentagem
    FROM hospital h
    JOIN classificacao c ON h.id_hospital = c.id_hospital
    WHERE c.rating = 0;

    -- Percentagem de hospitais com rating 1
    SELECT (COUNT(*) / total_hospitais) * 100 INTO rating_1_percentagem
    FROM hospital h
    JOIN classificacao c ON h.id_hospital = c.id_hospital
    WHERE c.rating = 1;

    -- Percentagem de hospitais com rating 2
    SELECT (COUNT(*) / total_hospitais) * 100 INTO rating_2_percentagem
    FROM hospital h
    JOIN classificacao c ON h.id_hospital = c.id_hospital
    WHERE c.rating = 2;

    -- Percentagem de hospitais com rating 3
    SELECT (COUNT(*) / total_hospitais) * 100 INTO rating_3_percentagem
    FROM hospital h
    JOIN classificacao c ON h.id_hospital = c.id_hospital
    WHERE c.rating = 3;

    -- Percentagem de hospitais com rating 4
    SELECT (COUNT(*) / total_hospitais) * 100 INTO rating_4_percentagem
    FROM hospital h
    JOIN classificacao c ON h.id_hospital = c.id_hospital
    WHERE c.rating = 4;

    -- Percentagem de hospitais com rating 5
    SELECT (COUNT(*) / total_hospitais) * 100 INTO rating_5_percentagem
    FROM hospital h
    JOIN classificacao c ON h.id_hospital = c.id_hospital
    WHERE c.rating = 5;

    -- Resultado
    SELECT
        rating_0_percentagem AS rating_0,
        rating_1_percentagem AS rating_1,
        rating_2_percentagem AS rating_2,
        rating_3_percentagem AS rating_3,
        rating_4_percentagem AS rating_4,
        rating_5_percentagem AS rating_5;
END //
delimiter ;

CALL CalcularPercentagemRating();

-- Ordenar os hospitais pelo ultimo rating feito
DELIMITER //
CREATE PROCEDURE OrdHospClass()
BEGIN
	SELECT id_hospital,rating, data_classificacao FROM classificacao c
		WHERE (id_hospital, data_classificacao) 
			IN (SELECT id_hospital, MAX(data_classificacao) data_mais_recente FROM classificacao
				GROUP BY id_hospital)
                ORDER BY id_hospital;
END //
delimiter ;

CALL OrdHospClass();