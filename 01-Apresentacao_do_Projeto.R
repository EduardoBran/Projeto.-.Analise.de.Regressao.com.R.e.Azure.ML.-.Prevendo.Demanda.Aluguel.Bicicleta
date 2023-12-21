####  Análise de Regressão com Linguagem R e Azure Machine Learning  ####

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/14.Projeto-de-Analise-de-Regressao-com-R-e-Azure-ML-Prevendo_Demanda_Aluguel_Bicicleta")
getwd()

## Processo de Data Science Para Análise de Big Data (Big Data Analytics)

# - Compreender o Problema de Negócio
# - Coletar os Dados
# - Explorar, Limpar e Preparar os Dados
# - Selecionar e Transformar as Variáveis
# - Construir, Testar, Avaliar e Otimizar o Modelo
# - Contar a História dos Dados (Apresentar o resultado de todo esse resultado de análise)                      A


## Definindo o Problema de Negócio

# Sumário

# - Este experimento tem como objetivo criar um modelo preditivo para estimar a demanda pelo aluguel
#   de bicicletas

# Descrição

# - Este experimento visa demonstrar o processo de cosntrução de um modelo de regressão para prever a
#   demanda por aluguel de bicicletas. Usaremos um conjunto de dados para construir e treinar nosso modelo.

# Dados

# - O conjunto de dados "Bike Rental UCI" será usado para construir e treinar o modelo neste experimento.
#   Este dataset é baseado em dados reais da empresa Capital Bikeshare, que opera aluguel de bicicletas na
#   cidade de Washington DC, nos EUA.

# - O dataset contém 17.379 observações e 17 variáveis, representando o número de bicicletas alugas dentro
#   de horas específicas no dia, nos anos de 2011 e 2012.
#   Condições climáticas (como temperatura, humidade e velocidade do vento) foram incluídas no dataset e as
#   datas foram categorizadas como feriados e dias de semana.

# - Dataset: https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset

# Objetivo

# - O objetivo será prever o valor da variável cnt (count) que representa a quantidade de bicicletas alugadas
#   dentro de uma hora específica e cujo range pe de 1 a 977.

