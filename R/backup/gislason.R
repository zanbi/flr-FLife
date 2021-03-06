#' gislason
#' @description 
#' gislason natural mortality relatoinship estimate M as a function of length. 
#' M=a*length^b; 
#' 
#' @param length  mass at which M is to be predicted
#' @param params \code{FLPar} with two values; i.e. a equal to M at unit mass 
#' and b a power term; defaults are a=0.3 and b=-0.288
#' @param a 0.55
#' @param b 1.44
#' @param c -1.61
#' @param ... any other arguments
#' 
#' @aliases  gislason gislason-method 
#'           gislason,FLQuant,FLPar-method 
#'           gislason,FLQuant,missing-method 
#'           gislason,FLQuant,numeric-method
#'
#' @export
#' @docType methods
#' @rdname gislason
#' 
#' @seealso \code{\link{lorenzen}}
#'  
#' @examples
#' \dontrun{
#' params=lhPar(FLPar(linf=111))
#' len=FLQuant(c( 1.90, 4.23, 7.47,11.48,16.04,20.96,26.07,31.22,
#'                36.28,41.17,45.83,50.20,54.27,58.03,61.48,64.62),
#'              dimnames=list(age=1:16))
#' gislason(length,params)
#' }
setMethod('gislason', signature(length='FLQuant',params='numeric'),
      function(length,params,a=0.55,b=1.44,c=-1.61,...) { 
          res=gislasonFn(length,params)
          res@units='yr^-1'
          res})
setMethod('gislason', signature(length='FLQuant',params='FLPar'),
      function(length,params,a=0.55,b=1.44,c=-1.61,...){   
          res=gislasonFn(length,params)
          res@units='yr^-1'
          res})

gislasonFn<-function(length,params,a=0.55,b=1.44,c=-1.61) {
  
#  log(M)=a+blog(L)+c*log(Linf)+log(k)
  
  # Natural mortality parameters from Model 2, Table 1 gislason 2010
  if (!all(c("m1","m2")%in%dimnames(params)$params)){
    
    m1=FLPar(m1= a*(params["linf"]^b)%*%params["k"], iter=dims(params)$iter)
    m2=FLPar(m2=c                           ,        iter=dims(params)$iter)
    params=rbind(params,m1,m2)
  }
  
  params["m1"]%*%(exp(log(length)%*%params["m2"]))}

