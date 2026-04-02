# ============================================================================
# R 语言开发功能测试脚本
# 用于测试 Helix 编辑器的 R 语言支持
# ============================================================================

# 1. 基础变量定义测试
# --------------------
# 测试变量定义和语法高亮
numeric_var <- 42 # 数值型变量
character_var <- "Hello, R!" # 字符型变量
logical_var <- TRUE # 逻辑型变量
vector_var <- c(1, 2, 3, 4, 5) # 向量
list_var <- list(a = 1, b = "text") # 列表

# 2. 函数定义和调用测试
# ----------------------
# 定义一个简单的函数，测试函数语法和参数补全
calculate_stats <- function(data_vector, method = "mean") {
  # 测试函数内部的语法高亮
  if (method == "mean") {
    result <- mean(data_vector, na.rm = TRUE)
  } else if (method == "median") {
    result <- median(data_vector, na.rm = TRUE)
  } else if (method == "sd") {
    result <- sd(data_vector, na.rm = TRUE)
  } else {
    stop("Unknown method. Use 'mean', 'median', or 'sd'")
  }

  # 返回结果
  return()(result)
}

# 3. 数据操作测试
# ----------------
# 测试数据框操作和语法补全
test_dataframe <- data.frame(
  id = 1:10,
  name = paste("Sample", 1:10),
  value = rnorm(100, mean = 50, sd = 5)
)

# 测试数据框方法补全
print(head(test_dataframe))
print(summary(test_dataframe))

# 4. 包载入测试
# --------------
# 测试包名补全和导入
if (!require(dplyr)) {
  # 如果没有安装 dplyr，显示提示信息
  cat("dplyr package not found. Install with: install.packages('dplyr')\n")
} else {
  # 测试 dplyr 功能
  library(dplyr)

  # 使用管道操作符，测试语法高亮
  processed_data <- test_dataframe %>%
    filter(value > 40) %>%
    mutate(category = ifelse(value > 50, "High", "Low")) %>%
    select(id, value, category)

  print(processed_data)
}

# 5. 图形绘制测试
# ----------------
# 测试绘图函数补全
if (!require(ggplot2)) {
  cat("ggplot2 package not found. Install with: install.packages('ggplot2')\n")
} else {
  library(ggplot2)

  # 创建基础图形，测试 ggplot2 语法
  p <- ggplot(test_dataframe, aes(x = id, y = value)) +
    geom_point(color = "blue", size = 3) +
    geom_smooth(method = "lm", se = FALSE, color = "red") +
    labs(
      title = "Helix Editor R Integration Test",
      subtitle = "Scatter plot with linear regression line",
      x = "Sample ID",
      y = "Value"
    ) +
    theme_light()

  # 保存图片时添加错误处理
  tryCatch(
    {
      ggsave("test_ggplot2.png", plot = p, dpi = 600, width = 8, height = 6)
      cat("Plot saved successfully as test_ggplot2.png\n")
    },
    error = function(e) {
      cat("Error saving plot:", e$message, "\n")
      # 如果保存失败，仍然显示图形
      print(p)
    }
  )
}

# 6. 错误处理测试
# ----------------
# 测试错误处理和语法检查
tryCatch(
  {
    # 故意制造一个错误来测试错误检测
    result <- sqrt(-1) # 这会产生 NaN，但不是错误
    print(paste("Square root of -1:", result))
  },
  error = function(e) {
    print(paste("Error occurred:", e$message))
  }
)

# 7. 自定义类和方法测试
# ---------------------
# 定义 S3 类和方法，测试复杂语法
create_test_object <- function(name, data) {
  structure(
    list(
      name = name,
      data = data,
      created_at = Sys.time()
    ),
    class = "TestObject"
  )
}

# 打印方法
print.TestObject <- function(x) {
  cat("Test Object: ", x$name, "\n")
  cat("Data summary:\n")
  print(summary(x$data))
  cat("Created at:", x$created_at, "\n")
}

# 创建对象实例
test_obj <- create_test_object("My Test", rnorm(100))
print(test_obj)

# 8. 包管理测试
# -------------
# 测试已安装的包列表
cat("\nInstalled packages that start with 'r':\n")
all_packages <- rownames(installed.packages())
r_packages <- all_packages[grep("^r", tolower(all_packages))]
print(head(r_packages, 10))

# 9. 实用工具函数测试
# -------------------
# 测试常用统计函数的补全
sample_data <- rnorm(1000, mean = 500, sd = 10)

# 各种统计函数
stats_summary <- list(
  mean_value = mean(sample_data),
  median_value = median(sample_data),
  sd_value = sd(sample_data),
  var_value = var(sample_data),
  min_value = min(sample_data),
  max_value = max(sample_data),
  quantiles = quantile(sample_data, probs = c(0.25, 0.5, 0.75))
)

print(stats_summary)

# 10. 文件操作测试
# ----------------
# 测试文件相关函数的补全
temp_file <- tempfile(fileext = ".csv")
write.csv(test_dataframe, temp_file, row.names = FALSE)
cat("Temporary CSV file created:", temp_file, "\n")

# 读取文件
read_data <- read.csv(temp_file)
cat("Rows read from temporary file:", nrow(read_data), "\n")

# 清理临时文件
unlink(temp_file)

# 11. 最终测试结果
# ----------------
cat("\n=== R Development Environment Test Complete ===\n")
cat("Tested features:\n")
cat("- Variable definitions\n")
cat("- Function creation and calls\n")
cat("- Data frame operations\n")
cat("- Package loading and usage\n")
cat("- Error handling\n")
cat("- Custom classes and methods\n")
cat("- Statistical functions\n")
cat("- File operations\n")
cat("- Plotting (if packages available)\n")
cat(
  "\nIf you see this message without errors, basic R functionality is working!\n"
)

# 测试完成标志
test_completed_successfully <- TRUE
print(paste("All tests completed at:", Sys.time()))
