-- Quais os hospitais com rating=5 (nome, id, morada)? 

DELIMITER //
CREATE FUNCTION Hospital_Rating5(id_hosp INT) RETURNS BOOLEAN
BEGIN
    DECLARE resultado BOOLEAN;
    
    SELECT COUNT(*) INTO resultado
    FROM classificacao c
    INNER JOIN hospital h ON h.id_hospital = c.id_hospital
    WHERE h.id_hospital = id_hosp
    AND c.rating = 5
    AND c.data_classificacao = (SELECT MAX(data_classificacao) FROM classificacao WHERE id_hospital = h.id_hospital);
    
    RETURN resultado;
END //
DELIMITER ;

SELECT id_hospital,nome,morada FROM Hospital WHERE Hospital_Rating5(id_hospital);

-- Quais são os hospitais que têm os melhores parametros em pelo menos três dos de comparação com a média nacional? 
DELIMITER //
CREATE FUNCTION HospMedNacional (id_hosp INT) RETURNS BOOLEAN
BEGIN
	DECLARE contagem_imag INT DEFAULT 0;
    DECLARE contagem_tempo INT DEFAULT 0;
    DECLARE contagem_cuidados INT DEFAULT 0;
    DECLARE contagem_pacientes INT DEFAULT 0;
    DECLARE contagem_read INT DEFAULT 0;
    DECLARE contagem_seguranca INT DEFAULT 0;
    DECLARE contagem_mortalidade INT DEFAULT 0;
    SELECT COUNT(*) INTO contagem_imag FROM comparacao c, hospital h WHERE c.imag_medica = 'Above the national average' AND id_hosp=h.id_hospital;
    SELECT COUNT(*) INTO contagem_tempo FROM comparacao c, hospital h WHERE c.tempo_espera = 'Below the national average' AND id_hosp=h.id_hospital;
    SELECT COUNT(*) INTO contagem_cuidados FROM comparacao c, hospital h WHERE c.cuidados = 'Above the national average' AND id_hosp=h.id_hospital;
    SELECT COUNT(*) INTO contagem_pacientes FROM comparacao c, hospital h WHERE c.exp_pacientes = 'Above the national average' AND id_hosp=h.id_hospital;
    SELECT COUNT(*) INTO contagem_read FROM comparacao c, hospital h WHERE c.read_nacional = 'Below the national average' AND id_hosp=h.id_hospital;
    SELECT COUNT(*) INTO contagem_seguranca FROM comparacao c, hospital h WHERE c.seguranca_nac = 'Above the national average' AND id_hosp=h.id_hospital;
    SELECT COUNT(*) INTO contagem_mortalidade FROM comparacao c, hospital h WHERE c.mortalidade_nac = 'Below the national average' AND id_hosp=h.id_hospital;
	IF (contagem_imag+contagem_tempo+contagem_cuidados+contagem_pacientes+contagem_read+contagem_seguranca+contagem_mortalidade)>=3
    THEN 
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END //
delimiter ;
    
SELECT * FROM hospital WHERE HospMedNacional(id_hospital);


