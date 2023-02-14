library("ggplot2")

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

dados <- read.table("indices_graf.txt", header = TRUE)
is.data.frame(dados)
dados

dados$importancia <- as.numeric(dados$importancia)
is.numeric(dados$importancia)

#indices em conjunto no mesmo gráfico
dados
ggplot(dados, (aes(x= indices,
                   y= importancia,
                   color = indices,
                   fill = indices))) +
  geom_col(position="dodge", show.legend = TRUE) +
  labs(title= 'Importância relativa na predição',
       subtitle= 'Algoritmo de Garson modificado por Goh',
       x = 'Índices de vegetação',
       y = 'Significância') +
labs() +
  facet_wrap(~saida)


#gráficos separados por indice
ggplot(dados, (aes(x = indices,
                    y = importancia,
                   fill = indices))) +
  geom_point(aes(color= indices)) +
  facet_wrap(~indices)
#gráfico em 1 variável de saída
dados2 <- dados[25:28,]

dados2$importancia <- as.numeric(dados2$importancia)
is.numeric(dados2$importancia)

ggplot(dados2, (aes(x= indices, y= importancia,
                    fill= indices))) +
  geom_col() +
  ylim(0, 0.5) +
  labs(title= 'Número de grãos por fileira',
       y = 'Significância',
       x = 'Índices de vegetação')


#testando somente com uma variável de saída
dados2 <- dados[1:4,]

dados2$importancia <- as.numeric(dados2$importancia)
is.numeric(dados2$importancia)

ggplot(dados2, (aes(x= indices, y= importancia,
                    fill= indices))) +
  geom_col() +
  ylim(0, 0.5) +
  facet_wrap(~indices) +
  labs(title= 'Significância na predição',
       Subtitle = 'Algoritmo de Garson modificado por Goh',
       y = 'Significância',
       x = 'Índices de vegetação')
