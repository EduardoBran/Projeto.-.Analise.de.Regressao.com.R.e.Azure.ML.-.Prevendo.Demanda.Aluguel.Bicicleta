####  Construindo e Treinando Modelo Preditivo no Azure ML  ####

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


## Treinando Modelo (vamos começar com um algoritmo simples)

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

# - Esse valor é de 0.0 a 1.0 e nosso valor foi de 0.31, o que indica um resultado muito ruim (apesar de ser "normal" para um primeiro modelo).
# - O valor "aceitável" é acima de 0.70 , e desta forma iríamos fazendo ajustes pontuais para melhorar a performance até atingir
#   a valores como 0.93 a 0.95.


## Como melhorar a performance deste modelo ?

# - Como nós obtivemos um valor "Coefficient of Determination" (R-sqaured) de apenas 0.31, o indicado é trocar o tipo de algoritimo.

# - Deletar o módulo "Linear Regression"

# - Procurar o arrastar o módulo "Boosted Decision Tree Regression"

# - Conectar o módulo "Boosted Decision Tree Regression" na primeira entrada do módulo "Train Model" 

# - Avaliar o modelo com novo algortimo clicando no módulo "Evaluate Model"
#   -> Agora conseguimos um valor "Coefficient of Determination" (R-sqaured) de 0.93

# - E assim com a alteração do tipo de algoritmo, constatamos que a eficácia do nosso modelo agora esta um valor de 0.93



####  Criando um Modelo de Machine Learning no Ambiente Azure ML utilizando a Linguagem R

# - Isso é diferente de executar um Script R no Ambiente do Azure ML

# - Agora criaremos nosso próprio módulo que será um modelo desenvolvido em Linguagem R

# - E assim iremos criar um outro algoritmo usando linguagem R para comparar ao algoritmo Boosted Decision Tree Regressio do Azure ML


## Criando Modelo

# - Procurar e arrastar o módulo "Create R Model" (ignorar a mensagem pois já estamos usando a versão CRAN R 3.1.0)

# - Observando as configurações do módulo, temos duas áreas de código. Trainer para treinar o modelo e Scorer para fazer as previsões

# - Este módulo "Create R Model" não possui porta de entrada e por este motivo não conseguimos carregar o script tools
# - Por causa deste motivo teremos que utilzar as funções de transformação de data nos códigos abaixo:
#   (códigos fornecidos pelo professor)

# - Colar na área "Trainer R script"

# Função para tratar as datas
set.asPOSIXct <- function(inFrame) { 
  dteday <- as.POSIXct(
    as.integer(inFrame$dteday), 
    origin = "1970-01-01")
  
  as.POSIXct(strptime(
    paste(as.character(dteday), 
          " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S"))
}

char.toPOSIXct <-   function(inFrame) {
  as.POSIXct(strptime(
    paste(inFrame$dteday, " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S")) }


# Variável que controla a execução do script
Azure <- TRUE

if(Azure){
  dataset$dteday <- set.asPOSIXct(dataset)
}else{
  bikes <- bikes
}

require(randomForest)
model <- randomForest(cnt ~ xformWorkHr + dteday + temp + hum, 
                      data = dataset, # altere o nome do objeto data para "dataset" de estiver trabalhando no Azure ML
                      ntree = 40, 
                      nodesize = 5)
print(model)


# - Colar na área "Scorer R script"

# Função para tratar as datas
set.asPOSIXct <- function(inFrame) { 
  dteday <- as.POSIXct(
    as.integer(inFrame$dteday), 
    origin = "1970-01-01")
  
  as.POSIXct(strptime(
    paste(as.character(dteday), 
          " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S"))
}

char.toPOSIXct <-   function(inFrame) {
  as.POSIXct(strptime(
    paste(inFrame$dteday, " ", 
          as.character(inFrame$hr),
          ":00:00", 
          sep = ""), 
    "%Y-%m-%d %H:%M:%S")) }


# Variável que controla a execução do script
Azure <- TRUE


if(Azure){
  bikes <- dataset
  bikes$dteday <- set.asPOSIXct(bikes)
}else{
  bikes <- bikes
}

require(randomForest)
scores <- data.frame(actual = bikes$cnt,
                     prediction = predict(model, newdata = bikes))



# - E desta forma ao levar os scripts de trainer e scorer para o ambiente azure ml, nós criamos um Modelo de Machine Learning
#   em Linguagem R no Azure ML


## Treinando o Modelo

# - Procurar e arrastar o módulo "Split Data"
# - Procurar e arrastar o módulo "Train Model"
# - Procurar e arrastar o módulo "Score Model"

# - Como o nosso algoritmo no módulo "Create R Model" já faz a seleção de variáveis, estaria incorreto ligar o módulo 
#   "Filter Based Feature Selection" nele.
# - Dito isso, vamos conectar o primeiro módulo "Execute R Script" no módulo "Split Data"
# - Configurar o módulo "Split Data"
#  -> Em Splitting mode deixar "Split Rows", modificar Fraction para 0.7 e adicionar 6289 em Random seed.

# - Conectar a primeira porta de saída de "Split Data" na segunda porta de entrada de "Train Model"
# - Conectar o módulo "Create R Model" na primeira porta de entrada de "Train Model"
# - Configurar o módulo "Train Model"
#  -> Escolher a variável alvo cnt

# - Conectar módulo "Train Model" na primeira porta de entrada de "Score Model"
# - Conectar segunda porta de saída de "Split Data" na segunda porta de entrada de "Score Model"


## Analisando Nosso Modelo

# - Clicar no módulo "Score Model" e observando temos as colunas "actual" e "prediction" e conseguimos comparar os resultados

# - A diferença do valores "actual" e o "prediction" é chamada de Resíduos
# - Podemos fazer análises sobre estes Resíduos para melhorar a performance do modelo


## Computação dos Resíduos do Modelo

# - Procurar e arrastar o módulo "Select Columns in Dataset"
# - Procurar e arrastar o módulo "Execute R Script"

# - Conectar o módulo "Score Model" no módulo "Select Columns in Dataset"
# - Configurar o módulo "Select Columns in Dataset"
#  -> Escolher as colunas cnt, prediction

# - Conectar o módulo "Select Columns in Dataset" na primeira porta de entrada de "Execute R Script"
# - Conectar a segunda porta de saída do módulo "Split Data" (dados de teste) na segunda porta de entrada de "Execute R Script"
# - Conectar o módulo "Tools.zip" na terceira porta de entrada do módulo "Escute R Script"

# - No módulo "Execute R Script" colar o seguinte código:

# Variável que controla a execução do script
Azure <- TRUE

if(Azure){
  source("src/Tools.R")
  inFrame <- maml.mapInputPort(1)
  refFrame <- maml.mapInputPort(2)
  refFrame$dteday <- set.asPOSIXct2(refFrame)
}else{
  source("src/Tools.R")
  inFrame <- scores[, c("actual", "prediction")]
  refFrame <- bikes
}

# Criando um dataframe
inFrame[, c("dteday", "monthCount", "hr", "xformWorkHr")] <- refFrame[, c("dteday", "monthCount", "hr", "xformWorkHr")]

# Nomeando o dataframe
names(inFrame) <- c("cnt", "predicted", "dteday", "monthCount", "hr", "xformWorkHr")

#  Time series plot mostrando a diferença entre valores reais e valores previstos
library(ggplot2)
inFrame <- inFrame[order(inFrame$dteday),]
s <- c(7, 9, 12, 15, 18, 20, 22)

lapply(s, function(s){
  ggplot() +
    geom_line(data = inFrame[inFrame$hr == s, ], 
              aes(x = dteday, y = cnt)) +
    geom_line(data = inFrame[inFrame$hr == s, ], 
              aes(x = dteday, y = predicted), color = "red") +
    ylab("Numero de Bikes") +
    labs(title = paste("Demanda de Bikes as ",
                       as.character(s), ":00", spe ="")) +
    theme(text = element_text(size = 20))
})

# Computando os resíduos
library(dplyr)
inFrame <-  mutate(inFrame, resids = predicted - cnt)

# Plotando os resíduos
ggplot(inFrame, aes(x = resids)) + 
  geom_histogram(binwidth = 1, fill = "white", color = "black")

qqnorm(inFrame$resids)
qqline(inFrame$resids)

# Plotando os resíduos com as horas transformadas
inFrame <- mutate(inFrame, fact.hr = as.factor(hr),
                  fact.xformWorkHr = as.factor(xformWorkHr))                                  
facts <- c("fact.hr", "fact.xformWorkHr") 
lapply(facts, function(x){ 
  ggplot(inFrame, aes_string(x = x, y = "resids")) + 
    geom_boxplot( ) + 
    ggtitle("Residuos - Demanda de Bikes por Hora - Atual vs Previsto")})


# Mediana dos resíduos por hora
evalFrame <- inFrame %>%
  group_by(hr) %>%
  summarise(medResidByHr = format(round(
    median(predicted - cnt), 2), 
    nsmall = 2)) 

# Computando a mediana dos resíduos
tempFrame <- inFrame %>%
  group_by(monthCount) %>%
  summarise(medResid = median(predicted - cnt)) 

evalFrame$monthCount <- tempFrame$monthCount
evalFrame$medResidByMcnt <- format(round(
  tempFrame$medResid, 2), 
  nsmall = 2)

print("Resumo dos residuos")
print(evalFrame)

# Output
outFrame <- data.frame(evalFrame)
if(Azure) maml.mapOutputPort('outFrame')


# - Agora clicar na segunda porta de saída do módulo "Execute R Script" para visualizar os resultados


## Interpretando os Resíduos

# - Podemos interpretar observando os gráficos que os dados outliers não conseguiram ser previsto e talvez seja melhor remove-los 
#   no dataset original

# - No gráfico de histograma podemos obervar que a maioria dos valores está concentrada em torno de zero
#   Isso indica que nosso modelo tem uma boa taxa de previsão afinal a diferença dos valores reais para os previstos estão "iguais" a zero


## Otimizando o Modelo

# - Um das formas para otimizar o modelo seria a modificação dos parâmetros nas configurações no módulo "Boosted Decision Tree Regression".
#   Para modificar os parâmetros de um algorotimo é importante saber como funciona o algoritimo.
