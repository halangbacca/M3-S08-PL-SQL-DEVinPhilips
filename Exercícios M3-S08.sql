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