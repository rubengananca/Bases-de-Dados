CREATE TABLE Medico
	(id_medico INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    especialidade VARCHAR(100) NOT NULL,
    data_inicio_servico DATE NOT NULL,
    morada VARCHAR(500) NULL,
    telemovel VARCHAR(12) NULL,
    id_hospital INT NOT NULL,
    PRIMARY KEY(id_medico),
    CONSTRAINT medico_fk1
		FOREIGN KEY (`id_hospital`)
		REFERENCES `mydb`.`Hospital` (`id_hospital`)
    );
 
INSERT INTO Medico VALUES (1, 'Ricardo Reis', 36 ,'psiquiatria','2017-05-25','','',10005);
INSERT INTO Medico VALUES (2, 'Alvaro Campos', 43 ,'medicina geral','2014-03-13','' ,'' ,10044);
INSERT INTO Medico VALUES (3, 'Alberto Caeiro', 38 ,'pediatria','2015-02-28','', '', 21304);

