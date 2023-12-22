####  Análise de Correlação  ####

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/14.Projeto-de-Analise-de-Regressao-com-R-e-Azure-ML-Prevendo_Demanda_Aluguel_Bicicleta")
getwd()


## Carregando pacotes

library(tidyverse) # necessário para read.csv
library(lattice)   # plot correlação
library(corrplot)


## Carregando dataset

# - Lembrando que o nosso dataset já passou pelo processo de transformação no script anterior.
# - Iremos então carregar este script dentro da função abaixo.

# Variável que controla a execução do script
# (Se o valor for FALSE, o codigo sera executado no RStudio)
Azure <- FALSE

if(Azure){
  source("src/Tools.R")
  bikes <- maml.mapInputPort(1)
  bikes$dteday <- set.asPOSIXct(bikes)
}else{
  source("src/Tools.R")
  bikes <- read.csv("bikes.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE )
  # Transformar o objeto de data
  bikes$dteday <- char.toPOSIXct(bikes)
  
  # Na linha de cima foi gerado dois valores NA
  # Esta linha abaixo corrige
  bikes <- na.omit(bikes)
}

View(bikes)


## Realizando Análise de Correlação

# Métodos de Correlação

# -> Pearson  - coeficiente usado para medir o grau de relacionamento entre duas variáveis com relação linear
# -> Spearman - teste não paramétrico, para medir o grau de relacionamento entre duas variaveis
# -> Kendall  - teste não paramétrico, para medir a força de dependência entre duas variaveis


## Forma 1 (utlizando dois métodos)

# Definindo as colunas para a análise de correlação 
cols <- c("mnth", "hr", "holiday", "workingday",
          "weathersit", "temp", "hum", "windspeed",
          "isWorking", "monthCount", "dayWeek", 
          "workTime", "xformHr", "cnt")


# Vetor com os métodos de correlação
metodos <- c("pearson", "spearman")

# Aplicando os métodos de correlação com a função cor()
cors <- lapply(metodos, function(method) 
  (cor(bikes[, cols], method = method)))

head(cors)


## Preparando o plot

# Função para criar o plot
plot_corr <- function(x, labs){
  diag(x) <- 0.0 
  plot( levelplot(x, 
                  main = paste("Plot de Correlação usando Método", labs),
                  scales = list(x = list(rot = 90), cex = 1.0)) )
}

# Exibindo o plot
Map(plot_corr, cors, metodos)



## Gera saida no Azure ML
if(Azure) maml.mapOutputPort('bikes')



## Forma 2 (utilizando 1 método)

# Criando/calculando uma matriz de correlação
cor_matrix <- cor(bikes[, cols])
cor_matrix

# E para não ter que analisar somentes os números, vamos criar um gráfico corrplot

# Corrplot (para outras cores usar colors())
corrplot(cor_matrix,
         method = "color",
         type = "upper",
         addCoef.col = 'springgreen2',
         tl.col = "black",
         tl.srt = 45)


## Salvando os gráficos

# Salvar o gráfico 1 como PNG
png("grafico1.png", width = 800, height = 400)
Map(plot_corr, cors, metodos)
dev.off()

# Salvar o gráfico 2 como PNG
png("grafico2.png", width = 800, height = 400)
corrplot(cor_matrix,
         method = "color",
         type = "upper",
         addCoef.col = 'springgreen2',
         tl.col = "black",
         tl.srt = 45)
dev.off()

