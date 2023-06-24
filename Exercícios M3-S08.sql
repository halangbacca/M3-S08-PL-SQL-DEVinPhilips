SELECT * FROM Produto;
SELECT * FROM ProdutoPreco;

-- Exercício 1
CREATE OR REPLACE FUNCTION CalcularDesconto(IdSelecionado NUMBER, desconto NUMBER) RETURN NUMBER IS 
BEGIN
	FOR produto IN (SELECT Valor FROM ProdutoPreco WHERE ID = IdSelecionado) LOOP
		IF(desconto = 1) THEN
			RETURN produto.valor - (produto.valor * 0.10);
		ELSE
			RETURN produto.valor;
		END IF;
	END LOOP;
END;

SELECT Valor AS VALOR_TOTAL, CalcularDesconto(ID, 1) AS VALOR_COM_DESCONTO FROM ProdutoPreco WHERE ID = 5;

-- Exercício 2
CREATE OR REPLACE VIEW ApenasLeituraProdutoPreco
AS
    SELECT ID FROM ProdutoPreco WITH READ ONLY;
    
SELECT * FROM ApenasLeituraProdutoPreco;

-- Exercício 3
CREATE OR REPLACE VIEW BuscarProduto
AS
    SELECT ID, IdProduto, Valor, Status, Cadastro 
    FROM ProdutoPreco
    WHERE Valor NOT BETWEEN 100 AND 200
    WITH CHECK OPTION;
   
UPDATE BuscarProduto SET Valor = 150 WHERE ID = 15; --Violação da cláusula
       
SELECT * FROM BuscarProduto;

-- Exercício 4
CREATE TABLE LOG(ID NUMBER, Campo VARCHAR2(100), ValorAntigo VARCHAR2(100), NomeTabela VARCHAR2(100));

SELECT * FROM LOG;

-- Exercício 5
CREATE OR REPLACE TRIGGER afterUpdateProduto
AFTER UPDATE ON Produto
REFERENCING NEW AS New
FOR EACH ROW

DECLARE
    linhaId Produto.Id%Type;
    linhaDescricao Produto.Descricao%Type;
    linhaEstoque Produto.QuantidadeEmEstoque%Type;
BEGIN
    linhaId := :New.ID;
    linhaDescricao := :New.Descricao;
    linhaEstoque := :New.QuantidadeEmEstoque;
   
    INSERT INTO Log(ID,  Campo, ValorAntigo, NomeTabela) VALUES (linhaId, linhaDescricao, linhaEstoque, 'Produto');
END;

UPDATE Produto SET QUANTIDADEEMESTOQUE = 80 WHERE ID = 7;

SELECT * FROM Log;

-- Exercício 6
CREATE OR REPLACE TRIGGER beforeUpdateProdutoPreco
BEFORE DELETE ON ProdutoPreco
REFERENCING Old AS Old
FOR EACH ROW

DECLARE
    linhaId ProdutoPreco.Id%Type;
    linhaValor ProdutoPreco.Valor%Type;
    linhaStatus ProdutoPreco.Status%Type;
BEGIN
    linhaId := :Old.ID;
    linhaValor := :Old.Valor;
    linhaStatus := :Old.Status;
   
    INSERT INTO Log(ID,  Campo, ValorAntigo, NomeTabela) VALUES (linhaId, linhaStatus, linhaValor, 'ProdutoPreco');
END;

INSERT INTO PRODUTOPRECO(ID, IDPRODUTO, VALOR, STATUS, CADASTRO) VALUES (16, 6, '1600', 1, SYSDATE);

DELETE FROM ProdutoPreco WHERE ID = 16;

SELECT * FROM Log;