####  Realizando Análise Exploratória - BoxPlots  ####

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/14.Projeto-de-Analise-de-Regressao-com-R-e-Azure-ML-Prevendo_Demanda_Aluguel_Bicicleta")
getwd()


## Carregando pacotes
library(ggplot2)


## Carregando dataset

# - Lembrando que o nosso dataset já passou pelo processo de transformação no script anterior.
# - Iremos então carregar este script dentro da função abaixo.

# Variável que controla a execução do script
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
}
View(bikes)


## Importância da Análise Exploratória

# - É muito importante analisarmos uma detalhada Análise Exploratória para o melhor entendimento dos dados.
#   Ou seja, precisamos olhar nossos dados por diversos ângulos.

# - Iremos realizar 3 atividades de Análise Exploratória: Séries Temporais, Boxplots e Density Plots

# - Dentro destas 3 atividades não iremos fazer nenhuma alteração no dados, o objetivo é a melhor compreensão dos dados.


## Boxplots

# - É uma boa prática criarmos gráficos Boxplots para compreendermos se temos dados acima da média, outliers ou
#   como os dados estão relacionados.


## Criando Gráficos BoxPlots

# Convertendo a variável dayWeek para fator ordenado e plotando em ordem de tempo
source("src/Tools.R")
bikes$dayWeek <- fact.conv(bikes$dayWeek)


# Demanda de bikes x potenciais variáveis preditoras
labels <- list("Boxplots - Demanda de Bikes por Hora",
               "Boxplots - Demanda de Bikes por Estação",
               "Boxplots - Demanda de Bikes por Dia Útil",
               "Boxplots - Demanda de Bikes por Dia da Semana")

xAxis <- list("hr", "weathersit", "isWorking", "dayWeek")

# Função para criar os boxplots
plot.boxes  <- function(X, label){ 
  ggplot(bikes, aes_string(x = X, y = "cnt", group = X)) + 
    geom_boxplot( ) + 
    ggtitle(label) +
    theme(text = element_text(size = 18)) 
}

# Gerando gráficos
Map(plot.boxes, xAxis, labels)


# Gera saída no Azure ML
if(Azure) maml.mapOutputPort('bikes')



## Voltar Ao Azure ML e colar o código aicma no último módulo de "Execute R Script" onde já temos gráficos de correlação.


