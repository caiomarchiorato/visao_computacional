library("NeuralNetTools")
library("neuralnet")
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()




{dados<-read.table("ngf_ind.txt",header=T)
pdf("ngf_ind_OUTPUT_PMC_graficasdos.pdf")
saidaT ="ngf_ind_T.txt"
saidaV ="ngf_ind_V.txt"
porc<- 0.8
varsel<- 1
formula<-VarSel~. 
noculta<- 1
nepoca<- 100000
erroq<- 0.1
repete<- 0
algort<- "rprop+"
funatv<- "tanh"
n1i<- 1
n1f<- 15
n1p<- 1
n2i<- 0
n2f<- 0
n2p<- 0
n3i<- 0
n3f<- 0
n3p<- 0
n4i<- 0
n4f<- 0
n4p<- 0
n5i<- 0
n5f<- 0
n5p<- 0
cat("Arquivo de Entrada:",  "ngf_ind.txt","\n")
cat("\n")
cat(" ************************************************************** ", "\n")
cat("SOFTWARE Rbio - BIOMETRIA NO R","\n")
cat("Prongfdimento: PREDICAO: PERngfPTRON MULTICAMADA - PMC","\n") 
cat("Laboratorio de Biometria  www.biometria.ufv.br","\n") 
cat("Autor: BHERING, L.L. & CRUZ, C.D.","\n")
cat("Data: 10/2021","\n") 
cat(" ************************************************************** ", "\n")
cat("Data da Analise:", date(), "\n")

cat("\n")
#cat("\n","------------- Separando em treinamento e validacao--------------", "\n") 


# com aleatorização dos dados 

amostra=sort(sample(nrow(dados), nrow(dados)*porc)) 
dadosT<-dados[amostra,] 
dadosV<-dados[-amostra,] 

write.table(dadosT, saidaT, row.names=FALSE, col.names=TRUE, quote=FALSE)
write.table(dadosV, saidaV, row.names=FALSE, col.names=TRUE, quote=FALSE)

colnames(dadosT)[varsel] <- "VarSel"; colnames(dadosV)[varsel] <- "VarSel"
# *******************************************************************  
# Normatizacao  
# *******************************************************************  
nvar = ncol(dadosT)  
nlinT= nrow(dadosT)  
nlinV= nrow(dadosV)  


minT <- matrix(rep(NA),1,nvar)  
maxT <- matrix(rep(NA),1,nvar)  
for(j in 1:ncol(dadosT)){  
  minT[1,j] = min(dadosT[,j])  
  maxT[1,j] = max(dadosT[,j])  
}  

for(i in 1:nlinT){  
  dadosT[i,] = (dadosT[i,] - minT[1,])/(maxT[1,] - minT[1,])  
}  
for(i in 1:nlinV){  
  dadosV[i,] = (dadosV[i,] - minT[1,])/(maxT[1,] - minT[1,])  
}  

cat("  ", "\n")  
cat("**********************************************************", "\n")  

cat("Topologia da rede:  ", "\n")  
cat("Numero de epocas : ",nepoca, "\n")  
cat("Erro quadratico  : ",erroq, "\n")  
cat("Numero de camadas ocultas : ",noculta, "\n")  
cat("Camada 1 : ",n1i," - ",n1f," passo:", n1p, "\n")  
cat("Camada 2 : ",n2i," - ",n2f," passo:", n2p, "\n")  
cat("Camada 3 : ",n3i," - ",n3f," passo:", n3p, "\n")  
cat("Camada 4 : ",n4i," - ",n4f," passo:", n4p, "\n")  
cat("Camada 5 : ",n5i," - ",n5f," passo:", n5p, "\n")  
cat("**********************************************************", "\n")  

cat("  ", "\n")  
cat(" -- Informacoes Preliminares - Treinamento  ", "\n")  
summary(dadosT)  
cat("  ", "\n")  
cat(" --Informacoes Preliminares - Validacao  ", "\n")  
summary(dadosV)  
cat("  ", "\n")  

cat("*******************************************************************", "\n")    
cat(" Analise de regressao linear multipla", "\n")    
cat("*******************************************************************", "\n")    
regressao<-lm(formula,data=dadosT)  
summary(regressao)  

cat("*******************************************************************", "\n")     
cat(" Analise por rede neural", "\n")     
cat("*******************************************************************", "\n")     
library(neuralnet)  

cat("*******************************************************************", "\n")  
cat(" Resultado: Treinamento e validacao", "\n")  
cat("*******************************************************************", "\n")  
resp<- matrix(rep(NA),1,11)  
respbest<- matrix(rep(NA),1,11)  
colnames(resp) <- c("R2T%","R2Val%.", "REQt","REQv", "MAEt","MAEv","nn1","nn2","nn3","nn4","nn5")  
colnames(respbest) <- c("R2T%","R2Val%.", "REQt","REQv", "MAEt","MAEv","nn1","nn2","nn3","nn4","nn5")
r2valmax = -100  


# *********************************inicio -  uma camada  
if (noculta==1){  
  for(i1 in seq(n1i, n1f, by = n1p)){  
    nn1= i1  
    fit<-neuralnet(formula ,data=dadosT,hidden=c(nn1),algorithm = algort,act.fct = funatv, stepmax = nepoca, rep = repete,threshold=erroq)    
    predT <- compute(fit,dadosT[,-varsel])  
    saidaT <- predT$net.result  
    rt = cor(saidaT,dadosT[varsel])  
    errot=saidaT -dadosT[varsel]  
    reqt = sqrt(sum(errot^2)/length(errot)) 
    maet = sum(abs(errot))/length(errot)
    predV = compute(fit,dadosV[-varsel])  
    saidaV <- predV$net.result  
    rv = cor(saidaV,dadosV[varsel])  
    errov=saidaV-dadosV[varsel]  
    reqv = sqrt(sum(errov^2)/length(errov))  
    r2val = 100*rv^2  
    maev = sum(abs(errov))/length(errov)
    resp[1,1] = 100*rt^2  
    resp[1,2] =  100*rv^2  
    resp[1,3] =  reqt; resp[1,4] =  reqv   
    resp[1,5] =  maet; resp[1,6] =  maev   
    resp[1,7] =  nn1  
    print(resp)  
    
    if (r2val > r2valmax){  
      r2valmax= r2val  
      bestfit <- fit  
      respbest<-resp  
    }  
  }  
}  
# *********************************fim-  uma camada  


# *********************************inicio -  duas camadas  
if (noculta==2){  
  for(i1 in seq(n1i, n1f, by = n1p)){  
    for(i2 in seq(n2i, n2f, by = n2p)){  
      nn1= i1  
      nn2= i2  
      fit<-neuralnet(formula ,data=dadosT,hidden=c(nn1,nn2),algorithm = algort,act.fct = funatv, stepmax = nepoca, rep = repete,threshold=erroq)    
      
      predT <- compute(fit,dadosT[,-varsel])  
      saidaT <- predT$net.result  
      rt = cor(saidaT,dadosT[varsel])  
      errot=saidaT -dadosT[varsel]  
      reqt = sqrt(sum(errot^2)/length(errot)) 
      maet = sum(abs(errot))/length(errot)
      predV = compute(fit,dadosV[-varsel])  
      saidaV <- predV$net.result  
      rv = cor(saidaV,dadosV[varsel])  
      errov=saidaV-dadosV[varsel]  
      reqv = sqrt(sum(errov^2)/length(errov))  
      r2val = 100*rv^2  
      maev = sum(abs(errov))/length(errov)
      resp[1,1] = 100*rt^2  
      resp[1,2] =  100*rv^2  
      resp[1,3] =  reqt; resp[1,4] =  reqv   
      resp[1,5] =  maet; resp[1,6] =  maev  
      resp[1,7] =  nn1  
      resp[1,8] =  nn2  
      print(resp)  
      if (r2val > r2valmax){  
        r2valmax= r2val  
        bestfit <- fit  
        respbest<-resp  
      }  
    }  
  }  
}  
# *********************************fim-  duas camadas  

# *********************************inicio -  tres camadas  
if (noculta==3){  
  for(i1 in seq(n1i, n1f, by = n1p)){  
    for(i2 in seq(n2i, n2f, by = n2p)){  
      for(i3 in seq(n3i, n3f, by = n3p)){  
        nn1= i1  
        nn2= i2  
        nn3= i3  
        fit<-neuralnet(formula ,data=dadosT,hidden=c(nn1,nn2,nn3),algorithm = algort,act.fct = funatv, stepmax = nepoca, rep = repete,threshold=erroq)    
        
        predT <- compute(fit,dadosT[,-varsel])  
        saidaT <- predT$net.result  
        rt = cor(saidaT,dadosT[varsel])  
        errot=saidaT -dadosT[varsel]  
        reqt = sqrt(sum(errot^2)/length(errot)) 
        maet = sum(abs(errot))/length(errot)
        predV = compute(fit,dadosV[-varsel])  
        saidaV <- predV$net.result  
        rv = cor(saidaV,dadosV[varsel])  
        errov=saidaV-dadosV[varsel]  
        reqv = sqrt(sum(errov^2)/length(errov))  
        r2val = 100*rv^2  
        maev = sum(abs(errov))/length(errov)
        resp[1,1] = 100*rt^2  
        resp[1,2] =  100*rv^2  
        resp[1,3] =  reqt; resp[1,4] =  reqv    
        resp[1,5] =  maet; resp[1,6] =  maev  
        resp[1,7] =  nn1  
        resp[1,8] =  nn2 ; resp[1,9] =  nn3   
        print(resp)  
        if (r2val > r2valmax){  
          r2valmax= r2val  
          bestfit <- fit  
          respbest<-resp  
        }  
      }  
    }  
  }  
}  
# *********************************fim-  tres camadas  


# *********************************inicio -  quatro camadas  
if (noculta==4){  
  for(i1 in seq(n1i, n1f, by = n1p)){  
    for(i2 in seq(n2i, n2f, by = n2p)){  
      for(i3 in seq(n3i, n3f, by = n3p)){  
        for(i4 in seq(n4i, n4f, by = n4p)){  
          nn1= i1  
          nn2= i2  
          nn3= i3  
          nn4= i4  
          fit<-neuralnet(formula ,data=dadosT,hidden=c(nn1,nn2,nn3,nn4),algorithm = algort,act.fct = funatv, stepmax = nepoca, rep = repete,threshold=erroq)    
          
          predT <- compute(fit,dadosT[,-varsel])  
          saidaT <- predT$net.result  
          rt = cor(saidaT,dadosT[varsel])  
          errot=saidaT -dadosT[varsel]  
          reqt = sqrt(sum(errot^2)/length(errot)) 
          maet = sum(abs(errot))/length(errot)
          predV = compute(fit,dadosV[-varsel])  
          saidaV <- predV$net.result  
          rv = cor(saidaV,dadosV[varsel])  
          errov=saidaV-dadosV[varsel]  
          reqv = sqrt(sum(errov^2)/length(errov))  
          r2val = 100*rv^2  
          maev = sum(abs(errov))/length(errov)
          resp[1,1] = 100*rt^2  
          resp[1,2] =  100*rv^2  
          resp[1,3] =  reqt; resp[1,4] =  reqv   
          resp[1,5] =  maet; resp[1,6] =  maev   
          resp[1,7] =  nn1  
          resp[1,8] =  nn2 ; resp[1,9] =  nn3 ; resp[1,10] =  nn4  
          print(resp)  
          if (r2val > r2valmax){  
            r2valmax= r2val  
            bestfit <- fit  
            respbest<-resp  
          }  
        }  
      }  
    }  
  }  
}  
# *********************************fim-  quatro camadas  


# *********************************inicio -  cinco camadas  
if (noculta==5){  
  for(i1 in seq(n1i, n1f, by = n1p)){  
    for(i2 in seq(n2i, n2f, by = n2p)){  
      for(i3 in seq(n3i, n3f, by = n3p)){  
        for(i4 in seq(n4i, n4f, by = n4p)){  
          for(i5 in seq(n5i, n5f, by = n5p)){  
            nn1= i1  
            nn2= i2  
            nn3= i3  
            nn4= i4  
            nn5= i5  
            fit<-neuralnet(formula,data=dadosT,hidden=c(nn1,nn2,nn3,nn4,nn5),algorithm = algort,act.fct = funatv, stepmax = nepoca, rep = repete,threshold=erroq)    
            
            predT <- compute(fit,dadosT[,-varsel])  
            saidaT <- predT$net.result  
            rt = cor(saidaT,dadosT[varsel])  
            errot=saidaT -dadosT[varsel]  
            reqt = sqrt(sum(errot^2)/length(errot)) 
            maet = sum(abs(errot))/length(errot)
            predV = compute(fit,dadosV[-varsel])  
            saidaV <- predV$net.result  
            rv = cor(saidaV,dadosV[varsel])  
            errov=saidaV-dadosV[varsel]  
            reqv = sqrt(sum(errov^2)/length(errov))  
            r2val = 100*rv^2  
            maev = sum(abs(errov))/length(errov)
            resp[1,1] = 100*rt^2  
            resp[1,2] =  100*rv^2  
            resp[1,3] =  reqt; resp[1,4] =  reqv   
            resp[1,5] =  maet; resp[1,6] =  maev    
            resp[1,7] =  nn1  
            resp[1,8] =  nn2 ; resp[1,9] =  nn3 ; resp[1,10] =  nn4  ; resp[1,11] =  nn5 
            print(resp)  
            if (r2val > r2valmax){  
              r2valmax= r2val  
              bestfit <- fit  
              respbest<-resp  
            }  
          }  
        }  
      }  
    }  
  }  
}  
# *********************************fim-  cinco camadas  




cat(" *******************************************************************", "\n")    
cat("  Melhor Rede: Validacao", "\n")    
cat(" *******************************************************************", "\n")    
cat("  ", "\n")  
cat("Melhor rede  ", "\n")  
print(respbest)  
cat("  ", "\n")  

cat(" *******************************************************************", "\n")  
cat("  Informacoes gerais da melhor rede", "\n")  
cat(" *******************************************************************", "\n")  
print(bestfit)  
cat("  ", "\n")  

# *******************************************************************  
#  Saidas graficas
# *******************************************************************  

#a. Saída de rede vs saída desejada (real)  
predT <- compute(bestfit,dadosT[,-varsel])  
saidaT <- predT$net.result  
seq <-(1:1:nrow(dadosT))  
plot(seq,saidaT,xlab="Indivíduos",ylab="Saida rede (preto) desejada (vermelho) ", main = "Treinamento - rede", type = "o")  
par(new=TRUE)  
plot(seq,dadosT[,varsel],axes=FALSE, ann=FALSE, pch=16,col = "red", type = "o")  
axis(4)  

predV = compute(fit,dadosV[-varsel])  
saidaV <- predV$net.result  
seq <-(1:1:nrow(dadosV))  
plot(seq,saidaV,xlab="Indivíduos",ylab="Saida rede (preto) desejada (vermelho) ", main = "Validacao - rede", type = "o")  
par(new=TRUE)  
plot(seq,dadosV[,varsel],axes=FALSE, ann=FALSE, pch=16,col = "red", type = "o")  
axis(4)  

#b. Graficos de dispersao : saida da rede vs covariavel  
nvarg= nvar-1  
for(i in 1:nvarg){  
  op=i  
  gwplot(bestfit, selected.covariate=op)  
}  

#c. Topologia da melhor rede  
plot(bestfit, rep="best")  }

ol <- garson(bestfit)
imp <- ol$data
imp
write.table(imp, "ngf_ind_imp.txt")
