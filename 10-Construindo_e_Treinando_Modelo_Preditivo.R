####  Modelo Preditivo Usando RandomForest ####

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/14.Projeto-de-Analise-de-Regressao-com-R-e-Azure-ML-Prevendo_Demanda_Aluguel_Bicicleta")
getwd()


## Carregando pacotes
library(randomForest)  # necessário para criação do Modelo RandomForest


## Carregando dataset

# - Lembrando que o nosso dataset já passou pelo processo de transformação no script anterior.
# - Iremos então carregar este script dentro da função abaixo.

# Variável que controla a execução do script
# (Se o valor for FALSE, o codigo sera executado no RStudio)
Azure <- FALSE

# Função para carregar e alterar formato data (dteday) dos dados
if(Azure){
  source("src/Tools.R")
  Bikes <- maml.mapInputPort(1)
  Bikes$dteday <- set.asPOSIXct(Bikes)
}else{
  source("src/Tools.R")
  bikes <- read.csv("bikes.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE )
  
  # Transformar o objeto de data
  bikes$dteday <- char.toPOSIXct(bikes)
  
  # Removendo valores NA
  bikes <- na.omit(bikes)
  
  # Verificando valores NA
  any(is.na(bikes))
}
View(bikes)



## Voltando ao Azure ML

# Vamos continuar no último Experimento criado no Azure ML (Modelo Preditivo Demanda por Aluguel de Bikes)

## Dividindo os dados em treino e teste

# - Procurar e arrastar o módulo "Split Data"

# - Conectar o módulo "Filter Based Feature Selection" no módulo "Split Data"
# - Configurar o módulo "Split Data"
#  -> Em Splitting mode deixar "Split Rows", modificar Fraction para 0.7 e adicionar 6489 em Random seed.


## Treinando Modelo

# - Procurar e arrastar o módulo "Train Model"
# - Procurar e arrastar o módulo "Linear Regression"

# - Conectar a primeira saída do módulo "Split Data" (dados de treino) na segunda entrada do módulo "Train Model"
# - Conectar o módulo "Linear Regression" na primeira entrada do módulo "Train Model"
# - Configurar o módulo "Train Model"
#  -> Escolher a variável alvo cnt


## Avaliando o modelo

# - Procurar e arrastar o módulo "Score Model"
# - Procurar e arrastar o módulo "Evaluate Model"

# - Conectar o módulo "Train Model" na primeira entrada do módulo "Score Model"
# - Conectar a segunda saída do módulo "Split Data" na segunda entrada do módulo "Score Model"
# - Conectar o módulo "Score Model" no módulo "Evaluate Model"

## Interpretando a avaliação do modelo

# - Após executar o experimento, clicar na saída do módulo "Evaluate Model"
#  -> Ficar atento ao valor do "Coefficient of Determination" que seria o R-squared

# - Nosso valor foi de 0.31 , o que indica um resultado muito ruim (apesar de ser "normal" para um primeiro modelo).
#   Este valor é de 0.0 a 1.0, e o nosso foi 0.3.

# - O valor "aceitável" é acima de 0.70 , desta forma iríamos fazendo ajustes pontuais para melhorar a performance até atingir
#   a valores como 0.93 a 0.95.


## Como melhorar a performance do modelo ?

# - Como nós obtivemos um valor "Coefficient of Determination" (R-sqaured) de apenas 0.31, o indicado é trocar o tipo de algoritimo.

# - Deletar o módulo "Linear Regression"

# - Procurar o arrastar o módulo "Boosted Decision Tree Regression"

# - Conectar o módulo "Boosted Decision Tree Regression" na primeira entrada do módulo "Train Model" 

# - Avaliar o modelo com novo algortimo clicando no módulo "Evaluate Model"
#   -> Agora conseguimos um valor "Coefficient of Determination" (R-sqaured) de 0.93




## Criando um outro algoritmo usando linguagem R para comparar ao algoritmo Boosted Decision Tree Regressio do Azure ML








