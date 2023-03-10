library("ggplot2")

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

dados <- read.table("indices_graf.txt", header = TRUE)
is.data.frame(dados)
dados

dados$importancia <- as.numeric(dados$importancia)
is.numeric(dados$importancia)

#indices em conjunto no mesmo gr?fico
dados
ggplot(dados, (aes(x= indices,
                   y= importancia,
                   color = indices,
                   fill = indices))) +
  geom_col(position="dodge", show.legend = TRUE) +
  labs(title= 'Import?ncia relativa na predi??o',
       subtitle= 'Algoritmo de Garson modificado por Goh',
       x = '?ndices de vegeta??o',
       y = 'Signific?ncia') +
labs() +
  facet_wrap(~saida)


#gr?ficos separados por indice
ggplot(dados, (aes(x = indices,
                    y = importancia,
                   fill = indices))) +
  geom_point(aes(color= indices)) +
  facet_wrap(~indices)
#gr?fico em 1 vari?vel de sa?da
dados2 <- dados[25:28,]

dados2$importancia <- as.numeric(dados2$importancia)
is.numeric(dados2$importancia)

ggplot(dados2, (aes(x= indices, y= importancia,
                    fill= indices))) +
  geom_col() +
  ylim(0, 0.5) +
  labs(title= 'N?mero de gr?os por fileira',
       y = 'Signific?ncia',
       x = '?ndices de vegeta??o')


#testando somente com uma vari?vel de sa?da
dados2 <- dados[1:4,]

dados2$importancia <- as.numeric(dados2$importancia)
is.numeric(dados2$importancia)

ggplot(dados2, (aes(x= indices, y= importancia,
                    fill= indices))) +
  geom_col() +
  ylim(0, 0.5) +
  facet_wrap(~indices) +
  labs(title= 'Signific?ncia na predi??o',
       Subtitle = 'Algoritmo de Garson modificado por Goh',
       y = 'Signific?ncia',
       x = '?ndices de vegeta??o')
