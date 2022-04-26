use "C:\Users\txavier\OneDrive - TCI\Estudos\Mestrado INSPER\Mestrado\3T21\Métodos para avaliação de PP\Trabalho final\base_vacinação_completa.dta", clear 


gen dif_votos_opo_situ = dif_votos * -1 if partido2 == 0
replace  dif_votos_opo_situ = dif_votos if partido2 == 1

*------------------------------------------------------*
*CONDIÇÕES GERAIS PARA O USO DO RDD: de 1 à 3
*-------------------------------------------------------*
*1º Olhando índice de elegibilidade:

kdensity dif_votos_opo_situ
kdensity dif_votos_opo_situ if mês == 6

drop if dif_votos_opo_situ > 0.1 | dif_votos_opo_situ < -0.1

* O índice é contínuo ao longo de toda densidade, não parecem existir sinais de manipulação/descontinuidade no critério de elegibilidade, o que a princípio nos valida a utilizar o experimento.

*ps: o gráfico é editável diretamente como figura nessa versão.

*------------------------------------------------------*
*2º Verificando se a seleção ao tratamento, de fato, foi determinada pelo critério do cut-off ? E a conformidade é perfeita (100% dos elegíveis recebem o tratamento; 100% não elegíveis recebem o tratamento - ou seja, probabilidade de tratamento é 1 ou 0) ou não perfeita ? 


*Uma vez que selecionamos apenas prefeitos que venceram a eleição no primeiro turno e que não foram impedidos juridicamente de assumir o cargo, 
*Temos, por construção, a garantia de que: i) vencer a eleição determina que o candidado assuma a prefeitura.

*Resp: não há evidência de não continuidade. 

*------------------------------------------------------*
*3º O cut-off é exclusivo do programa ?

*O cut-off ligado ao resultado da votação determina o prefeito vencedor e não é utilizado para determinar outros programas ou políticas públicas.


*-----------------------------------------------------*
*1+2+3: O contexto de RDD parece apropriado para o atual cenário.


*------------------------------------------*
*ESTIMATIVAS - RDD
*------------------------------------------*
*I - Interpretação: A estimativa será um LATE = limitado às cidades cujos prefeitos eleitos foram eleitos com uma margem de votos x%, vencendo uma eleição em que no segundo colocado havia um prefeito de diferente orientação política/governismo, nos termos proposto do trabalho. 


*II - vou testar se a densidade é contínua em torno do cutt-off de 0%

rddensity  dif_votos_opo_situ, c(0) plot
RD Manipulation test using local polynomial density estimation.

RD Manipulation test using local polynomial density estimation.

     c =     0.000 | Left of c  Right of c          Number of obs =          295
-------------------+----------------------          Model         = unrestricted
     Number of obs |       148         147          BW method     =         comb
Eff. Number of obs |       102         112          Kernel        =   triangular
    Order est. (p) |         2           2          VCE method    =    jackknife
    Order bias (q) |         3           3
       BW est. (h) |     0.235       0.293

Running variable: dif_votos_opo_situ.
------------------------------------------
            Method |      T          P>|T|
-------------------+----------------------
            Robust |    0.2173      0.8280
------------------------------------------

*Olhando pvalor: H0 = não tem descontinuidade
*p>5%: não rejeito H0 = de que não tem descontinuidade (quero Pvalor grande e bem acima de 10%) 



*III - estimativas e gráficos


*1º Bloco - Hfixo e pVaria

*Default
rdrobust Vacinas  dif_votos_opo_situ if mês ==6, c(0) 



Sharp RD estimates using local polynomial regression.

      Cutoff c = 0 | Left of c  Right of c            Number of obs =        294
-------------------+----------------------            BW type       =      mserd
     Number of obs |       147         147            Kernel        = Triangular
Eff. Number of obs |       102         102            VCE method    =         NN
    Order est. (p) |         1           1
    Order bias (q) |         2           2
       BW est. (h) |     0.251       0.251
       BW bias (b) |     0.433       0.433
         rho (h/b) |     0.580       0.580

Outcome: Vacinas. Running variable: dif_votos_opo_situ.
--------------------------------------------------------------------------------
            Method |   Coef.    Std. Err.    z     P>|z|    [95% Conf. Interval]
-------------------+------------------------------------------------------------
      Conventional |  .02435     .01736   1.4024   0.161   -.009682      .058387
            Robust |     -          -     1.4754   0.140   -.009565      .067805
--------------------------------------------------------------------------------

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0)


*Polinômio de ordem 2 

rdrobust Vacinas  dif_votos_opo_situ if mês ==6, c(0) p(2)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(2)


*Polinômio de ordem 3 

rdrobust Vacinas  dif_votos_opo_situ if mês ==6, c(0) p(3)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(3)

help rdrobust

*2º Bloco - Hvaria pVaria
*H = 5% e P = 1 
rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(1) h(0.05)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(1) h(0.05)

*H = 5% e P = 2 
rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(2) h(0.05)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(2) h(0.05)



*H = 10% e P = 1 
rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(1) h(0.10)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(1) h(0.10)


*H = 10% e P = 2 

rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(2) h(0.10)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(2) h(0.10)



*H = 10% e P = 3

rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(3) h(0.10)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(3) h(0.10)


*H = 15% e P=1 

rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(1) h(0.15)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(1) h(0.15)


*H = 15% e P= 2
rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(2) h(0.15)

rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) p(2) h(0.15)



*H = 20% e P=1 
rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(1) h(0.20)
rdplot Vacinas dif_votos_opo_situ if mês ==6, c(0) p(1) h(0.20)

*******
*Dúvidas
*Como fazer com os meses: reportam todos ?
*Diferença de votos  
*Será que valeria a pena variar o peso/ponderação de cada observação: dar mais peso para aquelas observações mais próximas do cutt-off?


******
*Testes adicionais: ponderação de observações e com covariadas 

*Default
rdrobust Vacinas dif_votos_opo_situ if mês == 4, c(0) p(1) h(0.09) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 5, c(0) p(1) h(0.09) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 6, c(0) p(1) h(0.09) weights(dif_votos) 

rdrobust Vacinas dif_votos_opo_situ if mês == 4, c(0) p(1) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 5, c(0) p(1) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 6, c(0) p(1) h(0.10) weights(dif_votos) 


rdrobust Vacinas dif_votos_opo_situ if mês ==6, c(0) p(1) h(0.10) weights(dif_votos) covs(Cob_hist)

*TESTANTO BALANCEAMENTO ENTRE TRATADO E CONTROLE PARA COVARIADAS:

gen direita_cut_off = 1 if dif_votos_opo_situ > 0 & dif_votos_opo_situ < 0.10 
replace direita_cut_off = 0 if dif_votos_opo_situ < 0 | dif_votos_opo_situ > 0.10 
 
gen esquerda_cut_off = 1 if dif_votos_opo_situ < 0 & dif_votos_opo_situ > -0.10 
replace esquerda_cut_off = 0 if dif_votos_opo_situ > 0 | dif_votos_opo_situ < - 0.10 

gen posição_cut_off = 1 if dif_votos_opo_situ > 0 & dif_votos_opo_situ < 0.10 
replace posição_cut_off = 0 if dif_votos_opo_situ < 0 & dif_votos_opo_situ > -0.10 

1 = lado direito = oposição
0 = lado esquerdo = situação


sum Cob_hist posição_cut_off 

* Distribuição do histórico da cobertura vacinal: na média são semelhantes

ttest Cob_hist if mês == 4, by(posição_cut_off) 

. ttest Cob_hist if mês == 4, by(posição_cut_off) 

Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
       0 |      61    .8452459    .0131295    .1025444    .8189831    .8715087
       1 |      52    .8686538    .0127247     .091759     .843108    .8941997
---------+--------------------------------------------------------------------
combined |     113    .8560177    .0092193    .0980027    .8377508    .8742846
---------+--------------------------------------------------------------------
    diff |           -.0234079    .0184472               -.0599624    .0131465
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =  -1.2689
Ho: diff = 0                                     degrees of freedom =      111

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.1036         Pr(|T| > |t|) = 0.2071          Pr(T > t) = 0.8964
 
 
 
 
* Distribuição da parcela de IDHM na população: na média NÃO são semelhantes à 10%

. ttest IDHM if mês == 4, by(posição_cut_off) 


Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
       0 |      61    .7398525    .0039963    .0312121    .7318587    .7478462
       1 |      52    .7306346    .0036936    .0266348    .7232194    .7380498
---------+--------------------------------------------------------------------
combined |     113    .7356106    .0027687    .0294317    .7301248    .7410964
---------+--------------------------------------------------------------------
    diff |            .0092178     .005511               -.0017025    .0201382
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =   1.6726
Ho: diff = 0                                     degrees of freedom =      111

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.9514         Pr(|T| > |t|) = 0.0972          Pr(T > t) = 0.0486



 
 * Distribuição de total de UBS per capita: na média são semelhante
 
ttest Pop_cnes_ubs if mês == 4, by(posição_cut_off) 


Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
       0 |      60    4175.731     304.292    2357.035    3566.844    4784.618
       1 |      50    4496.529    472.1379    3338.519    3547.733    5445.326
---------+--------------------------------------------------------------------
combined |     110    4321.549      270.41    2836.084    3785.605    4857.492
---------+--------------------------------------------------------------------
    diff |           -320.7983    544.7032               -1400.495     758.898
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =  -0.5889
Ho: diff = 0                                     degrees of freedom =      108

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.2786         Pr(|T| > |t|) = 0.5571          Pr(T > t) = 0.7214

 
  * Distribuição do volume do PIB pc: na média são semelhante
ttest PIB_pc if mês == 4, by(posição_cut_off) 


Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
       0 |      61    30.69461    2.127398    16.61551    26.43918    34.95004
       1 |      52    32.51468    3.066355     22.1118    26.35872    38.67065
---------+--------------------------------------------------------------------
combined |     113    31.53216     1.81285    19.27086    27.94023    35.12409
---------+--------------------------------------------------------------------
    diff |           -1.820074    3.649516               -9.051833    5.411685
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =  -0.4987
Ho: diff = 0                                     degrees of freedom =      111

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.3095         Pr(|T| > |t|) = 0.6190          Pr(T > t) = 0.690


 *Distribuição do volume do total Pop: na média são semelhante
 ttest Pop if mês == 4, by(posição_cut_off) 
 
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
       0 |      61    26677.93    5280.046    41238.48    16116.27     37239.6
       1 |      52    17263.65    3422.101    24677.12     10393.5    24133.81
---------+--------------------------------------------------------------------
combined |     113     22345.7    3273.046    34792.96    15860.58    28830.82
---------+--------------------------------------------------------------------
    diff |            9414.281    6535.667                -3536.58    22365.14
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =   1.4404
Ho: diff = 0                                     degrees of freedom =      111

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.9237         Pr(|T| > |t|) = 0.1526          Pr(T > t) = 0.0763

 

*Estimações Principais
 global controls Densidade IDHM  Grauurba 
  global controls IDHM  LnDensidade
 
rdrobust Vacinas dif_votos_opo_situ if mês == 4, c(0) p(1) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 5, c(0) p(1) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 6, c(0) p(1) h(0.10) weights(dif_votos)
 
rdplot Vacinas dif_votos_opo_situ if mês == 4, c(0) h(0.10) ytitle(Vacinas) xtitle(dif_votos_opo_situ) p(1)
rdplot Vacinas dif_votos_opo_situ if mês == 5, c(0) h(0.10) ytitle(Vacinas) xtitle(dif_votos_opo_situ) p(1)
rdplot Vacinas dif_votos_opo_situ if mês == 6, c(0) h(0.10) ytitle(Vacinas) xtitle(dif_votos_opo_situ) p(1)
 

rdrobust Vacinas dif_votos_opo_situ if mês == 4, covs($controls) c(0) p(2) h(0.05) weights(dif_votos)  
rdrobust Vacinas dif_votos_opo_situ if mês == 5, covs($controls) c(0) p(2) h(0.05) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 6, covs($controls) c(0) p(2) h(0.05) weights(dif_votos) 

rdplot Vacinas dif_votos_opo_situ if mês == 4, covs($controls) c(0) p(2) h(0.05) weights(dif_votos)  
rdplot Vacinas dif_votos_opo_situ if mês == 5, covs($controls) c(0) p(2) h(0.05) weights(dif_votos) 
rdplot Vacinas dif_votos_opo_situ if mês == 6, covs($controls) c(0) p(2) h(0.05) weights(dif_votos) 


rdrobust Vacinas dif_votos_opo_situ if mês == 4, covs($controls) c(0) p(1) h(0.10) weights(dif_votos)  
rdrobust Vacinas dif_votos_opo_situ if mês == 5, covs($controls) c(0) p(1) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 6, covs($controls) c(0) p(1) h(0.10) weights(dif_votos) 


coefplot 

help coefplot


 
rdplot Vacinas dif_votos_opo_situ if mês == 4, c(0) h(0.10) p(1)


rdrobust Vacinas dif_votos_opo_situ if mês == 4, c(0) p(1) h(0.10) weights(dif_votos) 

Sharp RD estimates using local polynomial regression.

      Cutoff c = 0 | Left of c  Right of c            Number of obs =        294
-------------------+----------------------            BW type       =     Manual
     Number of obs |       147         147            Kernel        = Triangular
Eff. Number of obs |        60          52            VCE method    =         NN
    Order est. (p) |         1           1
    Order bias (q) |         2           2
       BW est. (h) |     0.100       0.100
       BW bias (b) |     0.100       0.100
         rho (h/b) |     1.000       1.000

Outcome: Vacinas. Running variable: dif_votos_opo_situ.
--------------------------------------------------------------------------------
            Method |   Coef.    Std. Err.    z     P>|z|    [95% Conf. Interval]
-------------------+------------------------------------------------------------
      Conventional |   .0034     .02802   0.1215   0.903   -.051521      .058328
            Robust |     -          -     -1.4735  0.141   -.169454       .02401
--------------------------------------------------------------------------------


. rdrobust Vacinas dif_votos_opo_situ if mês == 5, c(0) p(1) h(0.10) weights(dif_votos) 

Sharp RD estimates using local polynomial regression.

      Cutoff c = 0 | Left of c  Right of c            Number of obs =        294
-------------------+----------------------            BW type       =     Manual
     Number of obs |       147         147            Kernel        = Triangular
Eff. Number of obs |        60          52            VCE method    =         NN
    Order est. (p) |         1           1
    Order bias (q) |         2           2
       BW est. (h) |     0.100       0.100
       BW bias (b) |     0.100       0.100
         rho (h/b) |     1.000       1.000

Outcome: Vacinas. Running variable: dif_votos_opo_situ.
--------------------------------------------------------------------------------
            Method |   Coef.    Std. Err.    z     P>|z|    [95% Conf. Interval]
-------------------+------------------------------------------------------------
      Conventional |  .05107     .02846   1.7942   0.073   -.004717      .106859
            Robust |     -          -     0.6880   0.491    -.06033      .125602
--------------------------------------------------------------------------------


. rdrobust Vacinas dif_votos_opo_situ if mês == 6, c(0) p(1) h(0.10) weights(dif_votos) 

Sharp RD estimates using local polynomial regression.

      Cutoff c = 0 | Left of c  Right of c            Number of obs =        294
-------------------+----------------------            BW type       =     Manual
     Number of obs |       147         147            Kernel        = Triangular
Eff. Number of obs |        60          52            VCE method    =         NN
    Order est. (p) |         1           1
    Order bias (q) |         2           2
       BW est. (h) |     0.100       0.100
       BW bias (b) |     0.100       0.100
         rho (h/b) |     1.000       1.000

Outcome: Vacinas. Running variable: dif_votos_opo_situ.
--------------------------------------------------------------------------------
            Method |   Coef.    Std. Err.    z     P>|z|    [95% Conf. Interval]
-------------------+------------------------------------------------------------
      Conventional |  .05604     .03948   1.4195   0.156   -.021339      .133425
            Robust |     -          -     0.7529   0.452    -.08257      .185573
--------------------------------------------------------------------------------


rdrobust Vacinas dif_votos_opo_situ if mês == 4, c(0) p(2) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 5, c(0) p(2) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 6, c(0) p(2) h(0.10) weights(dif_votos)


rdrobust Vacinas dif_votos_opo_situ if mês == 4, covs($controls) c(0) p(1) h(0.10) weights(dif_votos)  
rdrobust Vacinas dif_votos_opo_situ if mês == 5, covs($controls) c(0) p(1) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 6, covs($controls) c(0) p(1) h(0.10) weights(dif_votos) 


rdrobust Vacinas dif_votos_opo_situ if mês == 4, covs($controls) c(0) p(2) h(0.1) weights(dif_votos)  
rdrobust Vacinas dif_votos_opo_situ if mês == 5, covs($controls) c(0) p(2) h(0.1) weights(dif_votos)  
rdrobust Vacinas dif_votos_opo_situ if mês == 6, covs($controls) c(0) p(2) h(0.1) weights(dif_votos)  

drop if dif_votos_opo_situ > 0.1 |  dif_votos_opo_situ < -0.10

drop if dif_votos_opo_situ > 0.05 |  dif_votos_opo_situ < -0.05


*CUT-OFF FALSOS

rdrobust Vacinas dif_votos_opo_situ if mês == 4, c(0.05) p(1) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 5, c(0) p(1) h(0.10) weights(dif_votos) 
rdrobust Vacinas dif_votos_opo_situ if mês == 6, c(0) p(1) h(0.10) weights(dif_votos)
