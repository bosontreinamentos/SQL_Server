-- Criar o banco de dados
CREATE DATABASE db_Biblioteca ON PRIMARY
(
NAME = db_Biblioteca,
FILENAME = 'C:\SQL\db_Biblioteca.mdf',
SIZE = 6MB,
MAXSIZE = 15MB,
FILEGROWTH = 10%
)
LOG ON
(
NAME = db_Biblioteca_log,
FILENAME = 'C:\SQL\db_Biblioteca_log.ldf',
SIZE = 1MB, FILEGROWTH = 1MB
)
GO

-- Tornar o banco padrão
USE db_Biblioteca;

-- Criar as tabelas
CREATE TABLE Autor (
IdAutor SMALLINT IDENTITY,
NomeAutor VARCHAR(50) NOT NULL,
SobrenomeAutor VARCHAR(60) NOT NULL,
CONSTRAINT pk_ID_Autor PRIMARY KEY (IdAutor)
);

CREATE TABLE Editora (
IdEditora SMALLINT PRIMARY KEY IDENTITY,
NomeEditora VARCHAR(50) NOT NULL
);

CREATE TABLE Assunto (
  IdAssunto TINYINT PRIMARY KEY IDENTITY,
  NomeAssunto VARCHAR(25) NOT NULL
);

CREATE TABLE Livro (
   IdLivro SMALLINT NOT NULL PRIMARY KEY IDENTITY(100,1), 
   NomeLivro VARCHAR(70) NOT NULL,
   ISBN13 CHAR(13) UNIQUE NOT NULL,
   DataPub DATE,
   PrecoLivro MONEY NOT NULL,
   NumeroPaginas SMALLINT NOT NULL,
   IdEditora SMALLINT NOT NULL,
   IdAssunto TINYINT NOT NULL,
CONSTRAINT fk_id_editora FOREIGN KEY (IdEditora)
	REFERENCES Editora (IdEditora) ON DELETE CASCADE,
CONSTRAINT fk_id_assunto FOREIGN KEY (IdAssunto)
	REFERENCES Assunto (IdAssunto) ON DELETE CASCADE,
CONSTRAINT verifica_preco CHECK (PrecoLivro >= 0) );

CREATE TABLE LivroAutor (
  IdLivro SMALLINT NOT NULL,
  IdAutor SMALLINT NOT NULL,
CONSTRAINT pk_id_livro_autor PRIMARY KEY (IdLivro, IdAutor),
CONSTRAINT fk_id_livros FOREIGN KEY (IdLivro)
	REFERENCES Livro (IdLivro),
CONSTRAINT fk_id_autores FOREIGN KEY (IdAutor)
	REFERENCES Autor (IdAutor) ON DELETE CASCADE
);

-- Inserir Registros

-- Tabela de Assuntos
INSERT INTO Assunto (NomeAssunto)
VALUES 
('Ficção Científica'), ('Botânica'),
('Eletrônica'), ('Matemática'),
('Aventura'), ('Romance'),
('Finanças'), ('Gastronomia'),
('Terror'), ('Administração'),
('Informática'), ('Suspense');

-- Verificação
SELECT * FROM Assunto;

-- Tabela de Editoras
INSERT INTO Editora (NomeEditora)
VALUES
('Prentice Hall'), ('O´Reilly');

-- Verificação
SELECT * FROM Editora;


-- Mais editoras
INSERT INTO Editora (NomeEditora)
VALUES
('Aleph'), ('Microsoft Press'),
('Wiley'), ('HarperCollins'),
('Érica'), ('Novatec'),
('McGraw-Hill'), ('Apress'),
('Francisco Alves'), ('Sybex'),
('Globo'), ('Companhia das Letras'),
('Morro Branco'), ('Penguin Books'), ('Martin Claret'),
('Record'), ('Springer'), ('Melhoramentos'),
('Oxford'), ('Taschen'), ('Ediouro'),('Bookman');

-- Verificação
SELECT * FROM Editora;

-- Tabela de Autores
-- 1. Inserir uma linha única:
INSERT INTO Autor (NomeAutor, SobrenomeAutor)
VALUES ('Umberto','Eco');

-- Verificação
SELECT * FROM Autor;

-- 2. Inserir múltiplas linhas distintas (vários registros):
INSERT INTO Autor (NomeAutor, SobrenomeAutor)
VALUES
('Daniel', 'Barret'), ('Gerald', 'Carter'), ('Mark', 'Sobell'),
('William', 'Stanek'), ('Christine', 'Bresnahan'), ('William', 'Gibson'),
('James', 'Joyce'), ('John', 'Emsley'), ('José', 'Saramago'),
('Richard', 'Silverman'), ('Robert', 'Byrnes'), ('Jay', 'Ts'),
('Robert', 'Eckstein'), ('Paul', 'Horowitz'), ('Winfield', 'Hill'),
('Joel', 'Murach'), ('Paul', 'Scherz'), ('Simon', 'Monk'),
('George', 'Orwell'), ('Ítalo','Calvino'), ('Machado','de Assis'),
('Oliver', 'Sacks'), ('Ray', 'Bradbury'), ('Walter', 'Isaacson'),
('Benjamin','Graham'), ('Júlio','Verne'), ('Marcelo', 'Gleiser'),
('Harri','Lorenzi'), ('Humphrey', 'Carpenter'), ('Isaac', 'Asimov'),
('Aldous', 'Huxley'), ('Arthur','Conan Doyle'), ('Blaise', 'Pascal'),
('Jostein', 'Gaarder'), ('Stephen', 'Hawking'), ('Stephen', 'Jay Gould'),
('Neil', 'De Grasse Tyson'), ('Charles', 'Darwin'), ('Alan', 'Turing'), ('Arthur', 'C. Clarke');

-- Verificação
SELECT * FROM Autor;


-- Tabela de Livros
INSERT INTO Livro (NomeLivro, ISBN13, DataPub, PrecoLivro,
NumeroPaginas, IdAssunto, IdEditora)
VALUES ('A Arte da Eletrônica', '9788582604342',
'20170308', 300.74,  1160, 3, 24);

SELECT * FROM Livro;

INSERT INTO Livro (NomeLivro, ISBN13, DataPub, PrecoLivro, NumeroPaginas, IdAssunto, IdEditora)
VALUES
	('Vinte Mil Léguas Submarinas', '9788582850022', '2014-09-16', 24.50, 448, 1, 16), -- Júlio Verne
	('O Investidor Inteligente', '9788595080805', '2016-01-25', 79.90, 450, 7, 6); -- Benjamin Graham	

-- Verificação
SELECT * FROM Livro;

-- Inserir em lote (bulk) a partir de arquivo CSV
INSERT INTO Livro (NomeLivro, ISBN13, DataPub, PrecoLivro,
NumeroPaginas, IdEditora, IdAssunto)
SELECT 
    NomeLivro, ISBN13, DataPub, PrecoLivro, NumeroPaginas,
	IdEditora, IdAssunto
FROM OPENROWSET(
    BULK 'C:\SQL\Livros.CSV',
    FORMATFILE = 'C:\SQL\Formato.xml',
	CODEPAGE = '65001',  -- UTF-8
	FIRSTROW = 2
) AS LivrosCSV;

-- Verificação
SELECT * FROM Livro;

-- Tabela LivroAutor
INSERT INTO LivroAutor(IdLivro, IdAutor)
VALUES
(100,15),
(100,16),
(101,27),
(102,26),
(103,41),
(104,24),
(105,32),
(106,20),
(107,27),
(108,1),
(109,22),
(110,10),
(111,21),
(112,5),
(113,10),
(114,8),
(115,18),
(115,19),
(116,31),
(117,22);

-- Verificação
SELECT * FROM LivroAutor;

-- Verificação com INNER JOIN
SELECT NomeLivro, NomeAutor, SobrenomeAutor
FROM Livro
INNER JOIN LivroAutor
  ON Livro.IdLivro = LivroAutor.IdLivro
INNER JOIN Autor
  ON Autor.IdAutor = LivroAutor.IdAutor
ORDER BY NomeLivro;
