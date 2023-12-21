####  Coleta e Transformação de Dados  ####

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/14.Projeto-de-Analise-de-Regressao-com-R-e-Azure-ML-Prevendo_Demanda_Aluguel_Bicicleta")
getwd()


## Como será feita a organização do nosso projeto ?

# - Usaremos os Azure ML para criarmos nosso fluxo de trabalho. Lá iremos colocar todas as etapas do projeto.
# - Em paralelo também usaremos a linguagem R

# - Ou seja, na prática estamos resolvendo nosso problema de negócio com dudas ferramentas.



## Voltando ao Azure ML

# - Criar um novo experimento.
# - 



## R Studio (cript fornecido pelo curso)

# Variável que controla a execução do script
# (Se o valor for FALSE, o codigo sera executado no RStudio)
Azure <- FALSE

# Execução de acordo com o valor da variável Azure
if(Azure){
  source("src/Tools.R")
  bikes <- maml.mapInputPort(1)
  bikes$dteday <- set.asPOSIXct(bikes)
}else{
  source("src/Tools.R")
  bikes <- read.csv("datasets/bikes.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE )
  
  # Selecionar as variáveis que serão usadas
  cols <- c("dteday", "mnth", "hr", "holiday",
            "workingday", "weathersit", "temp",
            "hum", "windspeed", "cnt")
  
  # Criando um subset dos dados
  bikes <- bikes[, cols]
  
  # Transformar o objeto de data
  bikes$dteday <- char.toPOSIXct(bikes)
  
  # Na linha de cima foi gerado dois valores NA
  # Esta linha abaixo corrige
  bikes <- na.omit(bikes)
  
  # Normalizar as variaveis preditoras numericas 
  cols <- c("temp", "hum", "windspeed") 
  bikes[, cols] <- scale(bikes[, cols])  
}

#?scale
str(bikes)
View(bikes)
