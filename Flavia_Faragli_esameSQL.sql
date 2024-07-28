CREATE DATABASE `giocattoli`;
USE `giocattoli`;

-- CREAZIONE DELLE TABELLE
CREATE TABLE `product` (
  `idProdotto` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `categoria` varchar(20) NOT NULL,
  `prezzo` decimal(6,2) NOT NULL,
  PRIMARY KEY (`idProdotto`)
);


CREATE TABLE `region` (
  `idRegione` int(11) NOT NULL,
  `nome` varchar(30) NOT NULL,
   PRIMARY KEY (`idRegione`)
);


CREATE TABLE `sales` (
  `numOrdine` int(11) NOT NULL,
  `numRigaOrdine` int(11) NOT NULL,
  `prodotto` int(11) NOT NULL,
  `quantita` int(11) NOT NULL,
  `data` date NOT NULL,
  `stato` varchar(30) NOT NULL,
  `regione` int(11) NOT NULL,
   PRIMARY KEY (`numOrdine`,`numRigaOrdine`),
   FOREIGN KEY (prodotto) REFERENCES product(idProdotto),
   FOREIGN KEY (regione) REFERENCES region(idRegione)
  );


-- INSERIMENTO DATI
INSERT INTO `product` (`idProdotto`, `nome`, `categoria`, `prezzo`) VALUES
(1, 'Play station 4', 'elettronici', '345.00'),
(2, 'triciclo', 'infanzia', '45.00'),
(3, 'allegro chirurgo', 'educativi', '23.66'),
(4, 'sapientino', 'educativi', '89.90'),
(5, 'kit spiaggia', 'estate', '8.50'),
(6, 'gavettoni', 'estate', '3.20'),
(7, 'furby', 'elettronici', '101.10'),
(8, 'pongo', 'infanzia', '1.50'),
(9, 'trenino', 'infanzia', '10.70'),
(10, 'braccioli', 'estate', '12.90'),
(11, 'game boy pocket', 'elettronici', '120.89');


INSERT INTO `region` (`idRegione`, `nome`) VALUES
(1, 'Nord Europa'),
(2, 'Sud Europa'),
(3, 'Asia'),
(4, 'Nord America');


INSERT INTO `sales` (`numOrdine`, `numRigaOrdine`, `prodotto`, `quantita`, `data`, `stato`, `regione`) VALUES
(1, 1, 8, 3, '2024-07-26', 'Italia', 2),
(1, 2, 10, 2, '2024-07-26', 'Italia', 2),
(1, 3, 2, 1, '2024-07-26', 'Italia', 2),
(2, 1, 1, 1, '2024-07-22', 'Spagna', 2),
(2, 2, 2, 1, '2024-07-22', 'Spagna', 2),
(3, 1, 7, 2, '2024-07-23', 'Canada', 4),
(3, 2, 4, 3, '2024-07-23', 'Canada', 4),
(3, 3, 3, 1, '2024-07-23', 'Canada', 4),
(4, 1, 4, 1, '2023-07-20', 'Corea del sud', 3),
(4, 2, 5, 1, '2023-07-20', 'Corea del sud', 3),
(4, 3, 6, 1, '2023-07-20', 'Corea del sud', 3),
(5, 1, 8, 2, '2023-12-15', 'Stoccolma', 1),
(6, 1, 1, 1, '2022-12-31', 'Estonia', 1),
(6, 2, 8, 5, '2022-12-31', 'Estonia', 1),
(7, 1, 8, 3, '2023-07-12', 'Italia', 2),
(7, 2, 10, 2, '2023-07-12', 'Italia', 2),
(7, 3, 2, 1, '2023-07-12', 'Italia', 2);

# 1. Verificare che i campi definiti come PK siano univoci.
    select idProdotto
    from product
    group by idProdotto
    having count(*) > 1;

    select idRegione
    from region
    group by idRegione
    having count(*) > 1;

select numOrdine, numRigaOrdine
    from sales
    group by numOrdine, numRigaOrdine
    having count(*) > 1;

# 2. Esporre l'elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno. => OK
    select p.idProdotto, p.nome, year(data) as anno, sum(p.prezzo * s.quantita) as totaleSpeso
    from sales s join product p on (s.prodotto = p.idProdotto)
    group by p.idProdotto, p.nome, anno
    order by p.nome;


# 3. Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente. => OK
    select s.stato, year(data) as anno, sum(p.prezzo * s.quantita) as totaleSpeso
    from sales s join product p on (s.prodotto = p.idProdotto)
    group by s.stato, anno
    order by anno desc, totaleSpeso desc ;

# 4. Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?
select p.categoria
from sales s join product p on (s.prodotto = p.idProdotto)
group by p.categoria
order by sum(s.quantita) desc
limit 1;

# spiegazione
select p.categoria, sum(s.quantita) as prodottiTot
from sales s join product p on (s.prodotto = p.idProdotto)
group by p.categoria
order by sum(s.quantita) desc


# 5. Rispondere alla seguente domanda: quali sono, se ci sono, i prodotti invenduti?
# Proponi due approcci risolutivi differenti. approccio1

    select distinct p.idProdotto, p.nome
    from sales s right join product p on (s.prodotto = p.idProdotto)
    where s.data is null;

    # approccio2
    select p.idProdotto, p.nome
    from product p
    where p.idProdotto not in (select distinct p.idProdotto
        from sales s join product p on (s.prodotto = p.idProdotto)
    );


# Esporre l'elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente). => OK
    select p.idProdotto, p.nome, max(data)
    from sales s join product p on (s.prodotto = p.idProdotto)
    group by p.idProdotto, p.nome