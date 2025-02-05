library(showtext)
library(colorspace)
library(cowplot)
library(here)
source(here("Codes", "theme_neat.R"))
font_size <- 10
# Please try to import Arial fonts, otherwise following codes might not be able to execute
font_add("Arial", regular = "/usr/share/fonts/TTF/arial.ttf",
         bold = "/usr/share/fonts/TTF/arialbd.ttf",
         italic = "/usr/share/fonts/TTF/ariali.ttf",
         bolditalic = "/usr/share/fonts/TTF/arialbi.ttf")
showtext_auto()

# Figure s1: scatter plot of variables by AQ score ----
f_s1_a <- eff_data_scaled_filtered %>%
  ggplot(aes(aq_total_4, efficiency)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm", se = F) +
  facet_grid(cost ~ ratio, labeller = as_labeller(
    c(
      `0.6` = "Evidence: 60/40",
      `0.8` = "Evidence: 80/20",
      `0` = "Cost: 0",
      `0.1` = "Cost: 0.1",
      `0.4` = "Cost: 0.4"
    )
  )) +
  theme_neat(base_size = font_size, base_family = "Arial") +
  labs(x = "AQ", y = "Efficiency") +
  NULL
f_s1_b <- eff_data_scaled_filtered %>%
  ggplot(aes(aq_total_4, dev)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm", alpha = 0.15, se = F) +
  facet_grid(cost ~ ratio, labeller = as_labeller(
    c(
      `0.6` = "Evidence: 60/40",
      `0.8` = "Evidence: 80/20",
      `0` = "Cost: 0",
      `0.1` = "Cost: 0.1",
      `0.4` = "Cost: 0.4"
    )
  )) +
  theme_neat(base_size = font_size, base_family = "Arial") +
  labs(x = "AQ", y = "Sampling Bias") +
  NULL
f_s1_c <- draw_var_dat_scaled_filtered %>%
  ggplot(aes(aq_total_4, sd)) +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm", alpha = 0.15, se = F) +
  facet_grid(cost ~ ratio, labeller = as_labeller(
    c(
      `0.6` = "Evidence: 60/40",
      `0.8` = "Evidence: 80/20",
      `0` = "Cost: 0",
      `0.1` = "Cost: 0.1",
      `0.4` = "Cost: 0.4"
    )
  )) +
  theme_neat(base_size = font_size, base_family = "Arial") +
  labs(x = "AQ", y = "Sampling Variability") +
  NULL
f_s1 <-
  plot_grid(f_s1_a, f_s1_b, f_s1_c, ncol = 2,
            labels = "auto",
            label_fontfamily = "Arial",
            label_size = 12)
save_plot("S1_fig.pdf", f_s1, base_width = 7.5, base_height = 7.5)

# Figure s2: by AQ group analyses ----
f_s2_a <-
  afex_plot(
    eff_aq_grp,
    x = "cost",
    mapping = c("shape", "color"),
    trace = "aq_group_4",
    panel = "ratio",
    error_ci = F,
    data_alpha = 0.3
  ) +
  geom_segment(
    data = tibble(
      x = c(1, 3),
      y = c(1.01, 0.99),
      panel = c("0.6", "0.6")
    ),
    aes(
      x = x - 0.25,
      xend = x + 0.25,
      y = y,
      yend = y
    ),
    color = "darkorange2",
    inherit.aes = F
  ) +
  geom_point(
    data = tibble(
      x = c(1, 3),
      y = c(1.01, 0.99),
      panel = c("0.6", "0.6")
    ),
    size = 1,
    aes(x = x, y = y + 0.01),
    shape = 8,
    color = "darkorange2",
    inherit.aes = F
  ) +
  facet_grid(~ panel, labeller = as_labeller(c(`0.6` = "Evidence: 60/40",
                                               `0.8` = "Evidence: 80/20"))) +
  scale_y_continuous(labels = scales::percent,
                     breaks = seq(0.7, 1, by = 0.1)) +
  scale_color_manual(values = c(
    "Low" = "#BEAED4",
    "Mid" = "#7FC97F",
    "High" = "#FDC086"
  )) +
  guides(color = guide_legend(title = "AQ group"),
         shape = guide_legend(title = "AQ group")) +
  labs(x = "Cost", y = "Efficiency") +
  theme_neat(base_size = font_size, base_family = "Arial")
f_s2_b <-
  afex_plot(
    aiccDif_aqGrp,
    x = "aq_group_4",
    mapping = c("shape", "color"),
    error_ci = F,
    data_alpha = 0.3
  ) +
  geom_hline(yintercept = 0, color = "gray50", size = 0.05) +
  annotate(
    "text",
    label = "Cost-first",
    x = 3.2,
    y = -250,
    hjust = 0,
    family = "Arial",
    size = 3,
  ) +
  annotate(
    "text",
    label = "Evidence-first",
    x = 3.2,
    y = 250,
    hjust = 0,
    size = 3,
    family = "Arial"
  ) +
  annotate(
    "segment",
    x = 3.15,
    xend = 3.15,
    y = -100,
    yend = -400,
    arrow = arrow(length = unit(1, "mm"))
  ) +
  annotate(
    "segment",
    x = 3.15,
    xend = 3.15,
    y = 100,
    yend = 400,
    arrow = arrow(length = unit(1, "mm"))
  )  +
  geom_segment(
    data = tibble(
      x = c(1, 2),
      xend = c(3, 3),
      y = c(880, 580)
    ),
    aes(
      x = x,
      xend = xend,
      y = y,
      yend = y
    ),
    color = "darkorange2",
    inherit.aes = F
  ) +
  geom_point(
    data = tibble(
      x = c(2, 2.5),
      y = c(880, 580)
    ),
    size = 1,
    aes(x = x, y = y + 110),
    shape = 8,
    color = "darkorange2",
    inherit.aes = F
  ) +
  scale_color_manual(values = c(
    "Low" = "#BEAED4",
    "Mid" = "#7FC97F",
    "High" = "#FDC086"
  )) +
  coord_cartesian(xlim = c(1, 3.2), clip = "off") +
  labs(x = "AQ group", y = "Cost-evidence strategy index") +
  theme_neat(base_size = font_size, base_family = "Arial") +
  theme(legend.position = "none")
f_s2 <- plot_grid(f_s2_a, f_s2_b, nrow = 2,
                  labels = "auto",
                  label_size = 12,
                  label_fontfamily = "Arial",
                  axis = "lb",
                  align = "hv",
                  rel_heights = c(1.1, 1))
save_plot("s2_fig.pdf", f_s2, device = cairo_pdf, base_height = 8, base_width = 5)

# Figure s3: Bimodal distribution for each individual & Model prediction ----
source(here("Codes", "f_s3_multiplot.R"))

# Figure s4: RT by sample number ----
f_s4 <-
  ggplot(avg_rt_draw_aq_data, aes(x = draw)) +
  stat_summary(
    aes(y = m, color = "1"),
    fun.data = mean_cl_boot
  ) +
  stat_summary(aes(y = lg_rt_sim, color = "2"),
               data = unnest(filter(rt_sim, model == "os_costOnly")),
               fun.y = mean,
               geom = "point"
  ) +
  stat_summary(aes(y = lg_rt_sim, color = "3"),
               data = unnest(filter(rt_sim, model == "ts_decay")),
               fun.y = mean,
               geom = "point"
  ) +
  scale_y_continuous(breaks = log(c(130, 200, 270)),
                     labels = c(130, 200, 270),
                     limits = c(1, Inf)) +
  coord_cartesian(ylim = c(4.8, 5.6)) +
  scale_color_manual(
    values = c("1" = "#8A8A8D",
               "2" = "#00BFFF",
               "3" = "#FF6F61"),
    labels = c("Data", "One-stage prediction", "Two-stage prediction")
  ) +
  labs(y = "DT (ms)",
       x = "Sample number",
       color = "") +
  theme_neat(base_size = font_size, base_family = "Arial") +
  NULL
ggsave("f_s4.pdf", f_s4, device = cairo_pdf, width = 6, height = 4)

# Figure s5: Individual AICc & BIC ----
f_s5_a <- choice_rt_gof %>%
  group_by(id) %>%
  mutate(del_AICc = AICc - min(AICc)) %>%
  ungroup() %>%
  left_join(select(sub_info, id, aq_total_4)) %>%
  mutate(
    model = map_chr(model, replace_model_name),
    model = factor(model),
    model = fct_reorder(model, del_AICc, mean),
    id = factor(id),
    id = fct_reorder(id, aq_total_4)
  ) %>%
  select(id, model, AICc, del_AICc) %>%
  ggplot(aes(x = model, y = del_AICc, color = del_AICc)) +
  stat_summary(fun.data = mean_se, fatten = 0.9) +
  labs(y = "Mean \u0394AICc") +
  coord_flip() +
  theme_neat(base_size = font_size, base_family = "Arial") +
  theme(axis.title.y = element_blank(),
        plot.margin = margin(8, 2, 4, 4, "pt")) +
  NULL
f_s5_b <- choice_rt_gof %>%
  group_by(id) %>%
  mutate(del_BIC = BIC - min(BIC)) %>%
  ungroup() %>%
  left_join(select(sub_info, id, aq_total_4)) %>%
  mutate(
    model = map_chr(model, replace_model_name),
    model = factor(model),
    model = fct_reorder(model, del_BIC, mean),
    id = factor(id),
    id = fct_reorder(id, aq_total_4)
  ) %>%
  select(id, model, BIC, del_BIC) %>%
  ggplot(aes(x = model, y = del_BIC, color = del_BIC)) +
  stat_summary(fun.data = mean_se, fatten = 0.9) +
  labs(y = "Mean \u0394BIC") +
  coord_flip() +
  theme_neat(base_size = font_size, base_family = "Arial") +
  theme(axis.title.y = element_blank(),
        plot.margin = margin(8, 4, 4, 2, "pt")) +
  NULL
f_s5_c <- choice_rt_gof %>%
  group_by(id) %>%
  mutate(del_AICc = AICc - min(AICc)) %>%
  ungroup() %>%
  left_join(select(sub_info, id, aq_total_4)) %>%
  mutate(
    model = map_chr(model, replace_model_name),
    model = factor(model),
    model = fct_reorder(model, del_AICc, mean),
    id = factor(id),
    id = fct_reorder(id, aq_total_4)
  ) %>%
  select(id, model, AICc, del_AICc) %>%
  ggplot(aes(x = id, y = model, fill = del_AICc)) +
  geom_raster() +
  scale_fill_continuous_sequential(name = "\u0394AICc",
                                   palette = "Viridis") +
  theme_neat(base_size = font_size, base_family = "Arial") +
  theme(
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.line = element_blank(),
    legend.position = "right",
    legend.direction = "vertical",
    plot.margin = margin(5, 5, 5, 5, "pt")
  )
f_s5_d <- choice_rt_gof %>%
  group_by(id) %>%
  mutate(del_BIC = BIC - min(BIC)) %>%
  ungroup() %>%
  left_join(select(sub_info, id, aq_total_4)) %>%
  mutate(
    model = map_chr(model, replace_model_name),
    model = factor(model),
    model = fct_reorder(model, del_BIC, mean),
    id = factor(id),
    id = fct_reorder(id, aq_total_4)
  ) %>%
  select(id, model, BIC, del_BIC) %>%
  ggplot(aes(x = id, y = model, fill = del_BIC)) +
  geom_raster() +
  scale_fill_continuous_sequential(name = "\u0394BIC",
                                   palette = "Viridis") +
  theme_neat(base_size = font_size, base_family = "Arial") +
  theme(
    axis.title = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.line = element_blank(),
    legend.position = "right",
    legend.direction = "vertical",
    plot.margin = margin(5, 5, 5, 5, "pt")
  )
f_s5 <-
  plot_grid(plot_grid(f_s5_a, f_s5_b, ncol = 2, labels = c("a", "b"),
                      label_size = 12, label_fontface = "bold", label_fontfamily = "Arial"),
            f_s5_c, f_s5_d, ncol = 1, labels = c(NA, "c", "d"), label_size = 12,
            label_y = 1.05, label_fontfamily = "Arial")
save_plot("f_s5.pdf", f_s5, device = cairo_pdf, base_width = 7.5, base_height = 8.75)

# Figure s6: Individual choice distribution and model prediction ----
source(here("Codes", "f_s6_multiplot.R"))

# Figure s7: Other demographic variales ~ AICc difference ----
f_s7_1_cortxt <-
  famwise_aicc_diff %>%
  select(id, ts_vs_ts2) %>%
  left_join(sub_info) %>% cor_txt(ts_vs_ts2, age, method = "spearman") %>%
  mutate(x = -3000, y = min(sub_info$age))
f_s7_2_cortxt <-
  famwise_aicc_diff %>%
  select(id, ts_vs_ts2) %>%
  left_join(sub_info) %>% cor_txt(ts_vs_ts2, raven, method = "spearman") %>%
  mutate(x = -3000, y = min(sub_info$raven))
f_s7_3_cortxt <-
  famwise_aicc_diff %>%
  select(id, ts_vs_ts2) %>%
  left_join(sub_info) %>%
  mutate(gender = as.integer(gender) - 1) %>%
  cor_txt(ts_vs_ts2, gender, method = "pearson") %>%
  mutate(text = map(text, ~str_replace(.x, "r", "r[Biserial]"))) %>%
  mutate(x = -3000, y = 0.25)
f_s7_1 <-
  famwise_aicc_diff %>%
  select(id, ts_vs_ts2) %>%
  left_join(sub_info) %>%
  ggplot(aes(x = ts_vs_ts2, y = age)) +
  geom_vline(xintercept = 0,
             color = "gray50",
             size = 0.05) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_text(
    aes(x = x, y = y, label = text),
    data = f_s7_1_cortxt,
    parse = T,
    size = 3,
    color = "#555459",
    hjust = 0.5,
    family = "Arial"
  ) +
  annotate(
    "text",
    label = "Cost-first",
    x = -100,
    y = 15,
    hjust = 1,
    family = "Arial",
    size = 3
  ) +
  annotate(
    "text",
    label = "Evidence-first",
    x = 100,
    y = 15,
    hjust = 0,
    family = "Arial",
    size = 3
  ) +
  annotate(
    "segment",
    x = -100,
    xend = -500,
    y = 14,
    yend = 14,
    arrow = arrow(length = unit(1, "mm"))
  ) +
  annotate(
    "segment",
    x = 100,
    xend = 500,
    y = 14,
    yend = 14,
    arrow = arrow(length = unit(1, "mm"))
  )  +
  coord_cartesian(clip = "off") +
  labs(x = "Cost-evidence strategy index",
       y = "Age") +
  theme_neat(font_size, base_family = "Arial")
f_s7_2 <-
  famwise_aicc_diff %>%
  select(id, ts_vs_ts2) %>%
  left_join(sub_info) %>%
  ggplot(aes(x = ts_vs_ts2, y = raven)) +
  geom_vline(xintercept = 0,
             color = "gray50",
             size = 0.05) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_text(
    aes(x = x, y = y, label = text),
    data = f_s7_2_cortxt,
    parse = T,
    size = 3,
    color = "#555459",
    hjust = 0.5,
    family = "Arial"
  ) +
  annotate(
    "text",
    label = "Cost-first",
    x = -100,
    y = 60,
    hjust = 1,
    family = "Arial",
    size = 3
  ) +
  annotate(
    "text",
    label = "Evidence-first",
    x = 100,
    y = 60,
    hjust = 0,
    family = "Arial",
    size = 3
  ) +
  annotate(
    "segment",
    x = -100,
    xend = -500,
    y = 59,
    yend = 59,
    arrow = arrow(length = unit(1, "mm"))
  ) +
  annotate(
    "segment",
    x = 100,
    xend = 500,
    y = 59,
    yend = 59,
    arrow = arrow(length = unit(1, "mm"))
  )  +
  coord_cartesian(clip = "off") +
  labs(x = "Cost-evidence strategy index",
       y = "IQ (raw score)") +
  theme_neat(font_size, base_family = "Arial")
f_s7_3 <-
  famwise_aicc_diff %>%
  select(id, ts_vs_ts2) %>%
  left_join(sub_info) %>%
  ggpubr::ggstripchart(x = "gender", y = "ts_vs_ts2", add = "boxplot") +
  ggpubr::stat_compare_means(label.x = 1.5, label.y = -3500, hjust = 0.5,
                             size = 3, family = "Arial") +
  geom_hline(yintercept = 0, color = "gray50", size = 0.05) +
  annotate(
    "text",
    label = "Cost-first",
    x = 2.6,
    y = -250,
    hjust = 0,
    family = "Arial",
    size = 3,
  ) +
  annotate(
    "text",
    label = "Evidence-first",
    x = 2.6,
    y = 250,
    hjust = 0,
    size = 3,
    family = "Arial"
  ) +
  annotate(
    "segment",
    x = 2.55,
    xend = 2.55,
    y = -100,
    yend = -400,
    arrow = arrow(length = unit(1, "mm"))
  ) +
  annotate(
    "segment",
    x = 2.55,
    xend = 2.55,
    y = 100,
    yend = 400,
    arrow = arrow(length = unit(1, "mm"))
  )  +
  coord_cartesian(xlim = c(1, 2.5)) +
  scale_x_discrete(labels = c("f" = "Female", "m" = "Male")) +
  labs(y = "Cost-evidence strategy index",
       x = "Gender") +
  theme_neat(font_size, base_family = "Arial")
f_s7 <- plot_grid(f_s7_1, f_s7_2, f_s7_3, nrow = 3,
                  labels = "auto", label_size = 12, label_fontfamily = "Arial")
save_plot("s7_fig.pdf", f_s7, base_width = 6, base_height = 8)

# Figure s8: AICc difference ~ Bias & Variation ----
source(here("Codes", "corr.test2.R"))
f_sup_dev_df <-
  famwise_aicc_diff %>%
  select(id, ts_vs_ts2) %>%
  left_join(dev_wide) %>% {
    corr.test2(
      select(., `0_0.6`:`0.4_0.8`),
      select(., contains("_vs_")),
      method = "spearman", adjust = "fdr"
    )
  } %>% {left_join(rownames_to_column(.$ci, "cost_ratio"), .$ci.adj)} %>%
  mutate(cost_ratio = str_extract(cost_ratio, ".*(?=-)"),
         cost_ratio = str_c("C:", cost_ratio),
         cost_ratio = str_replace(cost_ratio, "_", ", E:")) %>%
  mutate(
    sig = if_else(p < .05, "*p < .05", if_else(p < .1, "+p < .1", "p >= .1")),
    var = "Sampling Bias"
  )
f_sup_sd_df <-
  famwise_aicc_diff %>%
  select(id, ts_vs_ts2) %>%
  left_join(sd_wide) %>% {
    corr.test2(
      select(., `0_0.6`:`0.4_0.8`),
      select(., contains("_vs_")),
      method = "spearman", adjust = "fdr"
    )
  } %>% {left_join(rownames_to_column(.$ci, "cost_ratio"), .$ci.adj)} %>%
  mutate(cost_ratio = str_extract(cost_ratio, ".*(?=-)"),
         cost_ratio = str_c("C:", cost_ratio),
         cost_ratio = str_replace(cost_ratio, "_", ", E:")) %>%
  mutate(
    sig = if_else(p < .05, "*p < .05", if_else(p < .1, "+p < .1", "p >= .1")),
    var = "Sampling Variation"
  )
f_s8 <-
  bind_rows(f_sup_dev_df, f_sup_sd_df) %>%
  ggplot(aes(
    cost_ratio,
    r,
    ymin = lower.adj,
    ymax = upper.adj,
    color = sig
  )) +
  geom_hline(yintercept = 0,
             linetype = "dashed",
             color = "grey50") +
  geom_pointrange(fatten = 1, size = 0.8) +
  facet_grid( ~ var, scales = "free_x") +
  coord_flip() +
  scale_color_manual(
    values = c(
      "p >= .1" = "#0D0887FF",
      "+p < .1" = "#B12A90FF",
      "*p < .05" = "#FCA636FF"
    ),
    guide = guide_legend(override.aes = list(size = 0.4))
  ) +
  labs(x = "", y = "Correlation with cost-evidence strategy index", color = "") +
  theme_neat(font_size, base_family = "Arial")
ggsave("s8_fig.pdf", f_s8, device = cairo_pdf, width = 6, height = 4)

# Figure s9: AQ Distribution ----
f_s9 <- sub_info %>%
  ggplot(aes(x = aq_total_4)) +
  stat_density(geom = "line") +
  geom_point(aes(y = 0.0025), alpha = 0.15, position = position_jitter(height = 0.0005, width = 0, seed = 123)) +
  labs(x = "AQ Scores", y = "Density") +
  theme_neat(base_size = font_size, base_family = "Arial")
ggsave("f_s9.pdf", f_s9, device = cairo_pdf, width = 6, height = 4)

# Figure s10: Noncompliant observations ----
f_s10 <-
  avg_num_bead_dat %>%
  ggplot(aes(cost, draw_times)) +
  geom_boxplot(outlier.color = "salmon") +
  labs(x = "Cost", y = "Number of bead samples") +
  facet_grid(~ratio, labeller = as_labeller(c("0.6" = "Evidence: 60/40",
                                              "0.8" = "Evidence: 80/20"))) +
  theme_neat(base_size = font_size, base_family = "Arial")
save_plot("f_s10.pdf", f_s10, device = cairo_pdf, base_height = 4, base_width = 6)
