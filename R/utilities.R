#' JK resampling for dist function
#' @export
#' @param
dist_JK <- function(m,  method = "euclidean",  p = 2){
  alldst <- list()

  for (i in 1:ncol(m)) {
    alldst[[i]] <- dist(m[,-i], method = method, p = p)
  }

  xx <- Reduce("cbind",alldst)
  xx <- matrixStats::rowMedians(xx, na.rm = TRUE)
  res <- dist(m, method = method, p = p)
  res[1:length(res)] <- xx
  return(res)
}

#' plot cluster
#' @export
plotK <- function(scaledM, k , idx ){
  scM <- scaledM[ k == idx,, drop = FALSE]
  matplot(t(scM), col = "lightgray", type = "l", main = paste0("cluster ", idx))
  lines(1:ncol(scaledM), apply(scM,2, mean, na.rm = TRUE), lwd = 2 )
  return(scM)
}


#' helper function mapping clusters
#' @export
mapthe <- function(scaledM, cluster){
  background <- data.frame(SW = rownames(scaledM))
  cluster <- data.frame(SW = rownames(cluster))
  background <- prora::get_UniprotID_from_fasta_header(background, idcolumn = "SW")
  cluster <- prora::get_UniprotID_from_fasta_header(cluster, idcolumn = "SW")
  background <- prora::map_ids_uniprot(background)
  cluster <- prora::map_ids_uniprot(cluster)
  return(list(background = na.omit(background), cluster = na.omit(cluster)))
}
