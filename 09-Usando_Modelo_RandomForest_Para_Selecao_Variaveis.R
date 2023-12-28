####  Usando Modelo RandomForest Para Seleção de Variáveis (Feature Selection) ####

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


## Feature Selection (Seleção de Variáveis)

# Por que usamos Feature Selection ?

#  -> Simplificação do modelo, o que facilita a sua interpretação.
#  -> Redução do tempo de treinamento do modelo.
#  -> Melhora da generalização do modelo, evitando overfitting.


# - A premissa por trás das técnicas de Feature Selection é que os dados sempre contém variáveis que são redundantes ou 
#   irrelevantes e que podem ser removidas sem correr o risco de perder informação importante.


# Que variáveis (features) presentes no nosso conjunto de dados, devem ser usadas na criação do modelo ?

#  -> As técnicas de feature selection automatizam a seleção das variáveis com maior potencial para variáveis preditoras.
#  -> Ou seja, a idéia é não ter variáveis irrelevantes no nosso conjunto de dados.


# - Portanto podemos afirmar que Feature Selection é uma espécia de filtro que remove do dataset as variáveis que não serão úteis
#   para a criação do modelo preditivo.

# - O principal objetivo ao usar técnicas de Feature Selection é criar um modelo preditivo com a maior precisão possível e que
#   seja generalizável. 


# Métodos para Feature Selection

#  -> Testo do Qui-Quadrado
#  -> Coeficientes de Correlação
#  -> Algoritmos de Eliminação Recursiva
#  -> Algoritmos de Regularização (LASSO, Elastic Net, Ridge Regression)

# - O Feature Selection é tão importante quanto a escolha do algoritmo de Machine Learning.

# - As técnicas de Feature Selection basicamente calculam o nível de significância de cada variável e eliminam aquelas com 
#   significância mais baixas.


#### Aplicando Duas Técnicas de Feature Selection (uma para o R e outra para o Azure ML)

## Técnica 1 - Criando um Modelo de RandomForest no ambiente R

# Modelo 1 (Avaliando a importância de todas as variáveis)
modelo <- randomForest(cnt ~ ., data = bikes, ntree = 100, nodesize = 10, importance = TRUE)

# - para este tipo de problema (técnica de feature selecion o atributo "importante = TRUE" precsa estar)


## Visualizando a importância das variáveis

# Visualizando por números
varImportance <- modelo$importance
print(varImportance)

# Visualizando por gráfico (2 formas)
varImpPlot(modelo)                                                                 # forma 1 (quanto mais a direta melhor)
barplot(varImportance[, 1], main = "Importância das Variáveis", col = "skyblue")   # forma 2



# Modelo 2 (Seleção de Variáveis)

modelo2 <- randomForest(cnt ~ hum + hr + temp + dteday + xformWorkHr,
                       data = bikes, ntree = 100, nodesize = 10, importance = TRUE)

# - para este tipo de problema (técnica de feature selecion o atributo "importante = TRUE" precsa estar)


## Visualizando a importância das variáveis

# Visualizando por números
varImportance2 <- modelo2$importance
print(varImportance2)

# Visualizando por gráfico (2 formas)
varImpPlot(modelo2)                                                                 # forma 1 (quanto mais a direta melhor)
barplot(varImportance2[, 1], main = "Importância das Variáveis", col = "skyblue")   # forma 2






## Técnica 2 - Usando o Módulo Filter Based Feature Selection no Azure ML

# Voltando ao Azure ML











