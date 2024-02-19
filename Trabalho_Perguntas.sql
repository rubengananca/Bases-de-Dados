SET SQL_SAFE_UPDATES = 0;
SET @@global.log_bin_trust_function_creators=1;

-- Que estado tem maior quantidade de hospitais do tipo crítico (id,nome,estado,morada).
SELECT h.estado, COUNT(*) AS contagem FROM hospital h 
    JOIN tipo t ON t.id_tipo = h.id_tipo
		WHERE t.designacao = "Critical Access Hospitals"
			GROUP BY h.estado
				ORDER BY contagem DESC
					LIMIT 1;


-- Top 3 de cidade com mais hospitais?
SELECT cidade, COUNT(*) AS total_hospitais FROM hospital
GROUP BY cidade
ORDER BY total_hospitais DESC
LIMIT 3;

-- Quais os 10 estado com os melhores hospitais?
SELECT h.estado estado, MAX(c.rating) rating_maximo FROM hospital h
JOIN classificacao c ON c.id_hospital = h.id_hospital
GROUP BY estado
ORDER BY rating_maximo DESC
LIMIT 25;

-- Qual o tipo de hospital mais frequente no dataset ? 
SELECT hospital.id_tipo, tipo.designacao, COUNT(hospital.id_tipo) AS total_tipos_hospital 
FROM hospital, tipo 
GROUP BY hospital.id_tipo, tipo.designacao 
ORDER BY COUNT(hospital.id_tipo) DESC 
LIMIT 1 ;

-- Quais os hospitais tribal que têm serviço de emergência?
SELECT h.nome FROM hospital h, dono d
WHERE h.emergencia= "VERDADEIRO" AND d.designacao = "Tribal";

-- Quantos hospitais possui o maior proprietário/dono na base de dados? 
SELECT COUNT(hospital.id_hospital) num_hospitais, dono.designacao
FROM hospital, dono
WHERE hospital.id_dono = dono.id_dono
GROUP BY dono.designacao
ORDER BY num_hospitais DESC 
LIMIT 1;

-- Quais são os hospitais {id,nome,cidade} do governo com menor tempo de espera que a média nacional?
SELECT hospital.id_hospital, hospital.nome , hospital.cidade FROM hospital, comparacao, dono 
WHERE hospital.id_dono = dono.id_dono 
AND comparacao.id_hospital= hospital.id_hospital 
AND 
 comparacao.tempo_espera= " Below the national average " 
 AND dono.designacao= "Government - Hospital District or Authority" 
 OR dono.designacao= "Government -Federal" 
 OR dono.designacao= "Government - Local" ;

-- Quais são os hospitais privados ou voluntarios (Id, nome) com maior taxa de mortalidade que a média nacional?

SELECT h.id_hospital, h.nome From hospital h, comparacao c, dono d
WHERE c.id_hospital=h.id_hospital AND d.id_dono=h.id_dono 
AND (d.designacao="Voluntary non-profit - Church"
OR d.designacao="Voluntary non-profit - Other"
OR d.designacao="Voluntary non-profit - Private"
OR d.designacao="Proprietary")
AND c.mortalidade_nac = "Above the national average" ;

--  Qual o comentário mais frequente (na parte da classificação? E quantas vezes ocorre? 
-- NOTA: Explicar que o primeiro comentario é em branco logo escolhemos o seguinte

SELECT comentario, COUNT(comentario) FROM classificacao
GROUP BY comentario
ORDER BY COUNT(comentario) DESC 
LIMIT 1
OFFSET 1;

-- Quantos hospitais {id,nome,estado} do tipo ‘Critical Access Hospitals’ é que possuem tanto serviço de emergência como EHR? 
SELECT hospital.id_hospital, hospital.nome, hospital.estado from hospital,tipo WHERE 
	hospital.id_tipo = tipo.id_tipo AND tipo.designacao = "Critical Access Hospitals" AND 
		hospital.emergencia = "VERDADEIRO " AND hospital.ehr = "VERDADEIRO " ;



-- De que cidade são os hospitais e que hospitais {id,nome} são aqueles que têm um serviço mais eficiente (cuidados) e com melhor experiência dos doentes do que a média nacional.
SELECT hospital.cidade, hospital.id_hospital, hospital.nome FROM hospital, comparacao 
WHERE hospital.id_hospital = comparacao.id_hospital
AND comparacao.cuidados = "Above the national average " 
AND comparacao.exp_pacientes = "Above the national average ";

-- Quais são os hospitais (Id_hospital,nome) que têm menor tempo de espera que a média nacional, boa experiencia dos pacientes, bons cuidados, e boa segurança.

-- este é so composto com AND
SELECT hospital.id_hospital, hospital.nome FROM hospital, comparacao 
WHERE comparacao.id_hospital=hospital.id_hospital
AND (comparacao.tempo_espera = "Below the nationa average" 
AND comparacao.exp_pacientes = "Above the national average" 
AND comparacao.cuidados = "Above the national average" 
AND comparacao.seguranca_nac = "Above the national average") ;

-- Este é por OR
SELECT hospital.id_hospital, hospital.nome FROM hospital, comparacao 
WHERE comparacao.id_hospital=hospital.id_hospital
AND (comparacao.tempo_espera = "Below the nationa average" 
OR comparacao.exp_pacientes = "Above the national average" 
OR comparacao.cuidados = "Above the national average" 
OR comparacao.seguranca_nac = "Above the national average") ;

