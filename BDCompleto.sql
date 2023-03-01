USE master

CREATE DATABASE empresa_foguete;
USE empresa_foguete;
GO

CREATE TABLE Armazem(
cod_armazem INTEGER     PRIMARY KEY,
nome        VARCHAR(50) NOT NULL,
localizacao VARCHAR(50) NOT NULL
);

CREATE TABLE Empresa(
cod_empresa    INTEGER       PRIMARY KEY,
telefone       VARCHAR(20)   NOT NULL,
nome           VARCHAR(50)   NOT NULL,
nif            VARCHAR(20)   NOT NULL,
end_localidade VARCHAR(50)   NOT NULL,
end_morada     VARCHAR(50)   NOT NULL,
end_CodPostal  CHAR(8)       NOT NULL,

CHECK (end_CodPostal LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]')
);

CREATE TABLE Satelites(
cod_satelite INTEGER     PRIMARY KEY,
tipo         VARCHAR(50) NOT NULL,
peso         FLOAT       NOT NULL,
ano          INTEGER     NOT NULL,
modelo       VARCHAR(50) NOT NULL
);

CREATE TABLE Vaivem(
cod_vaivem  INTEGER     PRIMARY KEY,
nome        VARCHAR(50) NOT NULL,
modulos     INTEGER     NOT NULL,
capacidade  INTEGER     NOT NULL
);

CREATE TABLE Funcionarios(
id_funcionarios  INTEGER     PRIMARY KEY,
salario          MONEY       NOT NULL      DEFAULT 0,
nome             VARCHAR(50) NOT NULL,

CHECK (salario >=0)
);

CREATE TABLE Protocolo(
ref_protocolo   INTEGER      PRIMARY KEY,
descricao       VARCHAR(50)  NOT NULL,
tipo            VARCHAR(50)  NOT NULL
);

CREATE TABLE Guardar(
cod_armazem   INTEGER     NOT NULL,
cod_empresa   INTEGER     NOT NULL,
cod_satelite  INTEGER     NOT NULL,
data_inicio   DATETIME    NOT NULL  DEFAULT getdate(),
data_fim      DATETIME,    

PRIMARY KEY (cod_armazem,cod_satelite,cod_empresa,data_inicio),
FOREIGN KEY (cod_armazem) REFERENCES Armazem(cod_armazem),
FOREIGN KEY (cod_satelite) REFERENCES Satelites(cod_satelite),
FOREIGN KEY (cod_empresa) REFERENCES Empresa(cod_empresa),

CHECK (data_inicio < data_fim)
);

CREATE TABLE Transportar(
id_transportar   INTEGER     NOT NULL,
cod_vaivem       INTEGER     NOT NULL,
cod_satelite     INTEGER     NOT NULL,
ref_protocolo    INTEGER     NOT NULL,
preco            MONEY       NOT NULL,
data_transp      DATE        NOT NULL  DEFAULT getdate(),

PRIMARY KEY (id_transportar,cod_vaivem,cod_satelite,ref_protocolo),
FOREIGN KEY (cod_vaivem) REFERENCES Vaivem(cod_vaivem),
FOREIGN KEY (cod_satelite) REFERENCES Satelites(cod_satelite),
FOREIGN KEY (ref_protocolo) REFERENCES Protocolo(ref_protocolo),

CHECK (preco > 0)
);

CREATE TABLE Pagar(
cod_empresa      INTEGER     NOT NULL,
id_transportar   INTEGER     NOT NULL,
cod_vaivem       INTEGER     NOT NULL,
cod_satelite     INTEGER     NOT NULL,
ref_protocolo    INTEGER     NOT NULL,
data_pagar       DATE        NOT NULL  DEFAULT getdate(),
preco            MONEY       NOT NULL,

PRIMARY KEY(cod_empresa,id_transportar,cod_vaivem,cod_satelite,ref_protocolo,data_pagar),
FOREIGN KEY (cod_empresa) REFERENCES Empresa(cod_empresa),
FOREIGN KEY (id_transportar,cod_vaivem,cod_satelite,ref_protocolo) REFERENCES Transportar(id_transportar,cod_vaivem,cod_satelite,ref_protocolo),

CHECK (preco > 0)
);

CREATE TABLE Definir(
cod_empresa      INTEGER     NOT NULL,
ref_protocolo    INTEGER     NOT NULL,
data_def         DATE        NOT NULL  DEFAULT getdate(),
num_paginas      INTEGER,

PRIMARY KEY (cod_empresa,ref_protocolo,data_def),
FOREIGN KEY (cod_empresa) REFERENCES Empresa(cod_empresa),
FOREIGN KEY (ref_protocolo) REFERENCES Protocolo(ref_protocolo)
);

CREATE TABLE Manutencao(
id_funcionarios  INTEGER     NOT NULL,
cod_empresa      INTEGER     NOT NULL,
cod_vaivem       INTEGER     NOT NULL,
data_man         DATE        NOT NULL   DEFAULT getdate(),
descricao        VARCHAR(50),

PRIMARY KEY (id_funcionarios,cod_empresa,cod_vaivem,data_man),
FOREIGN KEY (id_funcionarios) REFERENCES Funcionarios(id_funcionarios),
FOREIGN KEY (cod_empresa) REFERENCES Empresa(cod_empresa),
FOREIGN KEY (cod_vaivem) REFERENCES Vaivem(cod_vaivem)
);

--1. Insira, pelo menos, 3 registos em cada tabela

INSERT INTO Armazem
VALUES (1,'Armazem Boavista', 'Boavista'),(2,'Armazem Braga', 'Braga'),(3,'Armazem Bragança', 'Bragança');

INSERT INTO Empresa
VALUES (1,'917769690','Empresa Coelho Lta','123456789','Lisboa','Circular Norte','1800-134'),
(2,'921234567','Empresa Ribeiro DJ8 Lta','234567890','Porto','Avenida do Dj8','4000-011'),
(3,'934567890','Empresa Corby Lta','345678910','Amadora','Rua do Corby','1500-173');

INSERT INTO Satelites
VALUES (1,'Observação',290.0,2020,'O-20.4'),(2,'Militar',600.0,2021,'M-21.3'),(3,'Pesquisa',270.0,2019,'P-19.2');

INSERT INTO Vaivem
VALUES (1,'Endeavour',2,2000),(2,'Transportador',6,1000),(3,'Mocadas',4,1500);

INSERT INTO Funcionarios
VALUES (1,1000,'Landro Colho'),(2,1100,'Leo Pleu'), (3,1050,'Jaqueline Rose');

INSERT INTO Protocolo
VALUES (1,'Pode aguardar por ajuda ','não urgente'), (2,'Pode aguardar por ajuda mas não por muito tempo  ','pouco urgente'),
(3,'Necessita de ajuda urgentemente','urgente');

INSERT INTO Guardar
VALUES (1,1,1,'2020/05/01','2020/06/17'), (1,2,1,'2021/04/10',NULL),(3,3,2,'2019/02/11','2019/12/07'),
(1,1,2,'2020/05/01','2020/06/17'), (1,2,2,'2021/05/10',NULL),(3,3,3,'2021/02/11','2021/12/07'), 
(1,2,3,'2021/02/10','2021/02/15'),(3,3,3,'2019/02/11','2019/12/07'), (2,2,2,'2021/05/10',NULL),(2,3,3,'2021/02/11',NULL), 
(1,2,3,'2021/03/10','2021/05/10'),(2,3,3,'2021/04/11','2021/05/10');

INSERT INTO Transportar
VALUES (1,2,1,1,690,'2020/05/19'), (2,2,1,1,900,'2021/05/12'), (3,1,2,2,1369,'2021/05/20'),(4,1,2,2,1690,'2021/05/19'), 
(5,1,2,1,999,'2021/04/30'), (6,3,3,3,1770,'2020/12/15'), (7,3,3,2,2000,'2020/06/25'), (8,3,3,1,1200,'2019/12/15');

INSERT INTO Pagar
VALUES (1,1,2,1,1,'2020/05/20',690), (2,2,2,1,1,'2021/04/13',900), (3,3,1,2,2,'2019/12/16',1369),(1,4,1,2,2,'2021/05/20',1690), 
(2,5,1,2,1,'2021/04/30',999), (3,6,3,3,3,'2020/12/15',1770),(1,7,3,3,2,'2020/06/25',2000), (2,8,3,3,1,'2019/12/15',1200);

INSERT INTO Definir
VALUES (3,1,'2020/07/30',50), (3,2,'2020/03/20',20), (2,1,'2021/05/21',NULL), (3,1,'2021/04/30',50), 
(1,2,'2020/12/20',30), (1,1,'2020/12/31',NULL), (1,2,'2020/03/20',40), (3,1,'2021/05/22',NULL);

INSERT INTO Manutencao
VALUES (1,1,1,'2020/07/14',NULL), (2,3,3,'2018/11/20','A manuntenção deve ser feita dentro de 20 dias'),
(3,2,2,'2019/09/08','A manuntenção deve ser feita dentro de 30 dias');


--2.1 Qual o último transporte realizado? [Vaivém (Nome), Satélites (Código), Data]
USE empresa_foguete;
SELECT Vaivem.nome AS 'Vaivém (Nome)', Satelites.cod_satelite AS 'Satélites (Código)', Transportar.data_transp AS Data
FROM Vaivem, Satelites, Transportar
WHERE  Transportar.data_transp=(SELECT MAX(data_transp) FROM Transportar)
AND Satelites.cod_satelite=Transportar.cod_satelite
AND Vaivem.cod_vaivem=Transportar.cod_vaivem

--2.2 Quantos transportes já se realizaram por cada Vaivém? [Vaivém (Código e Nome), N_Transportes]
USE empresa_foguete;
SELECT Vaivem.cod_vaivem AS 'Vaivém (Código)', Vaivem.nome AS 'Vaivém (Nome)', COUNT(Transportar.id_transportar) AS N_Transportes
FROM Vaivem, Transportar
WHERE Vaivem.cod_vaivem=Transportar.cod_vaivem
GROUP BY Vaivem.nome, Vaivem.cod_vaivem

--2.3 Qual a Empresa que mais pagou por um transporte? [Empresa (Nome), Preço, Data]
USE empresa_foguete;
SELECT Empresa.nome AS 'Empresa (Nome)', Pagar.preco AS Preço, Pagar.data_pagar AS Data
FROM Empresa, Pagar, Transportar
WHERE  Pagar.preco=(SELECT MAX(preco) FROM Pagar)
AND Empresa.cod_empresa=Pagar.cod_empresa
AND Pagar.preco=Transportar.preco

--2.4 Quais as empresas que pagaram por mais de 2 transportes nos últimos 30 dias? Ordene-as alfabeticamente. [Empresas (Nome), N_Transportes]
USE empresa_foguete;
SELECT Empresa.nome AS 'Empresas (Nome)', COUNT(Transportar.cod_satelite) AS N_Transportes
FROM Empresa, Transportar, Pagar
WHERE Pagar.cod_empresa=Empresa.cod_empresa
AND Pagar.id_transportar=Transportar.id_transportar
AND	Transportar.data_transp> GETDATE()-30
GROUP BY Empresa.nome
HAVING COUNT(DISTINCT Transportar.cod_satelite)>2
ORDER BY Empresa.nome ASC
--2.5 Quais os 2 armazéns com mais satélites guardados? [Armazém (nome), Quantidade]
USE empresa_foguete;
SELECT TOP 2 Armazem.nome AS 'Armazém (Nome)', COUNT(Guardar.data_fim) AS Quantidade
FROM Guardar, Satelites, Armazem
WHERE Armazem.cod_armazem=Guardar.cod_armazem
AND Satelites.cod_satelite=Guardar.cod_satelite
GROUP BY Armazem.nome
ORDER BY Quantidade DESC

--2.6 Quantos protocolos foram definidos por cada empresa no ano de 2020? [Empresa (nome, telefone)]
USE empresa_foguete;
SELECT Empresa.nome AS 'Empresa (nome)', Empresa.telefone AS 'Empresa (telefone)', COUNT(Protocolo.ref_protocolo) AS N_Protocolos
FROM Empresa, Definir, Protocolo
WHERE Definir.data_def <= '2020/12/31'
AND Definir.data_def >= '2020/01/01'
AND Definir.cod_empresa=Empresa.cod_empresa
AND Protocolo.ref_protocolo=Definir.ref_protocolo
GROUP BY Empresa.nome, Empresa.telefone

--2.7 Qual o peso total transportado por cada vaivém no ano de 2020? Ordene-os por ordem crescente. [Vaivém (Nome), PesoTotal]
USE empresa_foguete;
SELECT Vaivem.nome AS NomeVaivem, SUM(Vaivem.capacidade + Satelites.peso) AS PesoTotal
FROM Vaivem, Transportar, Satelites
WHERE Vaivem.cod_vaivem=Transportar.cod_vaivem
AND Satelites.cod_satelite=Transportar.cod_satelite
AND Transportar.data_transp <= '2020/12/31'
AND Transportar.data_transp >= '2020/01/01'
GROUP BY Vaivem.nome
ORDER BY PesoTotal ASC

DROP DATABASE empresa_foguete;




--3.1
DROP PROCEDURE guardarSatelite 
CREATE PROCEDURE guardarSatelite (@nif VARCHAR(20))
AS
BEGIN
     DECLARE @idempresa INTEGER 
	 SELECT @idempresa = cod_empresa FROM Empresa WHERE @nif = nif 
     IF @idempresa > 0
	 begin
		 SELECT AVG  ( datediff(day,G.data_inicio,G.data_fim)) AS 'tempo médio'
		 FROM Empresa E, Guardar G 
		 WHERE E.nif LIKE @nif AND E.cod_empresa = G.cod_empresa
	 end 
	 else
	 SELECT '-1' AS ERROR
END

EXEC guardarSatelite 345678910
SELECT * FROM Guardar
SELECT * FROM Empresa 




--3.2
DROP PROCEDURE Bonus
CREATE PROCEDURE Bonus @mes NUMERIC(2,0), @ano NUMERIC(4,0)
AS 
BEGIN
       SELECT E.nome AS 'nome da empresa',sum(T.preco) * 0.05 AS 'bónus de transporte'
	   FROM Empresa E, Pagar P, Transportar T 
	   WHERE E.cod_empresa = P.cod_empresa AND MONTH(T.data_transp) = @mes
					AND YEAR(T.data_transp) = @ano AND P.id_transportar = T.id_transportar
	   GROUP BY E.cod_empresa, E.nome
END

EXEC Bonus 06, 2020
SELECT * FROM Empresa
SELECT * FROM Pagar
SELECT * FROM Transportar




--3.3
CREATE TRIGGER Descricao
ON Manutencao
AFTER INSERT 
AS
BEGIN
    IF EXISTS (SELECT NULL FROM INSERTED WHERE descricao IS NULL)
    BEGIN
        UPDATE Manutencao 
        SET descricao = 'descrição omissa' 
        WHERE descricao IS NULL;
    END;
END;

DROP TRIGGER Descricao
INSERT INTO Manutencao VALUES (2,1,1,'2020/07/14',NULL)
SELECT * FROM Manutencao
