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