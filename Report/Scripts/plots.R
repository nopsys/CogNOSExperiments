theme_simple <- function(font_size = 12) {
    theme_bw() +
    theme(axis.text.x          = element_text(size = font_size, lineheight=0.7),
          axis.title.x         = element_blank(),
          axis.title.y         = element_text(size = font_size),
          axis.text.y          = element_text(size = font_size),
          axis.line            = element_line(colour = "gray"),
          plot.title           = element_text(size = font_size),
          legend.text          = element_text(size = font_size),
          panel.background     = element_blank(), #element_rect(fill = NA, colour = NA),
          panel.grid.major     = element_blank(),
          panel.grid.minor     = element_blank(),
          panel.border         = element_blank(),
          plot.background      = element_blank(), #element_rect(fill = NA, colour = NA)
          strip.background     = element_blank(),
          strip.text           = element_text(size = font_size),
          plot.margin = unit(c(0,0,0,0), "cm")) 
}

element90 <- function() { element_text(angle = 90, hjust = 1, vjust=0.5) }

warmup_plot <- function (data, title, xAxis, hLines = c(), titleSize = 8, group = "VM") {
  p <- ggplot(data)
  p <- p + geom_line(aes_string(x="Iteration", y="RuntimeRatio", colour = group))
  p <- p + scale_color_manual(values=c("MATEpe"="blue", "MATEmt"="green"))
  p <- p + ggtitle(title)
  p <- p + theme_simple()
  p <- p + theme(legend.position = "none", axis.title.y=element_blank(),
                 plot.title = element_text(size = titleSize, hjust = 0.5),
                 plot.margin = unit(c(0.1,0.1,0.1,0.1), "lines"))
  if (!xAxis){
    p <- p + theme(axis.text.x=element_blank())
  }
  p <- p + scale_y_continuous(labels=scaleFUN)
  p <- p + scale_x_continuous()
  if (length(hLines) > 0){
    p <- p + geom_hline(aes(yintercept = hLines[[1]][1]), linetype="dashed", alpha=0.4, color = "blue")
    p <- p + geom_ribbon(data = data.frame(x=c(1:100)), aes(x = 1:100, ymin = rep(hLines[[1]][2], 100), 
                             ymax = rep(hLines[[1]][3], 100)), fill = "blue", alpha = 0.2)
    p <- p + geom_hline(aes(yintercept = hLines[[2]][1]), linetype="dashed", alpha=0.4, color = "green")
    p <- p + geom_ribbon(data = data.frame(x=c(1:100)), aes(x = 1:100, ymin = rep(hLines[[2]][2], 100), 
                             ymax = rep(hLines[[2]][3], 100)), fill = "green", alpha = 0.2)
  }
  return(p)
}

boxplot <- function (data, axisYText, titleVertical, baselineNames, fill = FALSE) {
  normalizedOverall <- data.frame(matrix(NA, nrow = 0, ncol = length(data[[1]])))
  colnames(normalizedOverall) <- colnames(data[[1]])
  for (i in 1:length(data)) {
    if (length(baselineNames) == length(data)){
      normalized <- normalizeData(data[[i]], ~ Benchmark, baselineNames[[i]], FALSE)
    } else {
      normalized <- data[[i]]
    }
    normalizedOverall <- rbind(normalizedOverall, normalized)
  }
  p <- ggplot(normalizedOverall, aes(x = Benchmark, y = RuntimeRatio))
  if (fill){
    p <- p + facet_grid(~VM, labeller = label_parsed)
  }
  p <- p + geom_hline(yintercept = 1, linetype = "dashed")
  p <- p + geom_boxplot(outlier.size = 0.9) + theme_simple()
  p <- p + scale_y_continuous(name=titleVertical) + 
    theme(panel.border = element_rect(colour = "black", fill = NA),
          plot.margin=unit(x=c(0.4,0,0,0),units="mm"),
          text = element_text(size = 8))
  if (axisYText){
    p <- p + theme (axis.text.x = element_text(angle = 90, hjust = 1, vjust=0.5))
  } else {
    p <- p + theme (axis.text.x = element_blank())
  }
  #p <- p + ggtitle(titleHorizontal)	
  p
}

overview_box_plot <- function(stats, yLimits) {
  stats$VM <- reorder(stats$VM, X=-stats$OF)
  
  breaks <- levels(droplevels(stats)$VM)
  col_values <- sapply(breaks, function(x) vm_colors[[x]])
  
  plot <- ggplot(stats, aes(x=VM, y=OF, fill = VM))
  
  plot <- plot +
    geom_boxplot(outlier.size = 0.5) + #fill=get_color(5, 7)
    theme_bw() + theme_simple(font_size = 12) +
    labs(x="") +
    theme(
      axis.title.x = element_blank(),
      axis.text.x = element_text(angle= 90, vjust=0.5, hjust=1), 
      legend.position="none", 
      plot.title = element_text(hjust = 0.5)) +
    #scale_y_log10(breaks=c(1,2,3,10,20,30,50,100,200,300,500,1000)) + #limit=c(0,30), breaks=seq(0,100,5), expand = c(0,0)
    #ggtitle("Runtime Factor, normalized to Java (lower is better)") + xlab("") +
    scale_fill_manual(values = col_values)
  if (!missing(yLimits)){
    plot <- plot + coord_flip(ylim = yLimits)
  } else {
    plot <- plot + coord_flip()	
  }
  plot
}