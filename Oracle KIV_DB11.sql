/* ---------------- Vytvoreni tabulek ------------------------- */
CREATE TABLE MESTO(
    c_mesto INTEGER PRIMARY KEY,
    nazev VARCHAR2(30 CHAR) NOT NULL,
    jmeno_vedouci VARCHAR2(30 CHAR) NOT NULL,
    prijmeni_vedouci VARCHAR2(30 CHAR) NOT NULL,
    cislo_telefonni VARCHAR2(11 CHAR) NOT NULL,
    mesto VARCHAR2(30 CHAR) NOT NULL,
    ulice VARCHAR2(30 CHAR) NOT NULL,
    cislo_popisne VARCHAR2(10 CHAR) NOT NULL,
    pcs VARCHAR2(7 CHAR) NOT NULL
);

CREATE TABLE KURYR(
    c_kuryr INTEGER PRIMARY KEY,
    jmeno VARCHAR2(30 CHAR) NOT NULL,
    prijmeni VARCHAR2(30 CHAR) NOT NULL,
    cislo_telefonni VARCHAR2(11 CHAR) NOT NULL,
    email VARCHAR2(50 CHAR) NOT NULL,
    mesto VARCHAR2(30 CHAR) NOT NULL,
    ulice VARCHAR2(30 CHAR) NOT NULL,
    cislo_popisne VARCHAR2(10 CHAR) NOT NULL,
    pcs VARCHAR2(7 CHAR) NOT NULL,
    c_mesta INTEGER NOT NULL
);
ALTER TABLE KURYR 
    ADD CONSTRAINT kuryr_mesto_fr FOREIGN KEY (c_mesta)
        REFERENCES MESTO(c_mesto);

CREATE TABLE AUTO(
    c_auto INTEGER PRIMARY KEY,
    spz VARCHAR2(8 CHAR) NOT NULL,
    datum_porizeni DATE NOT NULL,
    c_mesta INTEGER NOT NULL
);
ALTER TABLE AUTO
    ADD CONSTRAINT auto_mesto_fr FOREIGN KEY (c_mesta)
        REFERENCES MESTO(c_mesto);

CREATE TABLE SMENA(
    c_smena INTEGER PRIMARY KEY,
    zacatek TIMESTAMP(0) NOT NULL,
    konec TIMESTAMP(0) NOT NULL,
    vydelek NUMBER(2),
    c_kuryr INTEGER NOT NULL,
    c_auto INTEGER NOT NULL
);

ALTER TABLE SMENA
    ADD CONSTRAINT smena_kuryr_fr FOREIGN KEY (c_kuryr)
        REFERENCES KURYR(c_kuryr);

ALTER TABLE SMENA
    ADD CONSTRAINT smena_auto_fr FOREIGN KEY (c_auto)
        REFERENCES AUTO(c_auto);

CREATE TABLE PROVOZOVNA(
    c_provozovna INTEGER PRIMARY KEY,
    ico VARCHAR2(8 CHAR) NOT NULL,
    nazev VARCHAR2(50 CHAR)NOT NULL,
    jmeno_vedouci VARCHAR2(30 CHAR) NOT NULL,
    prijmeni_vedouci VARCHAR2(30 CHAR) NOT NULL,
    cislo_telefonni VARCHAR2(11 CHAR) NOT NULL,
    email VARCHAR2(50 CHAR) NOT NULL,
    mesto VARCHAR2(30 CHAR) NOT NULL,
    ulice VARCHAR2(30 CHAR) NOT NULL,
    cislo_popisne VARCHAR2(10 CHAR) NOT NULL,
    pcs VARCHAR2(7 CHAR) NOT NULL,
    c_mesta INTEGER NOT NULL
);

ALTER TABLE PROVOZOVNA
    ADD CONSTRAINT provozovna_mesto_fr FOREIGN KEY (c_mesta)
        REFERENCES MESTO(c_mesto);

CREATE TABLE DPH(
     k_dph INTEGER PRIMARY KEY,
     hodnota_dph FLOAT(5) NOT NULL
);

CREATE TABLE PRODUKT(
    c_produkt INTEGER PRIMARY KEY,
    nazev VARCHAR2(100 CHAR) NOT NULL,
    cena_bez_dph NUMBER(*, 2) NOT NULL,
    cena_s_dph NUMBER(*, 2) NOT NULL,
    c_provozovna INTEGER NOT NULL,
    c_dph INTEGER NOT NULL
);

ALTER TABLE PRODUKT
    ADD CONSTRAINT produkt_provozovna_fk FOREIGN KEY (c_provozovna)
        REFERENCES PROVOZOVNA(c_provozovna);
        
ALTER TABLE PRODUKT
    ADD CONSTRAINT produkt_dph_fk FOREIGN KEY (c_dph)
        REFERENCES DPH(k_dph);

CREATE TABLE POLOZKA_OBJEDNAVKY(
    c_polozka INTEGER PRIMARY KEY,
    pocet INTEGER NOT NULL,
    cena_ks_bez_dph NUMBER(*, 2) NOT NULL,
    cena_ks_s_dph NUMBER(*, 2) NOT NULL,
    cena_celkem_bez_dph NUMBER(*, 2) AS (pocet * cena_ks_bez_dph),
    cena_celkem_s_dph NUMBER(*, 2) AS (pocet * cena_ks_s_dph),
    c_objednavka INTEGER NOT NULL,
    c_produkt INTEGER NOT NULL
);

CREATE TABLE ZAKAZNIK(
    c_zakaznik INTEGER PRIMARY KEY,
    jmeno VARCHAR2(30 CHAR) NOT NULL,
    prijmeni VARCHAR2(30 CHAR) NOT NULL,
    heslo VARCHAR2(30 CHAR) NOT NULL,
    cislo_telefonni VARCHAR2(11 CHAR) NOT NULL,
    email VARCHAR2(50 CHAR) NOT NULL,
    mesto VARCHAR2(30 CHAR) NOT NULL,
    ulice VARCHAR2(30 CHAR) NOT NULL,
    cislo_popisne VARCHAR2(10 CHAR) NOT NULL,
    pcs VARCHAR2(7 CHAR) NOT NULL
);

CREATE TABLE STAV(
    k_stav INTEGER PRIMARY KEY,
    nazev VARCHAR2(20 CHAR) NOT NULL
);

CREATE TABLE ZPUSOB_PLATBY(
    k_platba INTEGER PRIMARY KEY,
    nazev_platba VARCHAR2(20 CHAR) NOT NULL
);

CREATE TABLE OBJEDNAVKA(
    c_objednavka INTEGER PRIMARY KEY,
    cas_zadani TIMESTAMP(0) NOT NULL,
    cas_vyrizeni TIMESTAMP(0) NOT NULL,
    /*cena_celkem_bez_dph NUMBER(*, 2),*/
    /*cena_celkem_s_dph NUMBER(*, 2),*/
    c_zakaznik INTEGER NOT NULL,
    c_provozovna INTEGER NOT NULL,
    c_smena INTEGER NOT NULL,
    k_stav INTEGER NOT NULL,
    k_zpusob_platby INTEGER NOT NULL
);

ALTER TABLE OBJEDNAVKA
    ADD CONSTRAINT objednavka_zakaznik_fk FOREIGN KEY (c_zakaznik)
        REFERENCES ZAKAZNIK(c_zakaznik);
        
ALTER TABLE OBJEDNAVKA
    ADD CONSTRAINT objednavka_provozovna_fk FOREIGN KEY (c_provozovna)
        REFERENCES PROVOZOVNA(c_provozovna);

ALTER TABLE OBJEDNAVKA
    ADD CONSTRAINT objednavka_smena_fk FOREIGN KEY (c_smena)
        REFERENCES SMENA(c_smena);

ALTER TABLE OBJEDNAVKA
    ADD CONSTRAINT objednavka_stav_fk FOREIGN KEY (k_stav)
        REFERENCES STAV(k_stav);
        
ALTER TABLE OBJEDNAVKA
    ADD CONSTRAINT objednavka_zpusob_platby_fk FOREIGN KEY (k_zpusob_platby)
        REFERENCES ZPUSOB_PLATBY(k_platba);
        
/* -------------------- Vlozeni dat do tabulek ---------------------- */
/* -------------------- Naplneni èíselníkù -------------------------- */
INSERT ALL
    INTO zpusob_platby VALUES (10, 'hotovost')
    INTO zpusob_platby VALUES (20, 'karta')
    INTO zpusob_platby VALUES (30, 'stravenky')
SELECT 1 FROM DUAL;    

INSERT ALL
    INTO stav VALUES (10, 'doruceno')
    INTO stav VALUES (20, 'zadano')
    INTO stav VALUES (30, 'zruseno')
SELECT 1 FROM DUAL; 

INSERT ALL
    INTO dph VALUES (10, 10)
    INTO dph VALUES (20, 15)
    INTO dph VALUES (30, 21)
SELECT 1 FROM DUAL; 
/* --------------------- Mesto --------------------------------------- */
INSERT INTO mesto VALUES (1, 'Plzeò', 'Petr', 'Kupka', '789 823 946', 'Plzeò', 'Jateèní', '2698', '301 00');
/* --------------------- Ostatni ------------------------------------- */

INSERT ALL
    INTO zakaznik VALUES (1, 'Pavel', 'Novák','Password01', '723 487 691', 'pavel.novak@gmail.com', 'Plzeò', 'V Bezovce', '1909/4', '301 00')
    INTO zakaznik VALUES (2, 'Michal', 'Malík', 'ASDfg9036', '798 124 258', 'mmalik@gmail.com', 'Plzeò', 'Doudlevecká', '235/18', '301 00')
    INTO zakaznik VALUES (3, 'Josef', 'Èerný', 'C0p7kB1c6J53mS1M0h1', '606 548 354', 'black.pepa@centrum.cz', 'Plzeò', 'V Lomech', '1032/9a', '323 00')
SELECT 1 FROM DUAL; 

INSERT ALL
    INTO kuryr VALUES (1, 'Michal', 'Havlíèek', '723 894 186', 'michaelhavlis@gmail.com', 'Plzeò', 'Jetelová', '1737/13', '326 00', 1)
    INTO kuryr VALUES (2, 'Adam', 'Urban', '715 175 179', 'adam.urban@seznam.cz', 'Plzeò', 'Raisova', '2205/33', '301 00', 1)
    INTO kuryr VALUES (3, 'Štìpán', 'Ošlejšek', '726 752 751', 'sepai.stepulin@gmail.com', 'Plzeò', 'Bolevecká', '914/32', '301 00', 1)
SELECT 1 FROM DUAL; 

INSERT ALL
    INTO auto VALUES (1, '2P99461', TO_DATE('20-09-2017'), 1)
    INTO auto VALUES (2, '4P90888', TO_DATE('20-10-2018'), 1)
    INTO auto VALUES (3, '5P57785', TO_DATE('03-10-2018'), 1)
SELECT 1 FROM DUAL; 

INSERT ALL
    INTO provozovna VALUES (1, '01415212', 'Uctívaný Velbloud', 'Filip', 'Franta', '377 224 897', 'info@uctivanyvelbloud.cz', 'Plzeò', 'Americká', '778/20', '301 00', 1)
    INTO provozovna VALUES (2, '29422168', 'LOKÁL Pod Divadlem', 'Jakub', 'Toth', '778 726 191', 'poddivadlem@ambi.cz', 'Plzeò', 'Bezruèova', '315/34', '301 00', 1)
    INTO provozovna VALUES (3, '25348758', 'ALANYA KEBAB', 'Jakub', 'Neubauer', '725 665 801', 'alanya.kebab@gmail.com', 'Plzeò', 'Rooseveltova', '9/7', '301 00', 1)
SELECT 1 FROM DUAL; 

INSERT ALL
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (1, 'Hovìzí svíèková na smetanì, kynutý knedlík', 152.15, 179, 1, 20)
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (2, 'Hovìzí tatarák z mladého býèka, 4 ks topinek', 158.10, 186, 1, 20)
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (3, 'Pilsner Urquell 12° z tanku', 38.71, 49, 1, 30)
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (4, 'Øízek z vepøové kotlety smažený na másle ', 177.65, 209, 2, 20)
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (5, 'Steak z vepøové krkovice s hoøèiènou omáèkou', 237.15, 279, 2, 20)
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (6, 'Žloutkový vìneèek', 62.1, 69, 2, 10)
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (7, '2x Dürüm s masem + 2x Coca-Cola 330ml', 214.2, 252, 3, 20)
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (8, 'Coca-Cola - DÜRÜM MENU', 184.45, 217, 3, 20)
    INTO produkt (c_produkt, nazev, cena_bez_dph, cena_s_dph, c_provozovna, c_dph) VALUES (9, 'Lahmacun s masem a sýrem ', 130.05, 153, 3, 20)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (1, TO_TIMESTAMP('31-08-2021 09:59:24'), TO_TIMESTAMP('31-08-2021 16:13:41'), 1, 1)
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (2, TO_TIMESTAMP('10-09-2021 15:48:47'), TO_TIMESTAMP('10-09-2021 22:01:12'), 1, 1)
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (3, TO_TIMESTAMP('20-10-2021 10:02:15'), TO_TIMESTAMP('20-10-2021 21:48:18'), 1, 3)
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (4, TO_TIMESTAMP('02-09-2021 09:55:27'), TO_TIMESTAMP('02-09-2021 17:24:53'), 2, 2)
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (5, TO_TIMESTAMP('14-09-2021 08:58:36'), TO_TIMESTAMP('14-09-2021 20:51:42'), 2, 2)
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (6, TO_TIMESTAMP('22-09-2021 10:00:03'), TO_TIMESTAMP('22-09-2021 18:06:19'), 2, 1)
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (7, TO_TIMESTAMP('01-09-2021 15:59:54'), TO_TIMESTAMP('01-09-2021 21:58:15'), 3, 3)
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (8, TO_TIMESTAMP('17-09-2021 16:03:52'), TO_TIMESTAMP('17-09-2021 22:32:05'), 3, 2)
    INTO smena (c_smena, zacatek, konec, c_kuryr, c_auto) VALUES (9, TO_TIMESTAMP('02-10-2021 16:24:53'), TO_TIMESTAMP('02-10-2021 20:54:47'), 3, 1)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (1, TO_TIMESTAMP('31-08-2021 11:25:45'), TO_TIMESTAMP('31-08-2021 11:50:49'), 1, 1, 1, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (2, TO_TIMESTAMP('31-08-2021 13:49:02'), TO_TIMESTAMP('31-08-2021 14:35:20'), 2, 2, 1, 10, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (3, TO_TIMESTAMP('31-08-2021 12:30:21'), TO_TIMESTAMP('31-08-2021 13:07:50'), 3, 1, 1, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (4, TO_TIMESTAMP('10-09-2021 17:31:25'), TO_TIMESTAMP('10-09-2021 17:56:12'), 1, 3, 2, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (5, TO_TIMESTAMP('10-09-2021 18:05:32'), TO_TIMESTAMP('10-09-2021 18:21:14'), 2, 2, 2, 10, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (6, TO_TIMESTAMP('10-09-2021 20:20:20'), TO_TIMESTAMP('10-09-2021 20:54:19'), 3, 3, 2, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (7, TO_TIMESTAMP('20-10-2021 11:45:54'), TO_TIMESTAMP('20-10-2021 12:09:15'), 1, 1, 3, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (8, TO_TIMESTAMP('20-10-2021 14:15:23'), TO_TIMESTAMP('20-10-2021 14:54:11'), 2, 2, 3, 10, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (9, TO_TIMESTAMP('20-10-2021 20:14:14'), TO_TIMESTAMP('20-10-2021 20:54:48'), 3, 3, 3, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (10, TO_TIMESTAMP('02-09-2021 10:52:12'), TO_TIMESTAMP('02-09-2021 11:25:31'), 1, 3, 4, 30, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (11, TO_TIMESTAMP('02-09-2021 12:43:13'), TO_TIMESTAMP('02-09-2021 13:12:45'), 3, 2, 4, 10, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (12, TO_TIMESTAMP('02-09-2021 15:12:51'), TO_TIMESTAMP('02-09-2021 15:45:41'), 2, 1, 4, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (13, TO_TIMESTAMP('14-09-2021 09:52:15'), TO_TIMESTAMP('14-09-2021 10:12:55'), 1, 3, 5, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (14, TO_TIMESTAMP('14-09-2021 12:12:52'), TO_TIMESTAMP('14-09-2021 12:51:12'), 2, 2, 5, 10, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (15, TO_TIMESTAMP('14-09-2021 18:25:52'), TO_TIMESTAMP('14-09-2021 19:02:15'), 3, 3, 5, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (16, TO_TIMESTAMP('22-09-2021 11:52:51'), TO_TIMESTAMP('22-09-2021 12:22:15'), 1, 1, 6, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (17, TO_TIMESTAMP('22-09-2021 13:25:16'), TO_TIMESTAMP('22-09-2021 13:59:18'), 3, 2, 6, 10, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (18, TO_TIMESTAMP('22-09-2021 16:48:37'), TO_TIMESTAMP('22-09-2021 17:23:19'), 2, 3, 6, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (19, TO_TIMESTAMP('01-09-2021 16:12:42'), TO_TIMESTAMP('01-09-2021 16:42:19'), 1, 1, 7, 10, 30)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (20, TO_TIMESTAMP('01-09-2021 18:09:15'), TO_TIMESTAMP('01-09-2021 18:59:08'), 2, 2, 7, 30, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (21, TO_TIMESTAMP('01-09-2021 19:00:48'), TO_TIMESTAMP('01-09-2021 19:42:00'), 3, 3, 7, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (22, TO_TIMESTAMP('17-09-2021 16:45:29'), TO_TIMESTAMP('17-09-2021 17:09:45'), 1, 3, 8, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (23, TO_TIMESTAMP('17-09-2021 18:43:18'), TO_TIMESTAMP('17-09-2021 19:05:14'), 2, 2, 8, 10, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (24, TO_TIMESTAMP('17-09-2021 19:14:51'), TO_TIMESTAMP('17-09-2021 19:58:15'), 3, 1, 8, 10, 30)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (25, TO_TIMESTAMP('02-10-2021 17:01:15'), TO_TIMESTAMP('02-10-2021 17:37:17'), 1, 3, 9, 10, 10)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (26, TO_TIMESTAMP('02-10-2021 18:41:18'), TO_TIMESTAMP('02-10-2021 19:08:50'), 3, 2, 9, 10, 20)
    INTO objednavka (c_objednavka, cas_zadani, cas_vyrizeni, c_zakaznik, c_provozovna, c_smena, k_stav, k_zpusob_platby) VALUES (27, TO_TIMESTAMP('02-10-2021 19:41:51'), TO_TIMESTAMP('02-10-2021 19:50:04'), 2, 3, 9, 30, 10)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (1, 1, 1, 1, 152.15, 179)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (2, 4, 2, 1, 177.65, 209)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (3, 2, 3, 1, 158.1, 186)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (4, 8, 4, 3, 184.45, 217)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (5, 5, 5, 1, 237.15, 279)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (6, 9, 6, 2, 130.05, 153)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (7, 3, 7, 1, 38.71, 49)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (8, 6, 8, 2, 62.1, 69)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (9, 9, 9, 1, 130.05, 153)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (10, 8, 10, 1, 184.45, 217)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (11, 5, 11, 2, 237.15, 279)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (12, 7, 12, 1, 214.2, 252)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (13, 4, 13, 1, 177.65, 209)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (14, 8, 14, 1, 184.45, 217)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (15, 1, 15, 2, 152.15, 179)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (16, 5, 16, 1, 237.15, 279)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (17, 7, 17, 1, 214.2, 252)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (18, 7, 18, 3, 214.2, 252)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (19, 2, 19, 1, 158.1, 186)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (20, 5, 20, 1, 237.15, 279)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (21, 8, 21, 1, 184.45, 217)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (22, 8, 22, 1, 184.45, 217)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (23, 5, 23, 2, 237.15, 279)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (24, 2, 24, 1, 158.1, 186)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (25, 9, 25, 5, 130.05, 153)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (26, 6, 26, 1, 62.1, 69)
    INTO polozka_objednavky (c_polozka, c_produkt, c_objednavka, pocet, cena_ks_bez_dph, cena_ks_s_dph) VALUES (27, 7, 27, 4, 214.2, 252)
SELECT 1 FROM DUAL;
/*INTO polozka_objednavky (c_polozka, pocet, c_objednavka, c_produkt) VALUES ()*/

/* -------------------- Selecty a pohledy ------------------------------------- */
/* SMENY USKUTECNENE V MESICI ZARI */
CREATE VIEW smeny_v_mesici_zari AS        
    SELECT smena.c_smena, objednavka.c_smena AS c_smeny, TO_CHAR(smena.zacatek, 'DD-MM-YYYY') AS datum , kuryr.jmeno, kuryr.prijmeni, auto.spz, COUNT(objednavka.c_objednavka) AS vyrizenych_objednavek, COUNT(objednavka.c_objednavka) * 40 AS odmena, auto.c_auto AS auto, smena.c_auto, kuryr.c_kuryr, smena.c_kuryr AS kuryr
    FROM smena smena
        INNER JOIN objednavka objednavka
            ON smena.c_smena = objednavka.c_smena
        INNER JOIN auto auto
            ON smena.c_auto = auto.c_auto
        INNER JOIN kuryr kuryr
            ON smena.c_kuryr = kuryr.c_kuryr
        WHERE objednavka.k_stav = 10 AND smena.zacatek BETWEEN '01-09-2021 00:00:01' AND '30-09-2021 23:59:59'
    GROUP BY smena.c_smena, objednavka.c_smena, smena.zacatek, kuryr.jmeno, kuryr.prijmeni, auto.spz, auto.c_auto, smena.c_auto, kuryr.c_kuryr, smena.c_kuryr;

CREATE VIEW objednavky_pavla_novaka AS    
    SELECT objednavka.c_objednavka, TO_CHAR(objednavka.cas_vyrizeni, 'DD-MM-YYYY') AS datum, CONCAT(CONCAT(zakaznik.jmeno, ' '), zakaznik.prijmeni) AS zakaznik, CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(zakaznik.ulice, ' '), zakaznik.cislo_popisne),', '), zakaznik.mesto), ' '), zakaznik.pcs) AS adresa_doruceni, SUM(polozka.cena_celkem_s_dph) AS cena, stav.nazev AS stav, platba.nazev_platba AS zpusob_platby, provozovna.nazev AS restaurace, CONCAT(CONCAT(kuryr.jmeno, ' '), kuryr.prijmeni) AS kuryr
    FROM objednavka objednavka
       INNER JOIN zakaznik zakaznik
           ON zakaznik.c_zakaznik = objednavka.c_zakaznik
       INNER JOIN polozka_objednavky polozka
          ON polozka.c_objednavka = objednavka.c_objednavka
       INNER JOIN stav stav
           ON stav.k_stav = objednavka.k_stav
       INNER JOIN zpusob_platby platba
           ON platba.k_platba = objednavka.k_zpusob_platby
       INNER JOIN provozovna provozovna
           ON provozovna.c_provozovna = objednavka.c_provozovna
       INNER JOIN smena smena
          ON smena.c_smena = objednavka.c_smena
       INNER JOIN kuryr kuryr
           ON smena.c_kuryr = kuryr.c_kuryr
        WHERE zakaznik.jmeno LIKE 'Pavel' AND zakaznik.prijmeni LIKE 'Novák'
    GROUP BY objednavka.c_objednavka, objednavka.cas_vyrizeni, zakaznik.jmeno, zakaznik.prijmeni, zakaznik.ulice, zakaznik.cislo_popisne, zakaznik.mesto, zakaznik.pcs, stav.nazev, platba.nazev_platba, provozovna.nazev, kuryr.jmeno, kuryr.prijmeni;

/* -------------------- Smazani tabulek ----------------------------- */
DROP TABLE OBJEDNAVKA;
DROP TABLE POLOZKA_OBJEDNAVKY;
DROP TABLE PRODUKT;
DROP TABLE ZAKAZNIK;
DROP TABLE STAV;
DROP TABLE ZPUSOB_PLATBY;
DROP TABLE SMENA;
DROP TABLE DPH;
DROP TABLE PROVOZOVNA;
DROP TABLE KURYR;
DROP TABLE AUTO;
DROP TABLE MESTO;






