####  Realizando Análise Exploratória - Séries Temporais  ####

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/14.Projeto-de-Analise-de-Regressao-com-R-e-Azure-ML-Prevendo_Demanda_Aluguel_Bicicleta")
getwd()


## Carregando pacotes
library(ggplot2)

## Carregando dataset

# - Lembrando que o nosso dataset já passou pelo processo de transformação no script anterior.
# - Iremos então carregar este script dentro da função abaixo.


## Importância da Análise Exploratória

# - É muito importante analisarmos uma detalhada Análise Exploratória para o melhor entendimento dos dados.
#   Ou seja, precisamos olhar nossos dados por diversos ângulos.

# - Iremos realizar 3 atividades de Análise Exploratória: Séries Temporais, Boxplots e Density Plots

# - Dentro destas 3 atividades não iremos fazer nenhuma alteração no dados, o objetivo é a melhor compreensão dos dados.


## Séries Temporais

# - Nossa primeira atividade de Análise Exploratória será uma Análise de Séries Temporais.
# - Será uma análise simples pois é um tema muito extenso.

#   -> Quando trabalhar com Séries Temporais ?

# - Quando nossos dados estiverem distribuídos com períodos de datas (minutos, horas, dias semana, ano, etc).
#   Quando os dados não trabalham ou não precisam de datas, nós não trabalhamos com séries temporais.

# - No caso do nosso Projeto Demanda por Aluguéis de Bikes, nós temos o aluguel ao longo de períodos de datas.
#   Temos bikes alugadas por período de 1 hora, 1 dia ou 1 semana e etc.

# - Portanto, faz sentido realizarmos uma Análise de Séries Temporais para compreendermos se temos algo fora dos limites,
#   algo fora de padrão ou um padrão não detectado.


# Variável que controla a execução do script
Azure <- FALSE

if(Azure){
  source("src/Tools.R")
  Bikes <- maml.mapInputPort(1)
  Bikes$dteday <- set.asPOSIXct(Bikes)
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

# Criando um vetor com algumas horas do dia para verificar qual horário tem a maior demanda por aluguel de bikes
# (pode ser feito com outros valores)
times <- c(7, 9, 12, 15, 18, 20, 22)


# Time Series Plot (plot de Séries Temporais)

tms.plot <- function(times){
  ggplot(bikes[bikes$workTime == times, ], aes(x = dteday, y = cnt, group = 1)) + 
    geom_line() +
    ylab("Numero de Bikes") +
    labs(title = paste("Demanda de Bikes as ", as.character(times), ":00", sep = "")) +
    theme(text = element_text(size = 20))
}

lapply(times, tms.plot)

# Gera saida no Azure ML
if(Azure) maml.mapOutputPort('bikes')




## Voltar Ao Azure ML e colar o código aicma no último módulo de "Execute R Script" onde já temos gráficos de correlação.




