####  Executando o Experimento no Azure ML  ####

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/14.Projeto-de-Analise-de-Regressao-com-R-e-Azure-ML-Prevendo_Demanda_Aluguel_Bicicleta")
getwd()



#### Passo a passo para executar o projeto no ambiente Azure ML


## Voltando ao Azure ML


# Criar experimento:

# - Criar um novo experimento.


# Carregando módulos:

# - Carregar o Módulo com o dataset "Bike Rental UCI dataset"
# - Carregar o Módulo com o dataset "Tools.zip" (já carregado anteriormente)
# - Carregar o Módulo com o dataset "Select Columns in Dataset"
# - Carregar o Módulo com o dataset "Normalize Data"
# - Carregar o Módulo com o dataset "Execute R Script"


# Conectando módulos:

# - Conectar o "Bike Rental UCI dataset" no módulo "Select Columns in Dataset"
# - Conectar o "Select Columns in Dataset" no módulo "Normalize Data"
# - Conectar o "Normalize Data" no módulo "Execute R Script"
# - Conectar o "Tools.zip" no módulo "Execute R Script" (Porta 3 de entrada)


# Configurando módulos:

# - Ir no módulo "Select Columns in Dataset" e clicar em "Launch Column Selector" e escolher as
#   as colunas "dteday", "mnth", "hr", "holiday", "workingday", "weathersit", "temp", "hum", "windspeed" e "cnt"

# - Ir no módulo "Normalize Data" e selecionar as colunas "temp", "hum", "windspeed"

# - Ir no módulo "Execute R Scrip" e apagar todo o conteúdo. Copiar o script fornecido pelo professor e colar lá.
#   Deixar somente o bloco de código com nomes de dias da semana em inglês.
#   Marcar a versão CRAN 3.1.0.

