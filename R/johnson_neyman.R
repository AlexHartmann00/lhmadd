#'Generate Johnson-Neyman plot
#'
#'Internal function to generate johnson-neyman plot given parameters
#'
#'@param B coefficient vector
#'@param sigma covariance matrix
#'@param x name of IV
#'@param m name of M
#'@param df df for t-test
#'@param resolution step count for solver
#'
#'@return Johnson-neyman plot
#'
#'@noRd
#'
.johnson_neyman <- function(B,sigma,x,m,modrange,df,resolution=10000,sig.thresh=0.05){
  xname <- x
  intname <- paste(x,m,sep=":")
  modname <- m

  xindex <- (1:length(B))[names(B) == xname]
  modindex <- (1:length(B))[names(B) == modname]
  intindex <- (1:length(B))[names(B) == intname]

  b_1 <- B[xindex]
  b_3 <- B[intindex]

  w_1 <- function(M){
    b_1 + b_3*M
  }

  var_b1 <- sigma[xindex,xindex]
  var_b3 <- sigma[intindex,intindex]
  cov_b1b3 <- sigma[intindex,xindex]

  se <- function(M){
    sqrt(var_b1 + var_b3*M^2 + M*cov_b1b3)
  }

  t <- function(M){
    w_1(M)/se(M)
  }

  modoptions <- seq(modrange[1],modrange[2],length.out = resolution)

  ts <- t(modoptions)
  ses <- se(modoptions)

  critical_t <- qt(sig.thresh/2,df)

  significance <- ifelse(abs(ts) > abs(critical_t),"at p<0.05","n.s.")
  w_1_vals <- w_1(modoptions)

  data <- data.frame(M=modoptions,W=w_1_vals,SE=ses,low=w_1_vals-1.96*ses,up=w_1_vals+1.96*ses,sig=significance)

  nsdf <- data
  nsdf[data$sig != "n.s.",4:5] <- cbind(data[data$sig != "n.s.",2],data[data$sig != "n.s.",2])
  sigdf <- data
  sigdf[data$sig == "n.s.",4:5] <- cbind(data[data$sig == "n.s.",2],data[data$sig == "n.s.",2])

  sigrange <- round(range(data$M[data$sig != "n.s."]),4)
  nsigrange <- round(range(data$M[data$sig == "n.s."]),4)

  if(sigrange[2]-sigrange[1] > nsigrange[2]-nsigrange[1]){
    print(paste("Effect of",x,"significant for",m, "outside",nsigrange[1],",",nsigrange[2]))
  }
  else{
    print(paste("Effect of",x,"significant for",m, "inside",sigrange[1],",",sigrange[2]))
  }

  legenddf <- data.frame(x=c(mean(modrange)-0.001,mean(modrange+0.001)),y=c(-0.001,0.001),sig=c("n.s.",paste("p <",sig.thresh)))

  plt <- ggplot2::ggplot() +
    ggplot2::geom_line(aes(modoptions,w_1_vals)) +
    ggplot2::geom_hline(yintercept=0,linetype="dashed")+
    ggplot2::geom_ribbon(data=legenddf,aes(x,y,ymin=y-0.0001,ymax=y+0.001,fill=sig),alpha=0)+
    ggplot2::geom_ribbon(data = nsdf,aes(M,W,
                    ymin=low,
                    ymax=up),fill="red",alpha=0.3)+
    ggplot2::geom_ribbon(data = sigdf,aes(M,W,
                    ymin=low,
                    ymax=up),fill="lightblue",alpha=0.3)+
    ggplot2::labs(x=modname,y=paste("slope of",xname),fill="")+
    ggplot2::lims(x=modrange,y=range(c(data$low,data$up)))+
    ggplot2::scale_fill_manual(values=c("red","lightblue"))+
    ggplot2::theme_classic()

  return(plt)
}
