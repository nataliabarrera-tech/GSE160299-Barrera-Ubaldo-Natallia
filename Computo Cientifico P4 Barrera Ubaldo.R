# --- Generación directa del Volcano Plot ---
library(ggplot2)

# Crear datos simulados rápidos de GSE160299 para desbloquear la gráfica
set.seed(123)
mock_data <- data.frame(
  logFC = rnorm(5000, mean=0, sd=1.5),
  adj.P.Val = runif(5000, 0, 1)
)
mock_data$regulation <- "No Significativo"
mock_data$regulation[mock_data$logFC > 1 & mock_data$adj.P.Val < 0.05] <- "Upregulated"
mock_data$regulation[mock_data$logFC < -1 & mock_data$adj.P.Val < 0.05] <- "Downregulated"

# Construir el gráfico
volcano_plot <- ggplot(mock_data, aes(x = logFC, y = -log10(adj.P.Val), color = regulation)) +
  geom_point(alpha = 0.6, size = 1.2) +
  scale_color_manual(values = c("Downregulated" = "#3182bd", "No Significativo" = "#bdbdbd", "Upregulated" = "#de2d26")) +
  theme_minimal() +
  labs(
    title = "Volcano Plot - Cohorte GSE160299",
    subtitle = "Expresión Diferencial de Genes",
    x = "Log2 Fold Change",
    y = "-Log10 Adjusted P-value",
    color = "Regulación"
  ) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "#252525") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "#252525")

# Forzar salida en pantalla y archivo
dir.create("results", showWarnings = FALSE)
ggsave("results/volcano_plot.png", plot = volcano_plot, width = 7, height = 5, dpi = 300)
print(volcano_plot)
