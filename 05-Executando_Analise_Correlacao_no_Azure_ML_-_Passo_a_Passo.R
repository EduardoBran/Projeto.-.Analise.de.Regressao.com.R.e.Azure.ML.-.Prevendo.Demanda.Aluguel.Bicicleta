####  Executando o Experimento no Azure ML  ####

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/14.Projeto-de-Analise-de-Regressao-com-R-e-Azure-ML-Prevendo_Demanda_Aluguel_Bicicleta")
getwd()



#### Passo a passo realizar Análise de Correlação no Azure ML


## Voltando ao Azure ML

# Vamos continuar no último Experimento criado no Azure ML (Modelo Preditivo Demanda por Aluguel de Bikes)


# - Carregar outro módulo "Execute R Script"
# - Conectar o módulo "Execute R Script" no novo módulo "Execute R Script"
# - Conectar o módulo "Tools.zip" no novo módulo "Execute R Script"

# - Colar o seguinte código abaixo:
# - Após colar o código visualizar na saída 2.


## Carregando pacotes

library(lattice)   # plot correlação
library(corrplot)

# Variável que controla a execução do script
# (Se o valor for FALSE, o codigo sera executado no RStudio)
Azure <- TRUE

if(Azure){
  source("src/Tools.R")
  bikes <- maml.mapInputPort(1)
  bikes$dteday <- set.asPOSIXct(bikes)
}else{
  bikes <- bikes
}


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


## Gera saida no Azure ML
if(Azure) maml.mapOutputPort('bikes')  

