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
    zacatek TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    konec TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
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
     hodnota_dph FLOAT(2) NOT NULL
);

CREATE TABLE PRODUKT(
    c_produkt INTEGER PRIMARY KEY,
    nazev VARCHAR2(60 CHAR) NOT NULL,
    cena_baz_dph NUMBER(2) NOT NULL,
    cena_s_dph NUMBER(2) NOT NULL,
    c_provozovna INTEGER NOT NULL,
    k_dph INTEGER NOT NULL
);

ALTER TABLE PRODUKT
    ADD CONSTRAINT produkt_provozovna_fk FOREIGN KEY (c_provozovna)
        REFERENCES PROVOZOVNA(c_provozovna);
        
ALTER TABLE PRODUKT
    ADD CONSTRAINT produkt_dph_fk FOREIGN KEY (k_dph)
        REFERENCES DPH(k_dph);

CREATE TABLE POLOZKA_OBJEDNAVKY(
    c_polozka INTEGER PRIMARY KEY,
    pocet INTEGER NOT NULL,
    cena_ks_bez_dph NUMBER(2) NOT NULL,
    cena_ks_s_dph NUMBER(2) NOT NULL,
    cena_celkem_bez_dph NUMBER(2) NOT NULL,
    cena_celkem_s_dph NUMBER(2) NOT NULL,
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
    k_pladba INTEGER PRIMARY KEY,
    nazev_paltba VARCHAR2(20 CHAR) NOT NULL
);

CREATE TABLE OBJEDNAVKA(
    c_objednavka INTEGER PRIMARY KEY,
    cas_zadani TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cas_vyrizeni TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    cena_celkem_bez_dph NUMBER(2) NOT NULL,
    cena_celkem_s_dph NUMBER(2) NOT NULL,
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

/* -------------------- Smazani tabulek ----------------------------- */
DROP TABLE MESTO;
DROP TABLE KURYR;
DROP TABLE AUTO;
DROP TABLE SMENA;
DROP TABLE PROVOZOVNA;
DROP TABLE DPH;
DROP TABLE POLOZKA;
DROP TABLE POLOZKA_OBJEDNAVKY;
DROP TABLE ZAKAZNIK;
DROP TABLE STAV;
DROP TABLE ZPUSOB_PLATBY;
DROP TABLE OBJEDNAVKA;
