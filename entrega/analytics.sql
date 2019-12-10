SELECT count(*)
    FROM f_anomalia
    NATURAL JOIN d_utilizador
    NATURAL JOIN d_lingua
    NATURAL JOIN d_tempo
    GROUP BY CUBE (d_utilizador.tipo, d_lingua.lingua, d_tempo.dia_da_semana);
