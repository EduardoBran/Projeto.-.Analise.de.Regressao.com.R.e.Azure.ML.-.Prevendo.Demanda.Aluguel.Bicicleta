####  Realizando Análise Exploratória - Density Plots  ####

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


## Density Plots

# - A criação de Density Plots nos auxilia na busca das variáveis que são mais relevantes para a construção do modelo.

# - O Density Plots basicamente nos mostra a correlação entre variáveis de maneira gráfica.

# - Este script demora um pouco mais de tempo para rodar por ser muito pesado.


## Criando Gráficos Density Plots

# Visualizando o relacionamento entre as variáveis preditoras e demanda por bike
labels <- c("Demanda de Bikes vs Temperatura",
            "Demanda de Bikes vs Humidade",
            "Demanda de Bikes vs Velocidade do Vento",
            "Demanda de Bikes vs Hora")

xAxis <- c("temp", "hum", "windspeed", "hr")

# Função para os Density Plots
plot.scatter <- function(X, label){ 
  ggplot(bikes, aes_string(x = X, y = "cnt")) + 
    geom_point(aes_string(colour = "cnt"), alpha = 0.1) + 
    scale_colour_gradient(low = "green", high = "blue") + 
    geom_smooth(method = "loess") + 
    ggtitle(label) +
    theme(text = element_text(size = 20)) 
}


# Gerando gráfico
Map(plot.scatter, xAxis, labels)


# Explorando a interação entre tempo e dia, em dias da semana e fins de semana
labels <- list("Box plots - Demanda por Bikes as 09:00 para \n dias da semana e fins de semana",
               "Box plots - Demanda por Bikes as 18:00  para \n dias da semana e fins de semana")

Times <- list(9, 18)

plot.box2 <- function(time, label){ 
  ggplot(bikes[bikes$hr == time, ], aes(x = isWorking, y = cnt, group = isWorking)) + 
    geom_boxplot( ) + ggtitle(label) +
    theme(text = element_text(size = 18)) }

Map(plot.box2, Times, labels)


# Gera saída no Azure ML
if(Azure) maml.mapOutputPort('bikes')


# -> Não foi colocado estes Density Plots no Azure ML para evitar a demora da execução do experimento.
